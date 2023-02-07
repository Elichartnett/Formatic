//
//  Home.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var formModel: FormModel
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var time = 0.0
    @State var finishedLaunching = false
    #warning("abstract")
    @AppStorage("tutorialComplete") var tutorialComplete: Bool = false

    var body: some View {
        
        NavigationStack(path: $formModel.navigationPath) {
            FormListView()
                .toolbar {
                    FormaticToolbar()
                }
        }
        .navigationViewStyle(.stack)
        .overlay {
            ZStack {
                if !finishedLaunching {
                    LottieView(name: Constants.logoAnimationFileName)
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
                if finishedLaunching && !tutorialComplete {
                    TutorialView(showIntro: true) {
                        tutorialComplete = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FormModel())
            .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
    }
}
