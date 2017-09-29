//
//  ALRadialMenuButton.swift
//  ALRadialMenu
//
//  Created by Alex Littlejohn on 2015/04/26.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

public typealias ALRadialMenuButtonAction = (UIButton) -> Void

public class ALRadialMenuButton: UIButton {
    public var action: ALRadialMenuButtonAction? {
        didSet {
            configureAction()
        }
    }
    
    private func configureAction() {
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    @objc internal func performAction() {
        if let a = action {
            a(self)
        }
    }
}
