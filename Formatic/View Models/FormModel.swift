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
import PencilKit
import FirebaseAnalytics

class FormModel: ObservableObject {
    
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static var spacingConstant: CGFloat = 8
    
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
    
    static func encodeFormToJsonData(form: Form) throws -> Data {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(form)
            return data
        }
        catch {
            throw FormError.encodeFormToJsonDataError
        }
    }
    
    static func decodeJsonDataToForm(data: Data) throws -> Form {
        let decoder = JSONDecoder()
        do {
            let form = try decoder.decode(Form.self, from: data)
            Analytics.logEvent(Strings.analyticsImportFormEvent, parameters: nil)
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
                let newForm = try FormModel.decodeJsonDataToForm(data: data)
                do {
                    let forms = try getForms()
                    if forms.contains(where: { form in
                        form.title == newForm.title && form.id != newForm.id
                    })
                    {
                        try resolveDuplicateFormName(newForm: newForm)
                    }
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
    }
    
    func getForms() throws -> [Form] {
        let formsRequest: NSFetchRequest<Form> = Form.fetchRequest()
        do {
            var forms = try DataControllerModel.shared.container.viewContext.fetch(formsRequest)
            forms = forms.sorted { lhs, rhs in
                lhs.dateCreated < rhs.dateCreated
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
            _ = url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            url.stopAccessingSecurityScopedResource()
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
    
    func deleteForm(form: Form) {
        withAnimation {
            DataControllerModel.shared.container.viewContext.delete(form)
            Analytics.logEvent(Strings.analyticsDeleteFormEvent, parameters: nil)
        }
    }
    
    func deleteSection(section: Section, form: Form) {
        DataControllerModel.shared.container.viewContext.delete(section)
        if let sections = form.sections?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) {
            for index in Int(section.position)..<sections.count {
                sections[index].position -= 1
            }
        }
    }
    
    func copyForm(form: Form) throws {
        
        do {
            try withAnimation {
                let formCopy = form.createCopy() as! Form
                Analytics.logEvent(Strings.analyticsCopyFormEvent, parameters: nil)
                do {
                    try resolveDuplicateFormName(newForm: formCopy)
                }
                catch {
                    throw FormError.copyError
                }
            }
        }
        catch {
            throw FormError.fetchError
        }
    }
    
    func deleteWidget(widget: Widget) {
        let widgets = getWidgetsInSection(section: widget.section!)
        
        withAnimation {
            DataControllerModel.shared.container.viewContext.delete(widget)
            for index in Int(widget.position)..<widgets.count {
                widgets[index].position = widgets[index].position - 1
            }
        }
    }
    
    func copyWidget(section: Section, widget: Widget) {
        let widgets = getWidgetsInSection(section: section)
        
        for index in Int(widget.position + 1)..<widgets.count {
            widgets[index].position = widgets[index].position + 1
        }
        
        let widgetType = WidgetType(rawValue: widget.type!)
        
        switch widgetType {
        case .textFieldWidget:
            if let widget = widget as? TextFieldWidget {
                let copy = widget.createCopy() as! TextFieldWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        case .numberFieldWidget:
            if let widget = widget as? NumberFieldWidget {
                let copy = widget.createCopy() as! NumberFieldWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        case .dropdownSectionWidget:
            if let widget = widget as? DropdownSectionWidget {
                let copy = widget.createCopy() as! DropdownSectionWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        case .dropdownWidget:
            break
        case .checkboxSectionWidget:
            if let widget = widget as? CheckboxSectionWidget {
                let copy = widget.createCopy() as! CheckboxSectionWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        case .checkboxWidget:
            break
        case .mapWidget:
            if let widget = widget as? MapWidget {
                let copy = widget.createCopy() as! MapWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        case .canvasWidget:
            if let widget = widget as? CanvasWidget {
                let copy = widget.createCopy() as! CanvasWidget
                copy.position = widget.position + 1
                section.addToWidgets(copy)
            }
        default:
            break
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
    }
    
    func exportToPdf(form: Form) -> Data {
        
        let pdfView = convertToScrollView(content: FormView(form: form, forPDF: true).environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext).environmentObject(FormModel()))
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
        let data = form.toCsv().data(using: .utf8) ?? Strings.noFormDataErrorMessage.data(using: .utf8)!
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
            
            if let snapshotImage = snapshot?.image, let mapMarker = UIImage(systemName: Strings.mapPinIconName)?.withTintColor(.red) {
                UIGraphicsBeginImageContextWithOptions(options.size, true, snapshotImage.scale)
                snapshotImage.draw(at: CGPoint.zero)
                
                for annotation in mapWidget.annotations ?? [] {
                    if let annotation = annotation as? Annotation {
                        if var point = snapshot?.point(for: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                            point.x -= mapMarker.size.width / 2
                            point.y -= mapMarker.size.height / 2
                            mapMarker.draw(at: (point))
                        }
                    }
                }
                
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                mapWidget.widgetViewPreview = mapImage?.jpegData(compressionQuality: 0.5) ?? Data()
                UIGraphicsEndImageContext()
            }
        }
    }
    
    static func updateCanvasWidgetViewPreview(canvasWidget: CanvasWidget, canvasView: PKCanvasView) {
        canvasWidget.pkDrawing = canvasView.drawing.dataRepresentation()
        canvasWidget.widgetViewPreview = canvasView.drawing.image(from: CGRect(origin: .zero, size: canvasView.frame.size), scale: UIScreen.main.scale).pngData()
    }
    
    static func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static func getDeviceInformation() -> String {
        let device = UIDevice.current.name
        let deviceVersion = UIDevice.current.systemVersion
        return
                        """
                        -----------------------------
                        Device: \(device)
                        Device Version: \(deviceVersion)
                        Formatic Version: \(Bundle.main.fullVersion)
                        -----------------------------
                        \n
                        """
    }
}
