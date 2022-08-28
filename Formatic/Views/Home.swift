//
//  FormApp.swift
//  Formatic

//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

struct Home: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var time = 0.0
    @State var launchIsFinished = false
    
    var body: some View {
        
        // List of all created forms
        FormListView()
            .overlay {
                LottieView(name: "logoAnimation")
                    .background(Color.white)
                    .onReceive(timer) { _ in
                        time += 0.1
                        if time >= 1.5 {
                            withAnimation {
                                launchIsFinished = true
                            }
                            timer.upstream.connect().cancel()
                        }
                    }
                    .opacity(launchIsFinished == true ? 0 : 1)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
}
