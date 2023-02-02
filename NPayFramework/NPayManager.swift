//
//  NPayManager.swift
//  NPayFramework
//
//  Created by Vu Pham on 10/06/2022.
//

import Foundation
import UIKit
import WebKit

struct QueryItem {
    var name: String?
    var value: String?
}

let Not_LOGIN = 407
let TOKEN_EXPIRED = 403
let ERROR_PAYMENT = 10002

//let stgDomain = Constants.SANDBOX_URL
//let apiDomain = Constants.SANDBOX_API
public protocol LibListener {
    
    func onLoginSuccessfull()
    
    func onPaySuccessful()
    
    func getInfoSuccess(phone: String, balance: String, ekycStatus: String)
    
    func getMerchantActionSuccess(actions: [String])
    
    func onError(errorCode: Int, message: String)
}

public class NPayManager {
    static let STAGING = "staging"
    static let BETA = "beta"
    static let PRODUCTION = "prod"
    //    let sdkConfig = SDK
    let deviceName = UIDevice.current.name
    var deviceID = UserDefaults.standard.string(forKey: "device_id")
    let os = UIDevice.current.systemVersion
    let uniqueID = UIDevice.current.identifierForVendor?.uuidString
    let request = APIRequest()
    private var sdkConfig: SDKConfigs!
    public var delegate: LibListener?
    
    var viewController: UIViewController
    var bundle = Bundle(for: NWebviewController.self)
    
    public init(vController: UIViewController, sdkCfgs: SDKConfigs) {
        viewController = vController
        sdkConfig = sdkCfgs
//        let token = UserDefaults.getSavedValue(.accessToken) ?? ""
//        print("TOKEN: \(token)")
    }
    
    public func login() {
        let data = self.walletData(route: Actions.LOGIN)
        let nWalletVC = NWebviewController(nibName: "NWebviewController", bundle: Bundle(identifier: "com.9payjsc.vn.NPayFramework") )
        guard let url = URL(string: Flavor.shared.getBaseUrl() + "/direct") else { return }
        var urlFinal = url
        for item in data {
            urlFinal.appendQueryItem(name: item.key, value: item.value as? String)
        }
        nWalletVC.delegate = self.delegate
        nWalletVC.strUrl = urlFinal.absoluteString
        nWalletVC.navigationController?.isNavigationBarHidden = true
        let navi = UINavigationController(rootViewController: nWalletVC)
        navi.modalPresentationStyle = .fullScreen
        self.viewController.present(navi, animated: true)
    }
    
    public func getActionMerchant() {
        request.getMerchantAction(header: getHeader()) { (result) in
            switch (result) {
            case .success(let userResponse):
                
                if (userResponse.errorCode == 0) {
                    var actions: [String] = []
                    userResponse.data?.forEach({ action in
                        actions.append(action.action ?? "")
                    })
                    self.delegate?.getMerchantActionSuccess(actions: actions)
                } else {
                    self.delegate?.onError(errorCode: userResponse.errorCode ?? 1, message: userResponse.message ?? "Something's wrong!")
                }
                break
            case .failure(let error):
                print("ERR \(error)")
                break
//                if let err = error as NSError? {
//                    self.delegate?.onError(errorCode: error.errorCode ?? 1, message: error.message ?? "Something's wrong!")
//                }
            }
        }
    }
    
    public func openWallet(action: String) {
        let url9Shop: String = "https://stg-shop.9pay.mobi/hoa-don-thanh-toan/"
        var isOpen9Shop: Bool = false
        let data = self.walletData(route: action)
        let nWalletVC = NWebviewController(nibName: "NWebviewController", bundle: bundle )
        guard let url = URL(string: Flavor.shared.getBaseUrl()) else { return }
        var urlFinal = url
        
        let routerContains = (data["route"] != nil);
        if (routerContains)
        {
            let valueRoute:String = data["route"] as! String;
            if (valueRoute == "shop")
            {
                isOpen9Shop = true;
            }
        }
            
        urlFinal.appendPathComponent("/direct")

        for item in data {
            urlFinal.appendQueryItem(name: item.key, value: item.value as? String)
        }
        nWalletVC.delegate = self.delegate
        nWalletVC.strUrl = isOpen9Shop ? url9Shop : urlFinal.absoluteString
        nWalletVC.navigationController?.isNavigationBarHidden = true
        let navi = UINavigationController(rootViewController: nWalletVC)
        navi.modalPresentationStyle = .fullScreen
        self.viewController.present(navi, animated: true)
//        self.navigationController.pushViewController(nWalletVC, animated: false)
        
    }
    
