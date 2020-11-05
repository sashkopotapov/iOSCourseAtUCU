//
//  UIViewController+UIAlertController.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, and message: String, _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alert in
            completion?()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
