//
//  NewCanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new CanvasWidget
struct NewCanvasWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    
    var body: some View {
        Button {
            withAnimation {
                section.addToWidgets(CanvasWidget(title: title, position: section.widgetsArray.count))
                DataController.saveMOC()
            }
            newWidgetType = nil
        } label: {
            SubmitButton(isValid: .constant(true))
                .padding(.bottom)
        }
    }
}

struct NewCanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewCanvasWidgetView(newWidgetType: .constant(.canvasWidget), title: .constant(dev.canvasWidget.title!), section: dev.section)
    }
}
