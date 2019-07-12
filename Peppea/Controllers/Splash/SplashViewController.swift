//
//  SplashViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var animateView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

         (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
//        (UIApplication.shared.delegate as! AppDelegate).GoToHome()


        // Do any additional setup after loading the view.
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
