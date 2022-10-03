//
//  UserInfoModel.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import Foundation

struct UserInfoModel: Decodable {
    
    let roleId: String?
    let username: String?
    let email: String?
    let permissions: [String]
    
}
