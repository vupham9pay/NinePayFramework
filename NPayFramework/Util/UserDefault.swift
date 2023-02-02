//
//  UserDefault.swift
//  NPayFramework
//
//  Created by Vu Pham on 16/08/2022.
//

import Foundation

enum UserDefaultKey: String {
    case accessToken
    case refreshToken
    case deviceID
}

extension UserDefaults {
    static func getSavedValue(_ key: UserDefaultKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    static func setValue<T>(value: T?, key: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    //    static func getUser(_ key: UserDefaultKey = .user) -> Profile? {
    //        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
    //        do {
    //            let decoder = JSONDecoder()
    //            return try decoder.decode(Profile.self, from: data)
    //        } catch {
    //            return nil
    //        }
    //    }
    //
    //    static func setUser(object: Profile, key: UserDefaultKey = .user) {
    //        do {
    //            let encoder = JSONEncoder()
    //            let data = try encoder.encode(object)
    //            UserDefaults.setValue(value: data, key: .user)
    //        } catch {
    //
    //        }
    //    }
    
    static func removeUser() {
        do {
            UserDefaults.standard.removeObject(forKey: UserDefaultKey.accessToken.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultKey.refreshToken.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultKey.deviceID.rawValue)
        } catch {
            
        }
    }
    
    
}
