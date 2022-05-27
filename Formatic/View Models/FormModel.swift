//
//  FormModel.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation
import SwiftUI
import CoreData

class FormModel: ObservableObject {
    
    func validNumber(number: String, range: ClosedRange<Double>? = nil) -> Bool {
        // Check if field only contains nubmers
        if let number = Double(number) {
            // Check if number is in range
            if let range = range {
                if number >= range.lowerBound && number <= range.upperBound {
                    return true
                }
                else {
                    return false
                }
            }
            // Number is valid, but there is no range
            else {
                return true
            }
        }
        else {
            // Have only typed negative sign
            if number == "-" {
                return true
            }
            // Not a valid number
            return false
        }
    }
    
    func validTitle(title: String) throws -> Bool {
        try withAnimation {
            do {
                let forms = try getForms()
                
                if forms.contains(where: { form in
                    form.title == title
                }) {
                    return false
                }
                else {
                    if !title.isEmpty {
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
            catch {
                throw FormError.fetchError
            }
        }
    }
    
    func encodeFormToJsonData(form: Form) throws -> Data {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(form)
            return data
        }
        catch {
            throw FormError.encodeFormToJsonDataError
        }
    }
    
    func decodeJsonDataToForm(data: Data) throws -> Form {
        let decoder = JSONDecoder()
        do {
            let form = try decoder.decode(Form.self, from: data)
            return form
        }
        catch {
            throw FormError.decodeJsonDataToFormError
        }
    }
    
    func importForm(url: URL) throws {
        do {
            let data = try urlToData(url: url)
            do {
                let newForm = try decodeJsonDataToForm(data: data)
                do {
                    let forms = try getForms()
                    if forms.contains(where: { form in
                        form.title == newForm.title && form.id != newForm.id
                    })
                    {
                        resolveDuplicateFormName(newForm: newForm, forms: forms)
                    }
                    DataController.saveMOC()
                }
                catch {
                    throw FormError.fetchError
                }
            }
            catch {
                throw FormError.decodeJsonDataToFormError
            }
        }
        catch {
            throw FormError.urlToDataError
        }
        DataController.saveMOC()
    }
    
    func getForms() throws -> [Form] {
        let formsRequest: NSFetchRequest<Form> = Form.fetchRequest()
        do {
            let forms = try DataController.shared.container.viewContext.fetch(formsRequest)
            return forms
        }
        catch {
            throw FormError.fetchError
        }
    }
    
    func getWidgetsInSection(section: Section) -> [Widget] {
        return section.widgets?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) ?? []
    }
    
    func urlToData(url: URL) throws -> Data {
        var data = Data()
        do {
            data = try Data(contentsOf: url)
            return data
        }
        catch {
            throw FormError.urlToDataError
        }
    }
    
    func numberOfWidgetsInSection(section: Section) -> Int {
        return getWidgetsInSection(section: section).count
    }
    
    func resolveDuplicateFormName(newForm: Form, forms: [Form]) {
        var newTitleFound = false
        var index = 1
        while !newTitleFound {
            let newTitle = "\(newForm.title ?? "") (\(index))"
            if !forms.contains(where: { form in
                form.title == newTitle
            }) {
                newTitleFound = true
                newForm.title = newTitle
            }
            else {
                index += 1
            }
        }
    }
    
    func deleteFormWithIndexSet(indexSet: IndexSet) throws {
        do {
            let forms = try getForms()
            
            for index in indexSet {
                let form = forms[index]
                DataController.shared.container.viewContext.delete(form)
                
                // Update positions starting with form after deleted index
                for index in index+1..<forms.count {
                    forms[index].position = forms[index].position - 1
                }
            }
            DataController.saveMOC()
        }
        catch {
            throw FormError.fetchError
        }
    }
    
    func deleteWidgetWithIndexSet(section: Section, indexSet: IndexSet) {
        let widgets = getWidgetsInSection(section: section)
        
        withAnimation {
            for index in indexSet {
                let widget = widgets[index]
                DataController.shared.container.viewContext.delete(widget)
                
                // Update positions starting with widget after deleted index
                for index in index+1..<widgets.count {
                    widgets[index].position = widgets[index].position - 1
                }
                DataController.saveMOC()
            }
        }
    }
    
    func moveWidgetWithIndexSet(section: Section, indexSet: IndexSet, destination: Int) {
        // Create temporary array with moved index
        var widgets = getWidgetsInSection(section: section)
        widgets.move(fromOffsets: indexSet, toOffset: destination)
        
        // Update positions
        for (index, widget) in widgets.enumerated() {
            widget.position = Int16(index)
        }
        DataController.saveMOC()
    }
    
    func resizeImage(imageData: Data, newSize: CGSize) throws -> Data {
        guard let image = UIImage(data: imageData) else { throw ImageError.dataToUIImage }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else { throw ImageError.getImageFromContext}
        UIGraphicsEndImageContext()
        return resizedImage.jpegData(compressionQuality: 1)!
    }
    
    func exportToPDF(form: Form) -> Data {
        
        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let form = FormView(form: form).environment(\.managedObjectContext, DataController.shared.container.viewContext)

        let pdfVC = UIHostingController(rootView: form)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        //Render the view behind all other views
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)

        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))

        let data = pdfRenderer.pdfData(actions: { context in
            context.beginPage()
            pdfVC.view.layer.render(in: context.cgContext)
        })
        return data
        
//        pdfVC.removeFromParent()
//        pdfVC.view.removeFromSuperview()
    }
}
