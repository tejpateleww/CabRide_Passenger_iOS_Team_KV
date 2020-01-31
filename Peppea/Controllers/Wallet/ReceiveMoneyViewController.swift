//
//  ReceiveMoneyViewController.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ReceiveMoneyViewController: BaseViewController {

    // MARK:- Outlets
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    // MARK:- Variables
    var loginModelDetails : LoginModel = LoginModel()
    
    // MARK:- View Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithBack(Title: "Receive Money", IsNeedRightButton: true)
        
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        // Do any additional setup after loading the view.
        do{
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        let profile = loginModelDetails.loginData
        let finalStrImg = imagBaseURL + profile!.qrCode
        self.imgQRCode.sd_setImage(with: URL(string: finalStrImg), completed: nil)//https://parksmart.online/
        self.lblUserName.text = profile!.firstName + " " + profile!.lastName
    }
    
    // MARK:- Actions
    
    @IBAction func btnShareQRCodeAction(_ sender: UIButton) {
        shareingQRCode()
    }
    
    // MARK:- Custom Methods
    func shareingQRCode() {
        
        guard let myQRCode = imgQRCode.takeScreenshot() else { return }
        
        let items = [myQRCode]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
}

//extension ReceiveMoneyViewController: UIActivityItemSource {
//
//
//
//}
