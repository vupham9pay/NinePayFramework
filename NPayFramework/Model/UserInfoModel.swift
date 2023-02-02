//
//  UserInfoModel.swift
//  NPayFramework
//
//  Created by Vu Pham on 16/08/2022.
//
//   let userInfoResponse = try? newJSONDecoder().decode(UserInfoResponse.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userInfoResponse = try? newJSONDecoder().decode(UserInfoResponse.self, from: jsonData)

import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let serverTime, status: Int?
    let message: String?
    let errorCode: Int?
    let data: UserInfor?

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case status, message
        case errorCode = "error_code"
        case data
    }
}

// MARK: - UserInfor
struct UserInfor: Codable {
    let id: Int?
    let email, phone, name, referenceID: String?
    let type, status, isBlock, isActive: Int?
    let isVerify, updatedAt, createdAt: Int?
    let profile: Profile?
    let groups, segments: [Group]?
    let isFunGroup: Bool?
    let draftInfo: DraftInfo?
    let isMerchant: Int?
    let hashID, referCode: String?
    let isUsedReferCode, isShowReferEvent: Bool?
    let isNapas, kycType: String?
    let balance: Int?
    let banks: [Bank]?
    let notiNonReaded: Int?
    let qrCode: String?
    let verifyUser: Int?
    let userTransferLink: String?
    let accounts: Accounts?
    let statusBankLink: Int?
    let loyalty: Loyalty?
    let rank: Rank?
    let checkValidateVerify: CheckValidateVerify?
    let configLimit: ConfigLimit?
    let autoPayment: Int?

    enum CodingKeys: String, CodingKey {
        case id, email, phone, name
        case referenceID = "referenceID"
        case type, status
        case isBlock = "is_block"
        case isActive = "is_actice"
        case isVerify = "is_verify"
        case updatedAt = "update_at"
        case createdAt = "create_at"
        case profile, groups, segments
        case isFunGroup = "is_fun_group"
        case draftInfo = "draft_info"
        case isMerchant = "is_merchant"
        case hashID = "hash_id"
        case referCode = "refer_code"
        case isUsedReferCode = "is_used_refer_code"
        case isShowReferEvent = "is_show_refer_event"
        case isNapas = "is_napas"
        case kycType = "kyc_type"
        case balance, banks
        case notiNonReaded = "noti_non_readed"
        case qrCode = "qr_code"
        case verifyUser = "verify_user"
        case userTransferLink = "user_transfer_link"
        case accounts
        case statusBankLink = "status_bank_link"
        case loyalty, rank
        case checkValidateVerify = "check_validate_verify"
        case configLimit = "config_limit"
        case autoPayment = "auto_payment"
    }
}

// MARK: - Accounts
struct Accounts: Codable {
    let main, promotion: Main?
}

// MARK: - Main
struct Main: Codable {
    let accountNo: String?
    let balance, status, balanceType, type: Int?

    enum CodingKeys: String, CodingKey {
        case accountNo
        case balance, status
        case balanceType
        case type
    }
}

// MARK: - Bank
struct Bank: Codable {
    let bCode, bName, bFullname: String?
    let bType: Int?
    let bAccount, bAccountName, bToken: String?
    let bLogo: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case bCode
        case bName
        case bFullname
        case bType
        case bAccount
        case bAccountName
        case bToken
        case bLogo
        case updatedAt
    }
}

// MARK: - CheckValidateVerify
struct CheckValidateVerify: Codable {
    let deposit, bankTransfer, transfer: CheckBankClass?
    let withdraw: Withdraw?
    let payment, link, directLink, checkBank: CheckBankClass?

    enum CodingKeys: String, CodingKey {
        case deposit
        case bankTransfer
        case transfer, withdraw, payment, link
        case directLink
        case checkBank
    }
}

// MARK: - CheckBankClass
struct CheckBankClass: Codable {
}

// MARK: - Withdraw
struct Withdraw: Codable {
    let errorCode: Int?
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorCode
        case errorMessage
    }
}

// MARK: - ConfigLimit
struct ConfigLimit: Codable {
    let deposit: Deposit?
    let depositTransfer: DepositTransfer?
    let transfer: Transfer?
    let bankTransfer: ConfigLimitBankTransfer?
    let withdraw: DepositTransfer?
    let payment: Deposit?
    let qr: DepositTransfer?
    let linkNapas: LinkNapas?

    enum CodingKeys: String, CodingKey {
        case deposit
        case depositTransfer
        case transfer
        case bankTransfer
        case withdraw, payment, qr
        case linkNapas
    }
}

// MARK: - ConfigLimitBankTransfer
struct ConfigLimitBankTransfer: Codable {
    let maxPerUser, min, max: Int?

    enum CodingKeys: String, CodingKey {
        case maxPerUser
        case min, max
    }
}

// MARK: - Deposit
struct Deposit: Codable {
    let min, minBidv, max, minNapas: Int?

    enum CodingKeys: String, CodingKey {
        case min
        case minBidv
        case max
        case minNapas
    }
}

// MARK: - DepositTransfer
struct DepositTransfer: Codable {
    let min, max: Int?
}

// MARK: - LinkNapas
struct LinkNapas: Codable {
    let min: Int?
}

// MARK: - Transfer
struct Transfer: Codable {
    let min, max, minBank, maxBank: Int?

    enum CodingKeys: String, CodingKey {
        case min, max
        case minBank
        case maxBank
    }
}

// MARK: - DraftInfo
struct DraftInfo: Codable {
    let requestID, name, birthday: String?
    let email: JSONNull?
    let gender: Int?
    let country, province, district, ward: String?
    let idCardNo: String?
    let passportNumber: JSONNull?
    let cardIssueAt, cardIssuePlace, cardExpiredAt: String?
    let cardType: Int?
    let image, idCardFrontImage, idCardBackImage: String?
    let stepOld, stepNew: Int?
    let validLimitRequest: Bool?

    enum CodingKeys: String, CodingKey {
        case requestID
        case name, birthday, email, gender, country, province, district, ward
        case idCardNo
        case passportNumber
        case cardIssueAt
        case cardIssuePlace
        case cardExpiredAt
        case cardType
        case image
        case idCardFrontImage
        case idCardBackImage
        case stepOld
        case stepNew
        case validLimitRequest
    }
}

// MARK: - Group
struct Group: Codable {
    let id: Int?
    let code, name: String?
    let isTemp: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case isTemp
        case title
    }
}

// MARK: - Loyalty
struct Loyalty: Codable {
    let point: Int?
}

// MARK: - Profile
struct Profile: Codable {
    let address: String?
    let emailVerified, phoneVerified: Int?
    let nickName: String?
    let avatar: String?
    let image: String?
    let birthday: String?
    let gender: Int?
    let country, province, district, ward: String?
    let idCardNo: String?
    let passportNumber: JSONNull?
    let cardType: Int?
    let cardIssueAt: String?
    let cardExpiredAt: JSONNull?
    let cardIssuePlace: String?
    let idCardFrontImage, idCardBackImage: String?
    let updatedAt, createdAt: Int?

    enum CodingKeys: String, CodingKey {
        case address
        case emailVerified
        case phoneVerified
        case nickName
        case avatar, image, birthday, gender, country, province, district, ward
        case idCardNo
        case passportNumber
        case cardType
        case cardIssueAt
        case cardExpiredAt
        case cardIssuePlace
        case idCardFrontImage
        case idCardBackImage
        case updatedAt
        case createdAt
    }
}

// MARK: - Rank
struct Rank: Codable {
    let id: Int?
    let name: String?
    let appBackgroundURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case appBackgroundURL
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
