//
//  RefreshTokenModel.swift
//  NPayFramework
//
//  Created by Vu Pham on 17/08/2022.
//
//   let refreshTokenResponse = try? newJSONDecoder().decode(RefreshTokenResponse.self, from: jsonData)

import Foundation

// MARK: - RefreshTokenResponse
struct RefreshTokenResponse: Codable {
    let serverTime, status: Int?
    let message: String?
    let errorCode: Int?
    let data: RefreshTokenModel?

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case status, message
        case errorCode = "error_code"
        case data
    }
}

// MARK: - RefreshTokenModel
struct RefreshTokenModel: Codable {
    let tokenType: String?
    let clientExpiresIn, expiresIn: Int?
    let accessToken, refreshToken, publicKey: String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case clientExpiresIn = "client_expires_in"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case publicKey = "public_key"
    }
}
