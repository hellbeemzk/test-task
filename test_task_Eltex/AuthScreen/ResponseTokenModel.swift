//
//  ResponseTokenModel.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import Foundation

struct ResponseTokenModel: Decodable {
    
    let access_token: String
    let refresh_token: String
    let scope: String
    let token_type: String
    let expires_in: Int
    
}
