//
//  DateFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import SwiftUI

struct DateFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var dateFieldWidget: DateFieldWidget
    @Binding var locked: Bool
    @FocusState var isFocused: Bool
    @State var title: String
    @State var date: Date
    
    init(dateFieldWidget: DateFieldWidget, locked: Binding<Bool>) {
        self.dateFieldWidget = dateFieldWidget
        self._locked = locked
        self._title = State(initialValue: dateFieldWidget.title ?? "")
        self._date = State(initialValue: dateFieldWidget.date ?? Date())
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onAppear {
                    title = dateFieldWidget.title ?? ""
                }
                .onChange(of: title) { _ in
                    dateFieldWidget.title = title
                }
            
            DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) {}
                .labelsHidden()
            .datePickerStyle(.compact)
            .onChange(of: date, perform: { _ in
                dateFieldWidget.date = date
            })
            .frame(maxWidth: .infinity)
            .WidgetFrameStyle(height: .regular)
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            
            HStack(spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
    }
}

struct DateFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DateFieldWidgetView(dateFieldWidget: dev.dateFieldWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}