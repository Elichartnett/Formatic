//
//  SliderWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import SwiftUI

struct SliderWidgetView: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var sliderWidget: SliderWidget
    @Binding var locked: Bool
    @State var title: String
    @State var number: Double
    @State var lowerBound: Double
    @State var upperBound: Double
    @State var step: Double
    @State var reconfigureWidget = false
    
    init(sliderWidget: SliderWidget, locked: Binding<Bool>) {
        self.sliderWidget = sliderWidget
        self._locked = locked
        self._title = State(initialValue: sliderWidget.title ?? Constants.emptyString)
        self._number = State(initialValue: Double(sliderWidget.number!) ?? 0)
        self._lowerBound = State(initialValue: Double(sliderWidget.lowerBound!) ?? 0)
        self._upperBound = State(initialValue: Double(sliderWidget.upperBound!) ?? 0)
        self._step = State(initialValue: Double(sliderWidget.step!) ?? 0)
    }
    
    var body: some View {
        
        let baseView = Group {
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            sliderWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
                    }
                }
                
                HStack {
                    VStack {
                        Text("\(Strings.valueLabel): \(sliderWidget.number ?? Constants.emptyString)")
                        
                        HStack {
                            Text(lowerBound.formatted())
                            
                            Slider(value: $number, in: lowerBound...upperBound, step: step)
                                .onChange(of: number) { _ in
                                    sliderWidget.number = number.formatted()
                                }
                            
                            Text(upperBound.formatted())
                        }
                        .onChange(of: sliderWidget.lowerBound, perform: { _ in
                            if let bound = sliderWidget.lowerBound {
                                lowerBound = Double(bound)!
                            }
                        })
                        .onChange(of: sliderWidget.upperBound, perform: { _ in
                            if let bound = sliderWidget.lowerBound {
                                upperBound = Double(bound)!
                            }
                        })
                        .onChange(of: sliderWidget.step, perform: { _ in
                            if let sliderStep = sliderWidget.step {
                                step = Double(sliderStep)!
                            }
                        })
                        .onChange(of: sliderWidget.number, perform: { _ in
                            if let sliderNumber = sliderWidget.number {
                                number = Double(sliderNumber)!
                            }
                        })
                        .padding(.horizontal)
                    }
                    .widgetFrameStyle(height: .adaptive)
                    
                    if !formModel.isPhone && editMode?.wrappedValue == .active {
                        ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
                    }
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                ConfigureSliderWidgetView(sliderWidget: sliderWidget, title: $title, section: sliderWidget.section!)
                    .padding()
            }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            HStack {
                baseView
            }
        }
    }
}

struct SliderWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SliderWidgetView(sliderWidget: dev.sliderWidget, locked: .constant(false))
    }
}
