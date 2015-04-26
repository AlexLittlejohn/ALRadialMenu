//
//  ALRadialMenu.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

private typealias ALAnimationsClosure = () -> Void

private struct Angle {
    var degrees: Double
    
    func radians() -> Double {
        return degrees * (M_PI/180)
    }
}

public class ALRadialMenu: UIButton {
    
    // MARK: private vars
    
    private var delay: Double = 0
    private var buttons = [ALRadialMenuButton]() {
        didSet {
            spacingDegrees = Angle(degrees: circumference.degrees / Double(buttons.count))
        }
    }
    
    private var dismissOnOverlayTap = true {
        didSet {
            if let gesture = dismissGesture {
                gesture.enabled = dismissOnOverlayTap
            }
        }
    }
    
    private var overlayView = UIView(frame: UIScreen.mainScreen().bounds)
    
    private var radius: CGFloat = 100
    private var startAngle: Angle = Angle(degrees: 270)
    private var circumference: Angle = Angle(degrees: 360) {
        didSet {
            if buttons.count > 0 {
                spacingDegrees = Angle(degrees: circumference.degrees / Double(buttons.count))
            }
        }
    }
    
    private var spacingDegrees: Angle!
    private var animationOrigin: CGPoint!
    
    private var dismissGesture: UITapGestureRecognizer!
    
    private var animationOptions = UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.BeginFromCurrentState
    
    // MARK: Public API
    
    public convenience init() {
        self.init(frame: CGRectZero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func setDelay(delay: Double) -> Self {
        self.delay = delay
        return self
    }
    
    public func setButtons(buttons: [ALRadialMenuButton]) -> Self {
        self.buttons = buttons
        
        for i in 0..<buttons.count {
            let button = buttons[i]
            let action = button.action
            
            button.center = center
            button.action = {
                self.dismiss(i)
                if let a = action {
                    a()
                }
            }
        }
        
        return self
    }
    
    public func setDismissOnOverlayTap(dismissOnOverlayTap: Bool) -> Self {
        self.dismissOnOverlayTap = dismissOnOverlayTap
        return self
    }
    
    public func setRadius(radius: CGFloat) -> Self {
        self.radius = radius
        return self
    }
    
    public func setStartAngle(degrees: Double) -> Self {
        self.startAngle = Angle(degrees: degrees)
        return self
    }
    
    public func setCircumference(degrees: Double) -> Self {
        self.circumference = Angle(degrees: degrees)
        return self
    }
    
    public func setAnimationOrigin(animationOrigin: CGPoint) -> Self {
        self.animationOrigin = animationOrigin
        return self
    }
    
    public func present() -> Self {
        
        if buttons.count == 0 {
            println("ALRadialMenu has no buttons to present")
            return self
        }
        
        if animationOrigin == nil {
            animationOrigin = center
        }
        
        if let w = window {
            
            w.addSubview(overlayView)
            
            for i in 0..<buttons.count {
                
                let button = buttons[i]
                
                w.addSubview(button)
                presentAnimation(button, index: i)
            }
            
        } else {
            println("ALRadialMenu needs a parent view")
        }
        
        return self
    }
    
    public func dismiss() -> Self {
        
        if buttons.count == 0 {
            println("ALRadialMenu has no buttons to dismiss")
            return self
        }
        
        dismiss(-1)
        
        return self
    }
    
    // MARK: Private API
    private func commonInit() {
        dismissGesture = UITapGestureRecognizer(target: self, action: "dismiss")
        dismissGesture.enabled = dismissOnOverlayTap
        
        overlayView.addGestureRecognizer(dismissGesture)
    }
    
    private func dismiss(selectedIndex: Int) {
        
        overlayView.removeFromSuperview()
        
        for i in 0..<buttons.count {
            if i == selectedIndex {
                selectedAnimation(buttons[i])
            } else {
                dismissAnimation(buttons[i], index: i)
            }
        }
    }
    
    private func presentAnimation(view: ALRadialMenuButton, index: Int) {
        let degrees = startAngle.degrees + spacingDegrees.degrees * Double(index)
        let newCenter = pointOnCircumference(animationOrigin, radius: radius, angle: Angle(degrees: degrees))
        let _delay = Double(index) * delay
        
        view.center = animationOrigin
        
        UIView.animateWithDuration(0.5, delay: _delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: animationOptions, animations: {
            view.alpha = 1
            view.center = newCenter
            }, completion: nil)
    }
    
    private func dismissAnimation(view: ALRadialMenuButton, index: Int) {
        let _delay = Double(index) * delay
        UIView.animateWithDuration(0.5, delay: _delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: animationOptions, animations: {
            view.alpha = 0
            view.center = self.animationOrigin
            }, completion: { finished in
                view.removeFromSuperview()
        })
    }
    
    private func selectedAnimation(view: ALRadialMenuButton) {

        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: animationOptions, animations: {
            view.alpha = 0
            view.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: { finished in
                view.transform = CGAffineTransformIdentity
                view.removeFromSuperview()
        })
    }
    
    private func pointOnCircumference(origin: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        
        let radians = angle.radians()
        let x = origin.x + radius * CGFloat(cos(radians))
        let y = origin.y + radius * CGFloat(sin(radians))
        
        return CGPointMake(x, y)
    }
}