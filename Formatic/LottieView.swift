//
//  LottieView.swift
//  Formatic
//
//  Created by Eli Hartnett on 8/27/22.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    var animationSpeed = 1.0
    var reversed = false
    
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        
        if reversed {
            animationView.play(fromProgress: 1.0, toProgress: 0.0)
        }
        else {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(name: Constants.logoAnimationFileName)
    }
}