    public func paymentMerchant(urlPayment: String) {
        let nWalletVC = NWebviewController(nibName: "NWebviewController", bundle: Bundle(identifier: "com.9payjsc.vn.NPayFramework") )
        guard let url = URL(string: urlPayment) else { return }
//        guard let url = URL(string: "https://developers.9pay.vn/demo-portal") else { return }
//        guard let url = URL(string: "https://sand-payment.9pay.vn/portal?baseEncode=eyJtZXJjaGFudEtleSI6Imp1QU94TCIsInRpbWUiOjE2NzExNTg2NDUsImludm9pY2Vfbm8iOiJMblMyNnRYRiIsImFtb3VudCI6MTAwMDAsImRlc2NyaXB0aW9uIjoiVGhpcyBpcyBkZXNjcmlwdGlvbiIsInJldHVybl91cmwiOiJodHRwOi8vZmNkY2M0NzY3YWNiLm5ncm9rLmlvLyIsImJhY2tfdXJsIjoiaHR0cDovL2ZjZGNjNDc2N2FjYi5uZ3Jvay5pby8iLCJtZXRob2QiOiI5UEFZIn0%3D&signature=kWx%2Fue9r1rypHvWx4quhZTOWltnx%2Ba1ZSatpinIF4Jw%3D") else {
//            return
//            
//        }
        nWalletVC.strUrl = url.absoluteString
        nWalletVC.didCallBackWebView = { newUrl in
            self.viewController.dismiss(animated: false)
            let orderID = newUrl.replacingOccurrences(of: Flavor.shared.getBasePortal(), with: "")
            self.pay(orderID)
        }
        nWalletVC.navigationController?.isNavigationBarHidden = true
        let navi = UINavigationController(rootViewController: nWalletVC)
        navi.modalPresentationStyle = .fullScreen
        self.viewController.present(navi, animated: true)
    }
    
    public func openKYC() {
//    https://stg-sdk.9pay.mobi/v1/get-token/
        let data = getHeader()
        let nWalletVC = NWebviewController(nibName: "NWebviewController", bundle: Bundle(identifier: "com.9payjsc.vn.NPayFramework") )
//        guard let url = URL(string: stgDomain + "/v1/get-token/") else { return }
        guard let url = URL(string: Flavor.shared.getBaseUrl() + "/v1/kyc" + "?phone=0963214569&isSDK=1") else { return }
        var urlFinal = url
        for item in data {
            urlFinal.appendQueryItem(name: item.key, value: item.value as? String)
        }
        urlFinal.appendQueryItem(name: "Authorization", value: "Bearer " + (UserDefaults.getSavedValue(.accessToken) as? String ?? "accessToken"))
        nWalletVC.strUrl = urlFinal.absoluteString
        nWalletVC.navigationController?.isNavigationBarHidden = true
        let navi = UINavigationController(rootViewController: nWalletVC)
        navi.modalPresentationStyle = .fullScreen
        self.viewController.present(navi, animated: true)
    }
    
    public func pay(_ orderID: String) {
        let data = self.paymentData(orderId: orderID)
        
        let nWalletVC = NWebviewController(nibName: "NWebviewController", bundle: Bundle(identifier: "com.9payjsc.vn.NPayFramework") )
        guard let url = URL(string: Flavor.shared.getBaseUrl() + "/direct") else { return }
        var urlFinal = url
        for item in data {
            urlFinal.appendQueryItem(name: item.key, value: item.value as? String)
        }
        nWalletVC.strUrl = urlFinal.absoluteString
        nWalletVC.navigationController?.isNavigationBarHidden = true
        let navi = UINavigationController(rootViewController: nWalletVC)
        navi.modalPresentationStyle = .fullScreen
        self.viewController.present(navi, animated: true)
    }
    
