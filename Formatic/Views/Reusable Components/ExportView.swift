//
//  ExportView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/20/22.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers
import FirebaseAnalytics

struct ExportView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.colorScheme) var colorScheme
    
    let forms: [Form]
    @Binding var exportType: UTType?
    @State var generatedFileURL: URL?
    @State var readyToExport = false
    
    var body: some View {
        Group {
            if let generatedFileURL, readyToExport {
                VStack {
                    ShareLink(item: generatedFileURL)
                        .padding()
                    WebViewRepresentable(generatedFileURL: generatedFileURL)
                        .ignoresSafeArea(edges: [.bottom])
                        .onChange(of: colorScheme) { _ in
                            self.generatedFileURL = nil
                        }
                }
            }
            else {
                ProgressView()
                    .onAppear {
                        generateFile()
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
    }
    func generateFile() {
        let file = forms.map( { form in
            let title = form.title?.trimmingCharacters(in: .whitespaces)
            if let title, !title.isEmpty {
                return title
            }
            else {
                return Strings.formUntitledLabel
            }
        }).formatted(.list(type: .and))
        
        generatedFileURL = URL.temporaryDirectory.appending(path: "\(file).\(exportType == .pdf ? "pdf" : "csv")")
        if let generatedFileURL {
            DispatchQueue.main.async {
                if exportType == .pdf {
                    
                    let formData = Form.exportToPDF(forms: forms)
                    try? formData.write(to: generatedFileURL)
                    Analytics.logEvent(Constants.analyticsExportPDFEvent, parameters: nil)
                }
                else {
                    let csvData = Form.exportToCSV(forms: forms)
                    try? csvData.write(to: generatedFileURL)
                    Analytics.logEvent(Constants.analyticsExportCSVEvent,parameters: nil)
                }
                readyToExport = true
            }
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(forms: [dev.form], exportType: .constant(.pdf))
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    
    let generatedFileURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.maximumZoomScale = 2
        webView.scrollView.minimumZoomScale = 1
        webView.load(URLRequest(url: generatedFileURL))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: generatedFileURL))
    }
}
