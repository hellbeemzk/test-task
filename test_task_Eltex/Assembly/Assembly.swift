//
//  Assembly.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit
import Foundation

final class Assembly {
    
    private init() {}
    
    static let shared: Assembly = .init()
    
    // MARK: - Properties
    private var storageManager : StorageManagerProtocol = StorageManager()
    
    // MARK: - Methods
    func createAuthorizationVC() -> UIViewController {
        let networkAuth = NetworkAuthManager()
        let vc = AuthorizationVC(networkAuth: networkAuth, storage: storageManager)
        return vc
    }
    
    func createUserProfileVC() -> UIViewController {
        let networkProfile = NetworkProfileManager()
        let vc = UserProfileVC(networkProfile: networkProfile, storage: storageManager)
        return vc
    }
    
    func build() -> UIViewController {
        let rootVC: UIViewController
        rootVC = storageManager.isLoginIn ? createUserProfileVC() : createAuthorizationVC()
        
        let navigation = UINavigationController(rootViewController: rootVC)
        return navigation as UIViewController
    }
    
}

