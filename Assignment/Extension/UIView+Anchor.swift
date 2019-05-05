//
//  UIView+Anchor.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit

extension UIView {
    // adding the anchor to the view
    func addAnchorConstraint (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom            
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topConstraint = top {
            self.topAnchor.constraint(equalTo: topConstraint, constant: paddingTop+topInset).isActive = true
        }
        
        if let leftConstraint = left {
            self.leftAnchor.constraint(equalTo: leftConstraint, constant: paddingLeft).isActive = true
        }
        
        if let rightConstraint = right {
            rightAnchor.constraint(equalTo: rightConstraint, constant: -paddingRight).isActive = true
        }
        
        if let bottomConstraint = bottom {
            bottomAnchor.constraint(equalTo: bottomConstraint, constant: -paddingBottom-bottomInset).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    public func setAutoresizingMaskIntoConstraintsForAllSubviews() {
        for view in self.subviews {
            view.setAutoresizingMaskIntoConstraintsForAllSubviews()
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // full view constraints for view
    func fullViewConstraints(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": subView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": subView]))
    }
}
