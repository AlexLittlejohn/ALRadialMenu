//
//  ViewController.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showMenu(sender:)))
        view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.white
        
        label.textColor = UIColor.lightGray
        label.text = "Tap anywhere"
        label.sizeToFit()
        label.center = view.center
        
        view.addSubview(label)
    }

    func generateButtons() -> [ALRadialMenuButton] {
        
        var buttons = [ALRadialMenuButton]()
        
        for i in 0..<8 {
            let button = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            button.setImage(UIImage(named: "icon\(i+1)"), for: UIControlState.normal)
            buttons.append(button)
        }
        
        return buttons
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        ALRadialMenu()
            .setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.location(in: view))
            .presentInView(view: view)
    }
}

