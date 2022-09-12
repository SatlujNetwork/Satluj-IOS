//
//  APIResponse.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation

struct ServerResponse<T: Codable>: Codable {
    let status: String!
    let loginToken: String?
    let data: T?
    let message: String?
    let hasMore: Bool?
}


extension ServerResponse {
    enum CodingKeys: String, CodingKey {
        case data
        case status = "error_code"
        case loginToken = "login_token"
        case hasMore = "has_more"
        case message
    }
}

struct ResponseKey: Codable {
}
struct ResponseData: Codable {
    
}
class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