    public func open9PayApp() {
        if let url = URL(string: "9Pay://") {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url)
            } else {
                if let url = URL(string: "itms-apps://apple.com/app/id1484320059") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    public func getAccountInfo() {
        //TODO check token == nil => return else do something
        if(UserDefaults.getSavedValue(.accessToken) == nil || UserDefaults.getSavedValue(.accessToken) as? String == "") {
            return
        }
        request.getUserInfo(header: getHeader()) { (result) in
            
            switch (result) {
            case .success(let userResponse):
                
                if (userResponse.errorCode == 0) {
                    self.delegate?.getInfoSuccess(phone: userResponse.data?.phone ?? "", balance: "\(userResponse.data?.balance ?? 0)", ekycStatus: "\(userResponse.data?.status ?? -1)")
                } else {
                    self.delegate?.onError(errorCode: userResponse.errorCode ?? 1, message: userResponse.message ?? "Something's wrong!")
                }
                
            case .failure(let error):
                print("ERR \(error)")
                if let err = error as NSError? {
                    if (err.code == 403) {
                        self.request.refreshAccessToken { (resultRefresh) in
                            switch (resultRefresh) {
                            case .success(let refreshResponse):
                                if (refreshResponse.errorCode == 0) {
                                    UserDefaults.setValue(value: refreshResponse.data?.accessToken, key: .accessToken)
                                    UserDefaults.setValue(value: refreshResponse.data?.refreshToken, key: .refreshToken)
                                    self.getAccountInfo()
                                } else {
                                    self.delegate?.onError(errorCode: refreshResponse.errorCode ?? 1, message: refreshResponse.message ?? "Something's wrong!")
                                }
                                break
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
                break
                //                self.delegate?.getInfoSuccess(phone: "0961190498", balance: "10000", ekycStatus: "1")
            }
            
            
        }
    }
    
    public func refreshAccessToken() {
//        print("\(String(describing: UserDefaults.getSavedValue(.refreshToken)))")
        self.request.refreshAccessToken { (resultRefresh) in
            switch (resultRefresh) {
            case .success(let refreshResponse):
                if (refreshResponse.errorCode == 0) {
                    UserDefaults.setValue(value: refreshResponse.data?.accessToken, key: .accessToken)
                    UserDefaults.setValue(value: refreshResponse.data?.refreshToken, key: .refreshToken)
                    self.getAccountInfo()
                } else {
                    self.delegate?.onError(errorCode: refreshResponse.errorCode ?? 1, message: refreshResponse.message ?? "Something's wrong!")
                }
                
                break
            case .failure(_):
                break
            }
        }
    }
    
    public func logout() {
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeLocalStorage], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{ })
        UserDefaults.removeUser()
        self.delegate?.onError(errorCode: -1, message: "Logout success")
    }
    
    public func close() {
//        self.navigationController.popViewController(animated: true)
        self.viewController.dismiss(animated: true)
    }
    
    private func walletData(route: String) -> [String: Any] {
        var data = getHeader()
        if (route != Actions.OPEN_WALLET) {
            data["route"] = route
        }
        data["brand_color"] = sdkConfig.getBrandColor()
        return data
    }
    
    private func paymentData(orderId: String) -> [String: Any] {
        var data = getHeader()
        data["route"] = "payment_merchant_verify"
        data["order_id"] = orderId
        return data
    }
    
    private func getHeader() -> [String: Any] {
//        request.addValue("Bearer "+(UserDefaults.getSavedValue(.accessToken) as? String ?? "accessToken"), forHTTPHeaderField: "Authorization")
        let header: [String: Any] = [
            "Merchant-Code": sdkConfig.getMerchantCode(),
            "Merchant-Uid": sdkConfig.getUid(),
//            "Authorization":"Bearer " + (UserDefaults.getSavedValue(.accessToken) as? String ?? "accessToken")
//            "env": sdkConfig.getEnv(),
//            "Device-ID" : UserDefaults.getSavedValue(.deviceID) as? String ?? ""
        ]
        return header
    }
    
    func getHeaderInfo() -> [String: Any] {
        //        print("Header \n *****")
        //        var array: [QueryItem] = []
        //        array.append(QueryItem(name: "Device-Name", value: deviceName))
        //        array.append(QueryItem(name: "Device-ID", value: deviceID))
        //        array.append(QueryItem(name: "OS", value: os))
        //        array.append(QueryItem(name: "unique-id", value: uniqueID ?? "N/A"))
        //        array.append(QueryItem(name: "App-Version", value: "3.2.7"))
        //        array.append(QueryItem(name: "App-version-Code", value: "352"))
        ////        array.append(QueryItem(name: "Merchant-Code", value: self.merchantCode!))
        ////        array.append(QueryItem(name: "Merchant-Uid", value: self.merchantUid!))
        //        array.append(QueryItem(name: "platform", value: "iOS"))
        
        let headerDict: [String : Any] = [
            "Device-Name": deviceName,
            "Device-ID": deviceID ?? "N/A",
            "OS": os,
            "unique-id": uniqueID ?? "N/A",
            "Merchant-Code":"code",
            "Merchant-Uid":"UDI",
            "env":"STAGING",
            "platform": "iOS",
        ]
        //        if (self.orderID != "" )
        //        {
        //            array.append(QueryItem(name: "order_id", value: self.orderID))
        //            array.append(QueryItem(name: "route", value: "payment_merchant_verify"))
        //        }
        
        
        return headerDict
    }
}


public class SDKConfigs {
    private var merchantCODE = ""
    private var uID = ""
    private var brdColor = "0"
//    private var env =  ""
//    private var publicKEY =  ""
//    private var privateKEY =  ""
    
    public init(merchantCode: String, uid: String, brandColor: String, env: EnvironmentKey) {
        merchantCODE = merchantCode
        uID = uid
        brdColor = brandColor
        Flavor.shared.configFlavor(env: env)
    }
    
    public func getMerchantCode() -> String {
        return merchantCODE;
    }
    
    public func getUid() -> String{
        return uID;
    }

    public func getBrandColor() -> String {
        return brdColor;
    }
    
}

extension URL {
    
    mutating func appendQueryItem(name: String, value: String?) {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        self = urlComponents.url!
    }
}
