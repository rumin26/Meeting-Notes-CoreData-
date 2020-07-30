//
//  UIViewController+Keyboard.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/21/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
