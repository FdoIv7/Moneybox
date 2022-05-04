//
//  APIService.swift
//  Moneybox
//
//  Created by Fernando Perez on 01/05/22.
//

import Foundation
import Alamofire

final class APIService {
    static let shared = APIService()
    public var accountRequestSuccessful = false
    private let baseURL = "https://api-test02.moneyboxapp.com/"
    private var token: String = ""
    private var headers: HTTPHeaders = [
        "AppId": "8cb2237d0679ca88db6464",
        "Content-Type": "application/json",
        "appVersion": "8.10.0",
        "apiVersion": "3.0.0"
    ]

    public func login(_ email: String, _ password: String) {
        let usersLoginPath = "users/login"
        let fullPath = baseURL + usersLoginPath

        let parameters: [String: Any] = [
            "Email": email,
            "Password": password,
        ]

        AF.request(fullPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] result in
            guard let data = result.data, let httpResponse = result.response else { return }
            self?.accountRequestSuccessful = (200..<300).contains(httpResponse.statusCode)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                guard let session = jsonResponse?.value(forKey: "Session") as? NSDictionary else { return }
                guard let bearerToken = session.value(forKey: "BearerToken") as? String else { return }
                self?.token = bearerToken
                self?.headers["Authorization"] = "Bearer \(self?.token ?? "")"
            } catch {
                print("Error parsing response = \(error)")
            }
        }
    }

    public func getAccounts(completion: @escaping ([Account]) -> ()) {
        let investorsPath = "/investorproducts"
        let fullPath = baseURL + investorsPath
        AF.request(fullPath, method: .get, parameters: nil, encoding: JSONEncoding.default,
                  headers: headers).responseJSON { result in
            guard let results = result.value as? NSDictionary, let accounts = results.value(forKey: "Accounts")
            else { return }
            do {
                let jsonAccounts = try JSONSerialization.data(withJSONObject: accounts, options: .prettyPrinted)
                let accountsResult = try JSONDecoder().decode([Account].self, from: jsonAccounts)
            } catch {
                print(error)
            }
        }
    }

    public func getTotalPlanValue(completion: @escaping (_ total: Double) -> ()) {
        let investorsPath = "/investorproducts"
        let fullPath = baseURL + investorsPath
        AF.request(fullPath, method: .get, parameters: nil, encoding: JSONEncoding.default,
                  headers: headers).responseJSON { response in
            guard let results = response.value as? NSDictionary, let totalValue = results.value(forKey: "TotalPlanValue")
            else { return }
            guard let totalPlanValue = totalValue as? Double else { return }
            completion(totalPlanValue)
        }
    }

    public func getInvestorsProducts(completion: @escaping (_ products: [ProductResponses]) -> ()) {
        let investorsPath = "/investorproducts"
        let fullPath = baseURL + investorsPath
        AF.request(fullPath, method: .get, parameters: nil, encoding: JSONEncoding.default,
                  headers: headers).responseJSON { response in
            guard let results = response.value as? NSDictionary, let products = results.value(forKey: "ProductResponses")
            else { return }
            do {
                let jsonProducts = try JSONSerialization.data(withJSONObject: products, options: .prettyPrinted)
                let productArray = try JSONDecoder().decode([ProductResponses].self, from: jsonProducts)
                completion(productArray)
            } catch {
                print(error)
            }
        }
    }
}
