//
//  ExtensionTextField.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit

extension UITextField {
    func indent(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}

