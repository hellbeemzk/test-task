//
//  NetworkAuthManager.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import Foundation
import UIKit

protocol AuthProtocol {
    func authorization(userName: String, password: String, completion: @escaping (Result<ResponseTokenModel, Error>) -> Void)
}

final class NetworkAuthManager: NSObject, AuthProtocol {
    
    //MARK: - Constants
    private let endPoint = "https://smart.eltex-co.ru:8273/api/v1/oauth/token"
    
    // MARK: - Public Methods
    func authorization(userName: String, password: String, completion: @escaping (Result<ResponseTokenModel, Error>) -> Void) {
        guard let url = URL(string: self.endPoint) else { return }
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        
        let credentials = stringToBase64(str: "ios-client:password")
        let requestParameters = "grant_type=password&username=\(userName)&password=\(password)"
        let httpBody = requestParameters.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            do {
                if let data = data {
                    let dataModel = try JSONDecoder().decode(ResponseTokenModel.self, from: data)
                    completion(.success(dataModel))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func stringToBase64(str: String) -> String {
        let utf8Data = str.data(using: .utf8)
        guard let base64EncodedString = utf8Data?.base64EncodedString() else { return "" }
        return base64EncodedString
    }
    
}

extension NetworkAuthManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
}
