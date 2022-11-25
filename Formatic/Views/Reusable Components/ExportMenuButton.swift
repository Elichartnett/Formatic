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
            
            // Export to form
            if forms.count == 1 {
                let form = forms[0]
                ShareLink(item: form, preview: SharePreview(form.title ?? "Form"))
            }
            
            // Export to PDF
            Button {
                exportType = .pdf
            } label: {
                HStack {
                    Image(systemName: Strings.docTextImageIconName)
                    Text(Strings.generatePDFLabel)
                }
            }
            
            // Export to CSV
            Button {
                exportType = .commaSeparatedText
            } label: {
                HStack {
                    Image (systemName: Strings.csvTableIconName)
                    Text(Strings.generateCSVLabel)
                }
            }
        } label: {
            let icon = Image(systemName: Strings.exportFormIconName)
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
    }
}

struct ExportMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        ExportMenuButton(exportType: .constant(.form), forms: [dev.form])
    }
}
