//
//  LoginResponseModel.swift
//  Moneybox
//
//  Created by Fernando  Perez on 01/05/22.
//

import Foundation

struct LoginResponseModel: Codable {
    let session: String

    enum CodingKeys: String, CodingKey {
        case session = "Session"
    }
}
