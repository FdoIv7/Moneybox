//
//  Dictionary+Ext.swift
//  Moneybox
//
//  Created by Fernando Ives on 02/05/22.
//

import Foundation

extension Dictionary {
    func percentEncoded() -> Data? {
        return map {key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }.joined(separator: "&").data(using: .utf8)
    }
}
