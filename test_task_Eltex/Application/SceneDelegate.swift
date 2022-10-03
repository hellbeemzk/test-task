//
//  SceneDelegate.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = Assembly.shared.build()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }

}

