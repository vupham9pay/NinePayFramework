// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let merchantActionResponse = try? newJSONDecoder().decode(MerchantActionResponse.self, from: jsonData)

import Foundation

// MARK: - MerchantActionResponse
class MerchantActionResponse: Codable {
    let serverTime, status: Int?
    let message: String?
    let errorCode: Int?
    let data: [Action]?

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case status, message
        case errorCode = "error_code"
        case data
    }

    init(serverTime: Int?, status: Int?, message: String?, errorCode: Int?, data: [Action]?) {
        self.serverTime = serverTime
        self.status = status
        self.message = message
        self.errorCode = errorCode
        self.data = data
    }
}

// MARK: - Action
class Action: Codable {
    let action: String?
    let type: Int?
    let url: String?

    init(action: String?, type: Int?, url: String?) {
        self.action = action
        self.type = type
        self.url = url
    }
}
