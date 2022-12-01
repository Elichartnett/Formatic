//
//  CanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import PencilKit

struct CanvasWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.editMode) var editMode
    
    @ObservedObject var canvasWidget: CanvasWidget
    @Binding var locked: Bool
    @State var title: String
    @State var reconfigureWidget = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    init(canvasWidget: CanvasWidget, locked: Binding<Bool>) {
        self.canvasWidget = canvasWidget
        self._locked = locked
        self._title = State(initialValue: canvasWidget.title ?? "")
    }
    
    var body: some View {
        
        let baseView = Group {
            
            let reconfigureButton = Button {
                reconfigureWidget = true
            } label: {
                Image(systemName: Constants.editIconName)
                    .customIcon()
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
            }
                .disabled(editMode?.wrappedValue == .inactive)
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            canvasWidget.title = title
                        }
                        .disabled(locked)
                    
                    if formModel.isPhone {
                        reconfigureButton
                    }
                }
                
                NavigationLink {
                    CanvasWidgetDetailView(canvasWidget: canvasWidget)
                } label: {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            
                            if let backgroundImage = UIImage(data: canvasWidget.image ?? Data()) {
                                Image(uiImage: backgroundImage)
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                            Image(uiImage: UIImage(data: canvasWidget.widgetViewPreview ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: WidgetViewHeight.large.rawValue, height: WidgetViewHeight.large.rawValue)
                        .border(.secondary)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .WidgetFrameStyle(height: .large)
                }
                
                if !formModel.isPhone {
                    reconfigureButton
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                ConfigureCanvasWidgetView(canvasWidget: canvasWidget, title: $title, section: canvasWidget.section!)
                    .padding()
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
            })
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

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}
