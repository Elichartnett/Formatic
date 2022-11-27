//
//  Extension+Form.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import CryptoKit
import SwiftUI
import FirebaseAnalytics

extension Form: Codable, Identifiable, Transferable, Csv, Copyable {
    
    convenience init(id: UUID = UUID(), locked: Bool = false, password: String? = nil, recentlyDeleted: Bool = false, title: String) {
        self.init(context: DataControllerModel.shared.container.viewContext)
        self.id = id
        self.dateCreated = Date()
        self.locked = locked
        self.password = password
        self.recentlyDeleted = recentlyDeleted
        self.title = title
    }
    
    enum CodingKeys: CodingKey {
        case dateCreated
        case locked
        case password
        case title
        case sections
    }
    
    public func encode(to encoder: Encoder) throws {
        var formContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try formContainer.encode(dateCreated, forKey: .dateCreated)
        try formContainer.encode(locked, forKey: .locked)
        try formContainer.encode(title, forKey: .title)
        try formContainer.encode(sections, forKey: .sections)
        
        if let password {
            let hash = SHA256.hash(data: dateCreated.timeIntervalSince1970.description.data(using: .utf8)!)
            let key = SymmetricKey(data: hash)
            let passwordData = password.data(using: .utf8)!
            let sealedBoxData = try! ChaChaPoly.seal(passwordData, using: key).combined
            try formContainer.encode(sealedBoxData, forKey: .password)
        }
    }
    
    static public var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .form)
    }
    
    func delete() {
        DataControllerModel.shared.container.viewContext.delete(self)
        Analytics.logEvent(Constants.analyticsDeleteFormEvent, parameters: nil)
    }
    
    func toCsv() -> String {
        var csvString = ""
        let sections = (sections ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
        for section in sections {
            csvString += section.toCsv()
            csvString += "\n\n"
        }
        // Remove trailing newline characters
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = Form(title: self.title!)
        Analytics.logEvent(Constants.analyticsCopyFormEvent, parameters: nil)

        copy.locked = locked
        copy.password = password
        copy.dateCreated = copy.dateCreated.addingTimeInterval(1)
        
        let sectionsArray = sections?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) ?? []
        for section in sectionsArray {
            let sectionCopy = section.createCopy() as! Section
            copy.addToSections(sectionCopy)
        }
        return copy
    }
    
    static func importForm(url: URL) throws {
        do {
            let data = try url.toData()
            do {
                try data.decodeToForm()
            }
            catch {
                throw FormError.decodeJsonDataToFormError
            }
        }
        catch {
            throw FormError.urlToDataError
        }
    }
    
    static func exportToPdf(forms: [Form]) -> Data {
        // Get size for renderer
        let pdfView = convertToScrollView(content: FormView(form: forms[0], forPDF: true).environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext).environmentObject(FormModel()))
        let size = pdfView.contentSize
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let data = pdfRenderer.pdfData { context in

            for form in forms {
                context.beginPage()

                let pdfView = convertToScrollView(content: FormView(form: form, forPDF: true).environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext).environmentObject(FormModel()))
                let size = pdfView.contentSize
                pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
                pdfView.tag = 1009
                
                getRootController().view.insertSubview(pdfView, at: 0)
                
                pdfView.layer.render(in: context.cgContext)
                
                getRootController().view.subviews.forEach { view in
                    if view.tag == 1009 {
                        view.removeFromSuperview()
                    }
                }
            }
        }
        return data
    }
    
    static func convertToScrollView<Content: View>(content: Content) -> UIScrollView {
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
    
    static func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
    
    static func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
    
    static func exportToCsv(forms: [Form]) -> Data {
        var csvString = Strings.baseCSVColumns + Strings.mapCSVColumns
        for form in forms {
            csvString.append(form.toCsv())
            if form != forms.last {
                csvString.append("\n")
            }
        }
        return csvString.data(using: .utf8) ?? Strings.noFormDataErrorMessage.data(using: .utf8)!
    }
}
