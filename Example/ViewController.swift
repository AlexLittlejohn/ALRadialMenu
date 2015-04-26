//
//  ViewController.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var radialMenu: ALRadialMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        radialMenu = ALRadialMenu(frame: CGRectMake(0, 0, 66, 66))
        radialMenu.center = view.center

        radialMenu.setImage(UIImage(named: "centerIcon"), forState: UIControlState.Normal)
        
        radialMenu.setButtons(generateButtons())
        radialMenu.addTarget(self, action: "showMenu", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(radialMenu)
        
        
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
    
    func showMenu() {
        radialMenu.present()
    }
}

