//
//  Spinner.swift
//  ImageGridApp
//
//  Created by NFC User on 10/05/24.
//

import UIKit

class Spinner: UIActivityIndicatorView {

    static let shared = Spinner(style: .large)
    
    override init(style: UIActivityIndicatorView.Style) {
            super.init(style: style)
        self.color = .gray // Set the color of the spinner
            self.hidesWhenStopped = true // Hide the spinner when it's not animating
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func startAnimating(in view: UIView, withOpacity opacity: CGFloat = 0.7) {
           self.center = view.center
           view.addSubview(self)
           self.startAnimating()
        
        view.alpha = opacity
       }
    
    func stopAnimatingAndRemove(from view: UIView) {
           self.stopAnimating()
        // Reset opacity for the view
            view.alpha = 1.0
           self.removeFromSuperview()
           
           
       }

}
