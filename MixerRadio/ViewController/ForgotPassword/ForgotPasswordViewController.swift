//
//  ForgotPasswordViewController.swift
//  MixerRadio
//
//  Created by Laxman on 22/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftyJSON
class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = .red
        self.view.addSubview(view)
        // Do any additional setup after loading the view.
    }
    func generateOTP() {
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+FORGOTPWDOTPVALIDATE, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "otpView") as! ForgotPwdOTPViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
        })
        
    }
    @IBAction func securityAndOtpPasscodeAction(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "securityView") as! ForgotPwdSecQueViewController
            self.navigationController?.pushViewController(VC, animated: true)
            VC.validateUserStatus = "showAskQuestionView"

        }else if sender.tag == 3 {
            self.navigationController?.popViewController(animated: true)
        }else {
           generateOTP()
        }
//
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
