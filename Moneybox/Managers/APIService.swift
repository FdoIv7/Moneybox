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

    public func login(_ email: String, _ password: String, completion: @escaping (_ accountHolderName: String?, _ success: Bool) -> ()) {
        let usersLoginPath = "users/login"
        let fullPath = baseURL + usersLoginPath

        let parameters: [String: Any] = [
            "Email": email,
            "Password": password,
        ]
        AF.request(fullPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] result in
            print("Login result = \(result)")
            guard let data = result.data, let httpResponse = result.response else { return }
            self?.accountRequestSuccessful = (200..<300).contains(httpResponse.statusCode)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                // Session Response
                guard let session = jsonResponse?.value(forKey: "Session") as? NSDictionary else {
                    completion("", false)
                    return
                }
                guard let bearerToken = session.value(forKey: "BearerToken") as? String else { return }

                // User response
                guard let user = jsonResponse?.value(forKey: "User") as? NSDictionary,
                     let name = user.value(forKey: "FirstName") as? String else { return }
                self?.token = bearerToken
                self?.headers["Authorization"] = "Bearer \(self?.token ?? "")"
                completion(name, true)
            } catch {
                print("Error parsing response = \(error)")
                completion("MoneyboxTeam", false)
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
                completion(accountsResult)
            } catch {
                print(error)
            }
        }
    }

    public func getInvestorsProducts(completion: @escaping (_ products: [ProductResponses], _ total: Double, _ success: Bool) -> ()) {
        let investorsPath = "/investorproducts"
        let fullPath = baseURL + investorsPath
        AF.request(fullPath, method: .get, parameters: nil, encoding: JSONEncoding.default,
                  headers: headers).responseJSON { [weak self] results in
            print("Result products = \(results)")
            guard let httpResponse = results.response, let self = self else { return }
            self.accountRequestSuccessful = (200..<300).contains(httpResponse.statusCode)
            guard let results = results.value as? NSDictionary,
                 let products = results.value(forKey: "ProductResponses"),
                 let total = results.value(forKey: "TotalPlanValue") as? Double else { return }
            do {
                let jsonProducts = try JSONSerialization.data(withJSONObject: products, options: .prettyPrinted)
                let productArray = try JSONDecoder().decode([ProductResponses].self, from: jsonProducts)
                completion(productArray, total, self.accountRequestSuccessful)
            } catch {
                print(error)
            }
        }
    }

    public func makePayment(amount: Double, productId: Int, completion: @escaping (_ newMoneyboxAmount: Int, _ success: Bool) -> ()) {
        let addAmountPath = "/oneoffpayments"
        let fullPath = baseURL + addAmountPath
        let params: [String: Any] = [
            "Amount": amount,
            "InvestorProductId": productId
        ]
        AF.request(fullPath, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON
        { (response) in
            print("Response = \(response)")
            if let result = response.value as? NSDictionary, let moneyboxValue = result.value(forKey: "Moneybox") as? Int {
                completion(moneyboxValue, true)
            } else {
                completion(-1, false)
            }
        }
    }
}
