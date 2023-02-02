//
//  NWebviewController.swift
//  NPayFramework
//
//  Created by Vu Pham on 15/08/2022.
//

import UIKit
import WebKit
import AVFoundation

class NWebviewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    
    private var wkWebView: WKWebView!
    //    private var closeBtn: UIButton!
    
    var strUrl = "https://stackoverflow.com/"
    var headerWeb: String?
    
    var didCallBackWebView: ((_ newUrl: String) -> Void)?
    var isSecondWeb = false
    var isPushed = false
    var delegate: LibListener?
    var currentUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configWebview()
        loadRequest(header: headerWeb)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configWebview() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "executeFunction")
        //        contentController.addUserScript(script)
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        view.addSubview(wkWebView)
        //Add constraint
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        wkWebView.navigationDelegate = self
        wkWebView.keyboardDisplayRequiresUserAction = false
        wkWebView.backgroundColor = .white
        
        dismissBtn.backgroundColor = .white.withAlphaComponent(0.8)
        dismissBtn.layer.cornerRadius = 30/2
        dismissBtn.setTitle("", for: .normal)
        
    }
    
    @objc func closeBtn(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        let firstWebLoad: Bool = currentUrl.contains("/kyc/ket-qua")
        ///Handle for Cancel/close webview button. Web1 reload when web2 update kyc result
        self.dismiss(animated: true) {
            if (firstWebLoad) {
                self.didCallBackWebView?(Flavor.shared.baseUrl+"#home?reload=true")
            }
        }
    }
    
    func loadRequest(header: String?) {
        if let url = URL(string: strUrl) {
            var request = URLRequest(url: url)
            if let header1 = header {
                request.setValue(header1, forHTTPHeaderField: "Authorization")
            }
            wkWebView.load(request)
        }
    }
    
    // Nghe JS từ webview
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //        print("Here is message body \(message.body)")
        
        if (message.name == "executeFunction") {
            if let bodyDict = message.body as? [String: Any] {
                if let command = bodyDict["command"] as? String {
                    let param = bodyDict["params"] as? String ?? ""
                    let paramDict = convertToDictionary(text: param)
                    handleJSAction(command: command, param: paramDict)
                }
            }
            
        }
    }
    
    //Check Domain webview
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let newUrl = navigationAction.request.url?.absoluteString  else{ return }
        //        print("DOMAIN URL: \(String(describing: navigationAction.request.url?.host))")
                print("URL SDK: \(newUrl)")
        self.currentUrl = newUrl
        
        if (!newUrl.contains(Flavor.shared.getBaseUrl()) || newUrl.contains("kyc")) {
            self.navigationView.isHidden = false
        } else  {
            self.navigationView.isHidden = true
        }
        
        if (self.isSecondWeb && self.isPushed && newUrl.contains("sdk.9pay")) {
            didCallBackWebView?(newUrl)
            self.navigationController?.popViewController(animated: true)
        }
        
        if (self.isSecondWeb && !self.isPushed && newUrl == Flavor.shared.getBaseUrl()) {
//            didCallBackWebView?(newUrl)
            self.didCallBackWebView?(Flavor.shared.getBaseUrl()+"#home?reload=true")
            self.dismiss(animated: true)
        }
        
        ///Sau khi thanh toán payment gate
        if (newUrl.contains("/merchant/payment/")) {
            //            self.navigationController?.dismiss(animated: false,completion: {
            self.didCallBackWebView?(newUrl)
            //            })
        }
        
        decisionHandler(.allow)
    }
    
    func handleJSAction(command: String, param: [String: Any]?) {
        //        showToast(command)
        switch (command) {
        case "onLoggedInSuccess":
            self.delegate?.onLoginSuccessfull()
            break
        case "onPaymentSuccess":
            self.delegate?.onPaySuccessful()
            break
        case "onError":
            if let errorCode = param?["error_code"] as? Int, let msg = param?["message"] as? String {
                self.delegate?.onError(errorCode: errorCode, message: msg)
            }
            break
        case "getAllToken":
            if let accessToken = param?["access_token"] as? String {
                UserDefaults.setValue(value: accessToken, key: .accessToken)
            }
            if let refreshToken = param?["refresh_token"] as? String {
                UserDefaults.setValue(value: refreshToken, key: .refreshToken)
            }
            break
        case "getDeviceID":
            if let deviceID = param?["device_id"] as? String {
                UserDefaults.setValue(value: deviceID, key: .deviceID)
            }
            break
        case "open9PayApp":
            if let url = URL(string: "fb3968505046507997://"),
               UIApplication.shared.canOpenURL(url) {
                
                UIApplication.shared.open(url)
            }
            else {
                UIApplication.shared.open(URL(string: "itms-apps://apple.com/app/id1484320059")!)
            }
            break
        case "close":
            self.dismiss(animated: true)
            //            self.navigationController?.popViewController(animated: true)
            break
        case "openOtherUrl":
            if let url = param?["url"] as? String {
                //                if (url.contains(stgDomain)) {
                //                    let token = param?["token"] as? String ?? ""
                //                    self.strUrl = URL(string:url)!.absoluteString
                //                    self.loadRequest(header: token)
                //                    return
                //                }
                guard let url = URL(string:url) else {return}
                let urlFinal = url
                let web2 = NWebviewController(nibName: "NWebviewController", bundle: Bundle(identifier: "com.9payjsc.vn.NPayFramework"))
                let token = param?["token"] as? String ?? ""
                web2.strUrl = urlFinal.absoluteString
                web2.isSecondWeb = true
                
                web2.didCallBackWebView =  { [weak self] newUrl in
                    
                        self?.strUrl = newUrl
                        self?.loadRequest(header: nil)
                
                }
                if (url.absoluteString.contains("v1/kyc")) {
                    web2.modalPresentationStyle = .fullScreen
                    web2.headerWeb = token
                    self.present(web2, animated: true)
                    return
                }
                //                self.present(web2, animated: true)
                web2.isPushed = true
                self.navigationController?.pushViewController(web2, animated: true)
            }
            break
        case "clearToken":
            WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache,
                                                              WKWebsiteDataTypeLocalStorage], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{ })
            UserDefaults.removeUser()
            break
        case "requestCamera":
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    //access granted
                } else {
                    
                }
            }
            break
        case "depositResult":
            break
        case "share":
            if let sharedString = param?["text"] as? String {
                let textShare = [ sharedString ]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            break
        case "copy":
            if let copiedString = param?["text"] as? String {
                UIPasteboard.general.string = copiedString
            }
            break
        case "call":
            if let phone = param?["text"] as? String {
                if let url = URL(string: "\(phone)") { //remove "tel://" because it include in param
                     UIApplication.shared.open(url)
                 }
            }
            break
        
        default: break
            //
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
}
extension String {
    func  percentEncoded() -> String? {
        return (self as NSString).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
}
