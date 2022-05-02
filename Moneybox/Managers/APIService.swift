//
//  APIService.swift
//  Moneybox
//
//  Created by Fernando  Perez on 01/05/22.
//

import Foundation
enum HttpVerb: String {
    
    case get = "GET"
    case post = "POST"
    
}

final class APIService {
    let baseURL = "https://api-test02.moneyboxapp.com/"
    
    var path: String = ""
    var method: HttpVerb = .get
    var parameters: [String: Any]?
    var requiresAuthentication: Bool = false
    
    func urlRequest() {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let headers = [
            "AppId": "8cb2237d0679ca88db6464",
            "Content-Type": "application/json",
            "appVersion": "8.10.0",
            "apiVersion": "3.0.0"
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            print("Reponse = \(response)")
            print("error = \(error)")
            guard let data = data else { return }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                print("JSON = \(jsonObject)")
            } catch {
                print("Error getting JSON")
            }
        }
        print(dataTask.currentRequest?.url)
        dataTask.resume()
    }
}
