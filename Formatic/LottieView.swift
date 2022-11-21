//
//  LottieView.swift
//  Formatic
//
//  Created by Eli Hartnett on 8/27/22.
//

import SwiftUI
import Lottie

// Launch screen animation
struct LottieView: UIViewRepresentable {
    
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    
    var animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(name: Strings.logoAnimationFileName)
    }
}
