//
//  ConfigureDateFieldWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import SwiftUI
import FirebaseAnalytics

struct ConfigureDateFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
    @FocusState var isFocused: Bool
    @State var section: Section
    @State var date = Date()
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) { }
                .datePickerStyle(.graphical)
            }
            
            Button {
                let dateFieldWidget = DateFieldWidget(title: title, position: section.numberOfWidgets(), date: date)
                withAnimation {
                    section.addToWidgets(dateFieldWidget)
                }
                Analytics.logEvent(Constants.analyticsCreateDateFieldWidgetEvent, parameters: nil)
                dismiss()
            } label: {
                SubmitButton()
            }
            .padding(.bottom)
        }
    }
}

struct ConfigureDateFieldWidget_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureDateFieldWidgetView(title: .constant(dev.dateFieldWidget.title!), section: dev.section)
    }
}
