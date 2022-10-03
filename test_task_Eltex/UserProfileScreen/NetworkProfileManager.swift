//
//  NetworkProfileManager.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import Foundation

protocol NetworkProfileProtocol {
    func getUserProfileInfo(token: String, completion: @escaping (Result<UserInfoModel, Error>) -> Void)
}

final class NetworkProfileManager: NSObject, NetworkProfileProtocol {
    
    //MARK: - Constants
    private let endPoint = "https://smart.eltex-co.ru:8273/api/v1/user"
    
    // MARK: - Public Methods
    func getUserProfileInfo(token: String, completion: @escaping (Result<UserInfoModel, Error>) -> Void) {
        guard let url = URL(string: self.endPoint) else { return }
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                if let data = data {
                    let dataModel = try JSONDecoder().decode(UserInfoModel.self, from: data)
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

extension NetworkProfileManager: URLSessionDelegate {
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
