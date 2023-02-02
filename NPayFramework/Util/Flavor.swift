//
//  Flavor.swift
//  NPayFramework
//
//  Created by Vu Pham on 20/12/2022.
//

import Foundation

public enum EnvironmentKey: String{
    case stg
    case sandbox
    case production
}

class Flavor {
    var baseUrl = ""
    var baseApi = ""
    var basePortal = ""
    
    static let shared = Flavor()
    init() {}
    
    func configFlavor(env: EnvironmentKey) {
        switch (env) {
        case .stg:
            baseUrl = Constants.STAGING_URL
            baseApi = Constants.STAGING_API
            basePortal = Constants.URL_PORTAL_STG
        case .sandbox:
            baseUrl = Constants.SANDBOX_URL
            baseApi = Constants.SANDBOX_API
            basePortal = Constants.URL_PORTAL_SAND
        case .production:
            baseUrl = Constants.PROD_URL
            baseApi = Constants.PROD_API
            basePortal = Constants.URL_PORTAL_PROD
        }
    }
    
    func getBaseUrl() -> String {
        print(baseUrl)
        return baseUrl
    }
    
    func getBaseApi() -> String {
        return baseApi
    }
    
    func getBasePortal() -> String {
        return basePortal
    }
    
}
