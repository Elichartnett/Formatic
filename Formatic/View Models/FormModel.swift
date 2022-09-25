//
//  FormModel.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation
import SwiftUI
import CoreData
import MapKit

class FormModel: ObservableObject {
    
    func numberIsValid(number: String, range: ClosedRange<Double>? = nil) -> Bool {
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
    
    func titleIsValid(title: String) throws -> Bool {
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
                    newForm.position = Int16(forms.count - 1)
                    if forms.contains(where: { form in
                        form.title == newForm.title && form.id != newForm.id
                    })
                    {
                        try resolveDuplicateFormName(newForm: newForm)
                    }
                    DataControllerModel.saveMOC()
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
        DataControllerModel.saveMOC()
    }
    
    func getForms() throws -> [Form] {
        let formsRequest: NSFetchRequest<Form> = Form.fetchRequest()
        do {
            var forms = try DataControllerModel.shared.container.viewContext.fetch(formsRequest)
            forms = forms.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
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
    
    func resolveDuplicateFormName(newForm: Form) throws {
        do {
            let forms = try getForms()
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
        catch {
            throw FormError.fetchError
        }
    }
    
    func deleteForm(form: Form) throws {
        do {
            var forms = try getForms()
            
            let index = forms.firstIndex { savedForm in
                savedForm.id == form.id
            }
            let formIndex = forms.distance(from: forms.startIndex, to: index!)
            
            DataControllerModel.shared.container.viewContext.delete(form)
            forms.remove(at: formIndex)
            
            // Update positions starting with form after deleted index
            for index in formIndex..<forms.count {
                forms[index].position = forms[index].position - 1
            }
        }
        catch {
            throw FormError.fetchError
        }
    }
    
    func copyForm(form: Form) throws {

        let formCopy = form.copy() as! Form
        do {
            try resolveDuplicateFormName(newForm: formCopy)
            formCopy.position = Int16(try getForms().count - 1)
            DataControllerModel.saveMOC()
        }
        catch {
            throw FormError.copyError
        }
    }
    
    func deleteWidgetWithIndexSet(section: Section, indexSet: IndexSet) {
        let widgets = getWidgetsInSection(section: section)
        
        withAnimation {
            for index in indexSet {
                let widget = widgets[index]
                DataControllerModel.shared.container.viewContext.delete(widget)
                
                // Update positions starting with widget after deleted index
                for index in index+1..<widgets.count {
                    widgets[index].position = widgets[index].position - 1
                }
                DataControllerModel.saveMOC()
            }
        }
    }
    
    func updateWidgetPosition(section: Section, indexSet: IndexSet, destination: Int) {
        // Create temporary array with moved index
        var widgets = getWidgetsInSection(section: section)
        widgets.move(fromOffsets: indexSet, toOffset: destination)
        
        // Update positions
        for (index, widget) in widgets.enumerated() {
            DispatchQueue.main.async {
                widget.position = Int16(index)
            }
        }
        DataControllerModel.saveMOC()
    }
    
    func exportToPdf(form: Form) -> Data {
        
        let pdfView = convertToScrollView(content: FormView(form: form, forPDF: true).environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext))
        pdfView.tag = 1009
        let size = pdfView.contentSize
        pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
        
        getRootController().view.insertSubview(pdfView, at: 0)
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let data = pdfRenderer.pdfData(actions: { context in
            context.beginPage()
            pdfView.layer.render(in: context.cgContext)
        })
        
        getRootController().view.subviews.forEach { view in
            if view.tag == 1009 {
                view.removeFromSuperview()
            }
        }
        return data
    }
    
    func exportToCsv(form: Form) -> Data {
        let data = form.toCsv().data(using: .utf8) ?? "No Form Data".data(using: .utf8)!
        return data
    }
    
    static func formatAsCsv(_ string: String) -> String {
        var csvString = ""
        
        if string.contains("\""){
            // In case user *specifcally* used normal quotes in their text
            csvString = string.replacingOccurrences(of: "\"", with: "“")
        }
        else {
            csvString = string
        }
        
        // Add single quotes in case of commas present in text
        if csvString.contains(",") || string.contains("\n") {
            csvString = "\"" + csvString + "\""
        }
        
        return csvString
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
    
    func updateMapWidgetSnapshot(size: CGSize, mapWidget: MapWidget) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta))
        let options = MKMapSnapshotter.Options()
        options.region = coordinateRegion
        options.size = size
        
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start(with: DispatchQueue.global(qos: .userInitiated)) { snapshot, error in
            guard error == nil else {
                return
            }
            
            if let snapshotImage = snapshot?.image, let mapMarker = UIImage(systemName: "mappin.circle.fill")?.withTintColor(.red) {
                UIGraphicsBeginImageContextWithOptions(snapshotImage.size, true, snapshotImage.scale)
                snapshotImage.draw(at: CGPoint.zero)
                
                for annotation in mapWidget.annotations ?? [] {
                    if let annotation = annotation as? Annotation {
                        mapMarker.draw(at: (snapshot?.point(for: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)))!)
                    }
                }
                
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                mapWidget.widgetViewPreview = mapImage?.jpegData(compressionQuality: 0.5) ?? Data()
                UIGraphicsEndImageContext()
            }
        }
    }
}
