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
    @ObservedObject var form: Form
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
                        generatedFileURL = URL.temporaryDirectory.appending(path: "\(form.title ?? "Form").\(exportType == .pdf ? "pdf" : "csv")")
                        if let generatedFileURL {
                            DispatchQueue.main.async {
                                if exportType == .pdf {
                                    let formData = formModel.exportToPdf(form: form)
                                    try? formData.write(to: generatedFileURL)
                                    Analytics.logEvent(Strings.analyticsExportPDFEvent, parameters: nil)
                                }
                                else {
                                    let csvData = formModel.exportToCsv(form: form)
                                    try? csvData.write(to: generatedFileURL)
                                    Analytics.logEvent(Strings.analyticsExportCSVEvent,parameters: nil)
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
        ExportView(form: dev.form, exportType: .constant(.pdf))
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
