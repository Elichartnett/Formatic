//
//  ExportMenuButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportMenuButton: View {
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var storeKitManager: StoreKitManager
    
    @Binding var exportType: UTType?
    var forms: [Form]
    
    @State var showPaywallView = false
    
    var body: some View {
        
        Menu {
            
            if forms.count == 1 {
                
                let formaticFileLabel = HStack {
                    Image(systemName: Constants.fileIconName)
                        .customIcon()
                    Text(Strings.formaticFileLabel)
                }
                
                if storeKitManager.purchasedProducts.contains(where: { product in
                    product.id == FormaticProductID.importExportFormatic.rawValue
                }) {
                    let form = forms[0]
                    ShareLink(item: form, preview: SharePreview(form.title ?? Strings.formLabel)) {
                        formaticFileLabel
                    }
                }
                else {
                    Button {
                        showPaywallView = true
                    } label: {
                        formaticFileLabel
                    }
                }
            }
            
            Button {
                if storeKitManager.purchasedProducts.contains(where: { product in
                    product.id == FormaticProductID.exportPdf.rawValue
                }) {
                    exportType = .pdf
                }
                else {
                    showPaywallView = true
                }
            } label: {
                HStack {
                    Image(systemName: Constants.docTextImageIconName)
                        .customIcon()
                    Text(Strings.generatePDFLabel)
                }
            }
            
            Button {
                if storeKitManager.purchasedProducts.contains(where: { product in
                    product.id == FormaticProductID.exportCsv.rawValue
                }) {
                    exportType = .commaSeparatedText
                }
                else {
                    showPaywallView = true
                }
            } label: {
                HStack {
                    Image (systemName: Constants.csvTableIconName)
                    Text(Strings.generateCSVLabel)
                }
            }
        } label: {
            let icon = Image(systemName: Constants.exportFormIconName)
                .customIcon()
            if formModel.isPhone {
                icon
            }
            else {
                HStack {
                    icon
                    Text(Strings.exportLabel)
                }
            }
        }
        .sheet(isPresented: $showPaywallView) {
            PaywallView(storeKitManager: formModel.storeKitManager)
        }
    }
}

struct ExportMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        ExportMenuButton(storeKitManager: dev.formModel.storeKitManager, exportType: .constant(.form), forms: [dev.form])
            .environmentObject(FormModel())
    }
}
