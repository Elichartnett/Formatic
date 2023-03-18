//
//  NumberFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct NumberFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @FetchRequest var coreDataNumberFieldWidget: FetchedResults<NumberFieldWidget>
    
    @ObservedObject var numberFieldWidget: NumberFieldWidget
    @Binding var locked: Bool
    @State var title: String
    @State var number: String
    @State var isValid: Bool = true
    var range: ClosedRange<Double>? = nil
    
    init(numberFieldWidget: NumberFieldWidget, locked: Binding<Bool>, range: ClosedRange<Double>? = nil) {
        self.numberFieldWidget = numberFieldWidget
        self._coreDataNumberFieldWidget = FetchRequest<NumberFieldWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "id == %@", numberFieldWidget.id as CVarArg))
        self._locked = locked
        self._title = State(initialValue: numberFieldWidget.title ?? "")
        self._number = State(initialValue: numberFieldWidget.number ?? "")
        self.range = range
        self.isValid = isValid
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    numberFieldWidget.title = title
                }
            
            InputBox(placeholder: Strings.numberLabel, text: $number, inputType: .number, isValid: $isValid)
                .onChange(of: number) { _ in
                    isValid = number.isValidNumber(range: range)
                    if !isValid {
                        number.enforceNumberValidation()
                    }
                    numberFieldWidget.number = number
                }
                .onChange(of: coreDataNumberFieldWidget.first?.number ?? "") { newValue in
                    number = newValue
                }
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

struct NumberFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldWidgetView(numberFieldWidget: dev.numberFieldWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}
