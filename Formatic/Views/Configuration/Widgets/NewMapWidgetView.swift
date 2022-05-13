//
//  NewMapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI


// In new widget sheet to configure new MapWidget
struct NewMapWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    
    var body: some View {
        
        Button {
            let mapWidget = MapWidget(title: title, position: section.widgetsArray.count)
            
            withAnimation {
                section.addToWidgets(mapWidget)
                DataController.saveMOC()
            }
            newWidgetType = nil
        } label: {
            SubmitButton(isValid: .constant(true))
        }
    }
}

struct NewMapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewMapWidgetView(newWidgetType: .constant(.mapWidget), title: .constant(dev.mapWidget.title!), section: dev.section)
    }
}
