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
    
    /**
    Set a delay to stagger the showing of each subsequent radial button
    
    Note: this is a bit buggy when using UIView animations
    
    Default = 0
    
    :param: Double The delay in seconds
    */
    public func setDelay(delay: Double) -> Self {
        self.delay = delay
        return self
    }
    
    /**
    Set the buttons to display when present is called. Each button should be an instance of ALRadialMenuButton
    
    :param: Array An array of ALRadialMenuButton instances
    */
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
    
    /**
    Set to false to disable dismissing the menu on background tap
    
    Default = true
    
    :param: Bool enabled or disable the gesture
    */
    public func setDismissOnOverlayTap(dismissOnOverlayTap: Bool) -> Self {
        self.dismissOnOverlayTap = dismissOnOverlayTap
        return self
    }
    
    /**
    Set the radius to control how far from the point of origin the buttons should show when the menu is open
    
    Default = 100
    
    :param: Double the radius in pts
    */
    public func setRadius(radius: Double) -> Self {
        self.radius = radius
        return self
    }
    
    /**
    Set the starting angle from which to lay out the buttons
    
    Default = 270
    
    :param: Double the angle in degrees
    */
    public func setStartAngle(degrees: Double) -> Self {
        self.startAngle = Angle(degrees: degrees)
        return self
    }
    
    /**
    Set the total circumference that the buttons should be laid out in
    
    Default = 360
    
    :param: Double the circumference in degrees
    */
    public func setCircumference(degrees: Double) -> Self {
        self.circumference = Angle(degrees: degrees)
        return self
    }
    
    /**
    Set the origin point from which the buttons should animate
    
    Default = self.center
    
    :param: CGPoint the origin point
    */
    public func setAnimationOrigin(animationOrigin: CGPoint) -> Self {
        self.animationOrigin = animationOrigin
        return self
    }
    
    /**
    Present the buttons in the specified view's window
    
    :param: UIView view
    */
    public func presentInView(view: UIView) -> Self {
        return presentInWindow(view.window!)
    }
    
    /**
    Present the buttons in the specified window
    
    :param: UIWindow window
    */
    public func presentInWindow(win: UIWindow) -> Self {
        
        if buttons.count == 0 {
            println("ALRadialMenu has no buttons to present")
            return self
        }
        
        if animationOrigin == nil {
            animationOrigin = center
        }
        
        win.addSubview(overlayView)
        
        for i in 0..<buttons.count {
            
            let button = buttons[i]
            
            win.addSubview(button)
            presentAnimation(button, index: i)
        }
        
        return self
    }
    
    /**
    Dismiss the buttons with an animation
    */
    public func dismiss() -> Self {
        
        if buttons.count == 0 {
            println("ALRadialMenu has no buttons to dismiss")
            return self
        }
        
        dismiss(-1)
        
        return self
    }
    
    // MARK: private vars
    
    private var delay: Double = 0
    private var buttons = [ALRadialMenuButton]() {
        didSet {
            calculateSpacing()
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
    
    private var radius: Double = 100
    private var startAngle: Angle = Angle(degrees: 270)
    private var circumference: Angle = Angle(degrees: 360) {
        didSet {
            calculateSpacing()
        }
    }
    
    private var spacingDegrees: Angle!
    private var animationOrigin: CGPoint!
    
    private var dismissGesture: UITapGestureRecognizer!
    private var animationOptions = UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.BeginFromCurrentState

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
        view.alpha = 0
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
    
    private func pointOnCircumference(origin: CGPoint, radius: Double, angle: Angle) -> CGPoint {
        
        let radians = angle.radians()
        let x = origin.x + CGFloat(radius) * CGFloat(cos(radians))
        let y = origin.y + CGFloat(radius) * CGFloat(sin(radians))
        
        return CGPointMake(x, y)
    }
    
    private func calculateSpacing() {
        if buttons.count > 0 {
            
            var c = buttons.count
            
            if circumference.degrees < 360 {
                c--
            }
            
            spacingDegrees = Angle(degrees: circumference.degrees / Double(c))
        }
    }
}