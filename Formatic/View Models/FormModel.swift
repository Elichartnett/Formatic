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
    
    init() {
        
    }
    
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
            createWidgetsInForm(form: form)
            return form
        }
        catch {
            print(error)
            // TODO: handle error
            throw FormError.decodeJsonDataToFormError
        }
    }
    
    func createWidgetsInForm(form: Form) {
        for section in form.sections ?? [] {
            for widget in section.widgets ?? [] {
                let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!)!
                
                switch widgetType {
                case .textFieldWidget:
                    let textFieldWidget = TextFieldWidget(title: widget.title, position: Int(widget.position), text: nil)
                    section.addToWidgets(textFieldWidget)
                    
                case .numberFieldWidget:
                    let numberFieldWidget = NumberFieldWidget(title: widget.title, position: Int(widget.position), number: nil)
                    section.addToWidgets(numberFieldWidget)
                case .textEditorWidget:
                    let textEditorWidget = TextEditorWidget(title: widget.title, position: Int(widget.position), text: nil)
                    section.addToWidgets(textEditorWidget)
                case .dropdownSectionWidget:
                    let dropdownSectionWidget = DropdownSectionWidget(title: widget.title, position: Int(widget.position))
                    section.addToWidgets(dropdownSectionWidget)
                case .dropdownWidget:
                    break
                case .checkboxSectionWidget:
                    let checkboxSectionWidget = CheckboxSectionWidget(title: widget.title, position: Int(widget.position))
                    section.addToWidgets(checkboxSectionWidget)
                case .checkboxWidget:
                    break
                case .mapWidget:
                    let mapWidget = MapWidget(title: widget.title, position: Int(widget.position))
                    section.addToWidgets(mapWidget)
                case .photoLibraryWidget:
                    let photoLibraryWidget = PhotoLibraryWidget(title: widget.title, position: Int(widget.position))
                    section.addToWidgets(photoLibraryWidget)
                case .photoWidget:
                    break
                case .canvasWidget:
                    let canvasWidget = CanvasWidget(title: widget.title, position: Int(widget.position))
                    section.addToWidgets(canvasWidget)
                }
                DataController.shared.container.viewContext.delete(widget)
            }
        }
        DataController.saveMOC()
    }
    
    func importForm(url: URL) throws {
        do {
            let data = try urlToData(url: url)
            do {
                let newForm = try decodeJsonDataToForm(data: data)
                do {
                    let forms = try getForms()
                    newForm.position = Int16(forms.count - 1)
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
        do {
            let data = try Data(contentsOf: url)
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
        
        let pdfView = convertToScrollView(content: FormView(form: form, forPDF: true).environment(\.managedObjectContext, DataController.shared.container.viewContext))
        pdfView.tag = 1009
        let size = pdfView.contentSize
        pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
        
//        getRootController().view.insertSubview(pdfView, at: 0)
//        let rootVC = UIApplication.shared.windows.first?.rootViewController
//        rootVC?.view.insertSubview(pdfView, at: 0)
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let data = pdfRenderer.pdfData(actions: { context in
            context.beginPage()
            pdfView.layer.render(in: context.cgContext)
            // Root view fixes map rendering, but messes up if page is long
//             rootVC?.view.layer.render(in: context.cgContext)
        })
        
        getRootController().view.subviews.forEach { view in
            if view.tag == 1009 {
                view.removeFromSuperview()
            }
        }
        
        return data
    }
    
    func convertToScrollView<Content: View>(content: Content) -> UIScrollView {
        let scrollView = UIScrollView()
        
        let hostingController = UIHostingController(rootView: content).view!
        hostingController.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostingController.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            hostingController.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ]
        
        scrollView.addSubview(hostingController)
        scrollView.addConstraints(constraints)
        scrollView.layoutIfNeeded()
        
        return scrollView
    }
    
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
}
