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
    
    @Binding var exportType: UTType?
    var forms: [Form]
    
    var body: some View {
        
        Menu {
            
            if forms.count == 1 {
                let form = forms[0]
                ShareLink(item: form, preview: SharePreview(form.title ?? "Form"))
            }
            
            Button {
                exportType = .pdf
            } label: {
                HStack {
                    Image(systemName: Constants.docTextImageIconName)
                    Text(Strings.generatePDFLabel)
                }
            }
            
            Button {
                exportType = .commaSeparatedText
            } label: {
                HStack {
                    Image (systemName: Constants.csvTableIconName)
                    Text(Strings.generateCSVLabel)
                }
            }
        } label: {
            Labels.export
        }
    }
}

struct ExportMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        ExportMenuButton(exportType: .constant(.form), forms: [dev.form])
            .environmentObject(FormModel())
    }
}
