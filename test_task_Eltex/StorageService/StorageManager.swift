//
//  StorageManager.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import Foundation

protocol StorageManagerProtocol {
    var isLoginIn: Bool { get set }
    func saveTokenInStorage(token: String)
    func getTokenFromStorage() -> String
}

final class StorageManager: StorageManagerProtocol {
    
    //MARK: - Properties
    private var storage = UserDefaults.standard
    
    private enum UserDefaultsKeys: String {
        case token = "access_token"
        case isLogin = "isLoginIn"
    }
    
    var isLoginIn: Bool {
        get {
            return storage.bool(forKey: UserDefaultsKeys.isLogin.rawValue)
        }
        set {
            storage.set(newValue, forKey: UserDefaultsKeys.isLogin.rawValue)
        }
    }
    
    func saveTokenInStorage(token: String) {
        storage.set(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func getTokenFromStorage() -> String {
        var token = ""
        if let tokenFromStorage = storage.string(forKey: UserDefaultsKeys.token.rawValue) {
            token = tokenFromStorage
        }
        return token
    }
    
}
