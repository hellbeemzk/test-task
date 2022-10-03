//
//  ExtensionViewController.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit

extension UIViewController {
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
