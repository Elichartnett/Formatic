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
                }
            }
            else {
                ProgressView()
                    .onAppear {
                        generatedFileURL = URL.temporaryDirectory.appending(path: "Form\(forms.count == 1 ? "" : "s").\(exportType == .pdf ? "pdf" : "csv")")
                        if let generatedFileURL {
                            DispatchQueue.main.async {
                                if exportType == .pdf {
                                    let formData = Form.exportToPdf(forms: forms)
                                    try? formData.write(to: generatedFileURL)
                                    Analytics.logEvent(Constants.analyticsExportPDFEvent, parameters: nil)
                                }
                                else {
                                    let csvData = Form.exportToCsv(forms: forms)
                                    try? csvData.write(to: generatedFileURL)
                                    Analytics.logEvent(Constants.analyticsExportCSVEvent,parameters: nil)
                                }
                                readyToExport = true
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(forms: [dev.form], exportType: .constant(.pdf))
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    
    let generatedFileURL: URL
    
    func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: generatedFileURL))
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
