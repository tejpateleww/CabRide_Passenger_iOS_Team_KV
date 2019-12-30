//
//  WalletWebPageVC.swift
//  Peppea
//
//  Created by EWW082 on 27/12/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import WebKit

protocol ProcessCompleteDelegate {
    func didFinish(WalletBalance:String, PaymentStatus:Bool)
}

class WalletWebPageVC: BaseViewController {

   
    //MARK:- Variables
    var WebView:WKWebView!
    var PaymentDelegate:ProcessCompleteDelegate?
    var strURL:String = ""
    var Balance:String = ""
    
    
    //MARK:- View Life Cycle Methods
    
    override func loadView() {
        super.loadView()
        WebView = WKWebView()
        WebView.navigationDelegate = self
        view = WebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let WebURL = URL(string: self.strURL)!
        WebView.load(URLRequest(url: WebURL))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK:- WebView Delegate Methods

extension WalletWebPageVC : WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
       
            if let NavigateURL = navigationAction.request.url?.absoluteString
            {
                if NavigateURL == PaymentSuccessURL {
                    self.PaymentDelegate?.didFinish(WalletBalance: Balance, PaymentStatus: true)
                    self.navigationController?.popViewController(animated: true)
                }
                else if NavigateURL == PaymentFailureURL {
                    self.PaymentDelegate?.didFinish(WalletBalance: Balance, PaymentStatus: false)
                    self.navigationController?.popViewController(animated: true)
                }
                //do what you need with url
                //self.delegate?.openURL(url: navigationAction.request.url!)
            }
        decisionHandler(.allow)
    }
    
}
