//
//  ConfigureSliderWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import SwiftUI
import FirebaseAnalytics

struct ConfigureSliderWidgetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var sliderWidget: SliderWidget?
    @Binding var title: String
    @State var section: Section
    @State var number: Double = 0
    let lowerBoundDefault: Double = 0
    @State var lowerBound: Double = 0
    @State var lowerBoundInput = ""
    @State var validLowerBoundInput = true
    let upperBoundDefault: Double = 10
    @State var upperBound: Double = 10
    @State var upperBoundInput = ""
    @State var validUpperBoundInput = true
    let stepDefault: Double = 1
    @State var step: Double = 1
    @State var stepInput = ""
    @State var validStepInput = true
    let maxInput: Double = 1000000
    
    var body: some View {
        
        VStack {
            
            Text("\(Strings.valueLabel): \(number.formatted())")
            
            HStack {
                Text(lowerBound.formatted())
                
                Slider(value: $number, in: lowerBound...upperBound, step: step)
                
                Text(upperBound.formatted())
            }
            
            HStack {
                Text(Strings.lowerBoundLabel)
                InputBox(placeholder: lowerBoundDefault.formatted(), text: $lowerBoundInput, inputType: .number, isValid: $validLowerBoundInput, validRange: 0...upperBound-1)
                    .onChange(of: lowerBoundInput) { _ in
                        validateLowerBound()
                        validateUpperBound()
                        validateStep()
                    }
            }
            
            HStack {
                Text(Strings.upperBoundLabel)
                InputBox(placeholder: upperBoundDefault.formatted(), text: $upperBoundInput, inputType: .number, isValid: $validUpperBoundInput, validRange: max(lowerBound, step)+1...maxInput)
                    .onChange(of: upperBoundInput) { _ in
                        validateUpperBound()
                        validateLowerBound()
                        validateStep()
                    }
            }
            
            HStack {
                Text(Strings.stepLabel)
                InputBox(placeholder: stepDefault.formatted(), text: $stepInput, inputType: .number, isValid: $validStepInput, validRange: 1/maxInput...upperBound-1)
                    .onChange(of: stepInput) { _ in
                        validateStep()
                        validateLowerBound()
                        validateUpperBound()
                    }
            }
            
            Button {
                if sliderWidget != nil {
                    updateExistingSliderWidget()
                } else {
                    createNewSliderWidget()
                }
                dismiss()
            } label: {
                SubmitButton()
            }
            .disabled(!(validLowerBoundInput && validUpperBoundInput && validStepInput))
        }
        .padding(.top)
        .onAppear {
            if let sliderWidget = sliderWidget {
                lowerBoundInput = sliderWidget.lowerBound ?? ""
                upperBoundInput = sliderWidget.upperBound ?? ""
                stepInput = sliderWidget.step ?? ""
                number = Double(sliderWidget.number!) ?? 0
            }
        }
    }
    
    func updateExistingSliderWidget() {
        sliderWidget?.lowerBound = lowerBoundInput
        sliderWidget?.upperBound = upperBoundInput
        sliderWidget?.step = stepInput
        sliderWidget?.number = number.formatted()
    }
    
    func createNewSliderWidget() {
        if lowerBoundInput.isEmpty { lowerBoundInput = lowerBoundDefault.formatted() }
        if upperBoundInput.isEmpty { upperBoundInput = upperBoundDefault.formatted() }
        if stepInput.isEmpty { stepInput = stepDefault.formatted() }
        
        let sliderWidget = SliderWidget(title: title, position: section.numberOfWidgets(), lowerBound: lowerBoundInput, upperBound: upperBoundInput, step: stepInput, number: number.formatted())
        withAnimation {
            section.addToWidgets(sliderWidget)
        }
        
        Analytics.logEvent(Constants.analyticsCreateSliderWidgetEvent, parameters: nil)
    }
    
    func validateLowerBound() {
        if let lowerBoundDouble = Double(lowerBoundInput) {
            if lowerBoundDouble < upperBound {
                lowerBound = lowerBoundDouble
                validLowerBoundInput = true
            }
            else {
                validLowerBoundInput = false
            }
        }
        else if lowerBoundInput.isEmpty {
            lowerBound = lowerBoundDefault
        }
    }
    
    func validateUpperBound() {
        if let upperBoundDouble = Double(upperBoundInput) {
            if upperBoundDouble > lowerBound && upperBoundDouble > step {
                upperBound = upperBoundDouble
                validUpperBoundInput = true
            }
            else {
                validUpperBoundInput = false
            }
            if number > upperBound {
                number = upperBound
            }
        }
        else if upperBoundInput.isEmpty {
            upperBound = upperBoundDefault
        }
    }
    
    func validateStep() {
        if let stepDouble = Double(stepInput) {
            if stepDouble > 0 && stepDouble < upperBound {
                step = stepDouble
                validStepInput = true
            }
            else {
                validStepInput = false
            }
        }
        else if stepInput.isEmpty {
            step = stepDefault
        }
    }
}

struct ConfigureSliderWidget_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureSliderWidgetView(title: .constant(dev.sliderWidget.title!), section: dev.section)
    }
}
