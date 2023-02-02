//
//  APIRequest.swift
//  NPayFramework
//
//  Created by Vu Pham on 15/08/2022.
//

import Foundation
struct Example: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}


struct APIRequest {
    
    var resourceURL: URL
    let urlString = "https://jsonplaceholder.typicode.com/todos/1"
    let userInfoPath = "/sdk/v2/user/info"
    let refreshToken = "/sdk/v1/login/refresh_token"
    let getMerchatAction = "/sdk/v1/func/list"
    
    init() {
        resourceURL = URL(string: Flavor.shared.getBaseUrl())!
    }
    
    func getUserInfo(header: [String: Any], completion: @escaping(Result<UserInfoResponse, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: Flavor.shared.getBaseApi()+userInfoPath)!)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        //        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+(UserDefaults.getSavedValue(.accessToken) as? String ?? "accessToken"), forHTTPHeaderField: "Authorization")
        header.forEach { (key: String, value: Any) in
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
            else {
                print("error: not a valid http response")
                completion(.failure(error!))
                return
            }
            switch (httpResponse.statusCode) {
            case 200:
                //                completion(.failure(NSError(domain: "", code: 403)))
                //                return
                guard let userInfoResponse = try? JSONDecoder().decode(UserInfoResponse.self, from: receivedData) else {
                    return
                }
//                print("USER INFO\(userInfoResponse)")
                completion(.success(userInfoResponse))
                break
            case 403:
                completion(.failure(NSError(domain: "", code: 403)))
                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
            }
        })
        
        task.resume()
    }
    
    
    func refreshAccessToken(completion: @escaping(Result<RefreshTokenResponse, Error>) -> Void) {
        let params = ["refresh_token": "\(UserDefaults.getSavedValue(.refreshToken) as? String ?? "")"] as [String: Any]
        var request = URLRequest(url: URL(string: Flavor.shared.getBaseApi()+refreshToken)!)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue("Bearer "+(UserDefaults.getSavedValue(.refreshToken) as? String ?? "accessToken"), forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
            else {
                print("error: not a valid http response")
                completion(.failure(error!))
                return
            }
            switch (httpResponse.statusCode) {
            case 200:
                do {
//                    let json = try JSONSerialization.jsonObject(with: receivedData) as! Dictionary<String, AnyObject>
//                    print(json)
                    guard let refreshTokenResponse = try? JSONDecoder().decode(RefreshTokenResponse.self, from: receivedData)
                    else {
                        return
                    }
                    completion(.success(refreshTokenResponse))
                } catch let parseError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
                break
            case 403:
                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
            }
        })
        
        task.resume()
    }
    
//    sdk/v1/func/list
    func getMerchantAction(header: [String: Any], completion: @escaping(Result<MerchantActionResponse, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Flavor.shared.getBaseApi()+getMerchatAction)!)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        //        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+(UserDefaults.getSavedValue(.accessToken) as? String ?? "accessToken"), forHTTPHeaderField: "Authorization")
        header.forEach { (key: String, value: Any) in
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
            else {
                print("error: not a valid http response")
                completion(.failure(error!))
                return
            }
            switch (httpResponse.statusCode) {
            case 200:
                guard let merchantActionResponse = try? JSONDecoder().decode(MerchantActionResponse.self, from: receivedData) else {
                    return
                }
                completion(.success(merchantActionResponse))
                break
            case 403:
                completion(.failure(NSError(domain: "", code: 403)))
                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
            }
        })
        
        task.resume()
    }
}
