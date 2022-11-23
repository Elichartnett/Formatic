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
                if editMode?.wrappedValue == .active {
                    Image(systemName: Strings.editIconName)
                        .customIcon()
                }
            }
                .disabled(editMode?.wrappedValue == .inactive)
                .buttonStyle(.plain)
            
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
                .onChange(of: colorScheme, perform: { _ in
                    do {
                        let canvasView = PKCanvasView()
                        let imageView = UIImageView()
                        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
                        
                        if canvasWidget.pkDrawing != nil {
                            canvasView.drawing = try PKDrawing(data: canvasWidget.pkDrawing ?? Data())
                        }
                        
                        canvasView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: width))
                        canvasView.isOpaque = false
                        canvasView.backgroundColor = .clear
                        canvasView.minimumZoomScale = 1
                        canvasView.maximumZoomScale = 5
                        
                        imageView.frame = CGRect(origin: .zero, size: canvasView.frame.size)
                        imageView.contentMode = .scaleAspectFit
                        imageView.image = UIImage(data: canvasWidget.image ?? Data())
                        imageView.backgroundColor = .secondaryBackground
                        
                        canvasView.addSubview(imageView)
                        canvasView.sendSubviewToBack(imageView)
                        
                        // Add picker
                        canvasView.becomeFirstResponder()
                        
                        FormModel.updateCanvasWidgetViewPreview(canvasWidget: canvasWidget, canvasView: canvasView)
                    }
                    catch {
                        alertTitle = Strings.updateCanvasWidgetViewPreviewErrorMessage
                        showAlert = true
                    }
                })
                
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
            VStack(alignment: .leading, spacing: FormModel.spacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: FormModel.spacingConstant) {
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
