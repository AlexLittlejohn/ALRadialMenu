//
//  ViewController.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: "showMenu:")
        view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.whiteColor()
    }

    func generateButtons() -> [ALRadialMenuButton] {
        
        var buttons = [ALRadialMenuButton]()
        
        for i in 0..<8 {
            let button = ALRadialMenuButton(frame: CGRectMake(0, 0, 44, 44))
            button.setImage(UIImage(named: "icon\(i+1)"), forState: UIControlState.Normal)
            buttons.append(button)
        }
        
        return buttons
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        ALRadialMenu()
            .setButtons(generateButtons())
            .setDelay(0.05)
            .setAnimationOrigin(sender.locationInView(view))
            .presentInView(view)
    }
}

