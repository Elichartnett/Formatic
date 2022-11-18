//
//  Home.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

struct Home: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var time = 0.0
    @State var finishedLaunching = false
    
    var body: some View {
        
        // List of all created forms
        FormListView()
            .overlay {
                if !finishedLaunching {
                    LottieView(name: Strings.logoAnimationFileName)
                        .background(Color.white)
                        .onReceive(timer) { _ in
                            time += 0.1
                            if time >= 1.5 {
                                withAnimation {
                                    finishedLaunching = true
                                }
                                timer.upstream.connect().cancel()
                            }
                        }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
    }
}