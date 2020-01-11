//
//  CuntryAndPhoneViewController.swift
//  MixerRadio
//
//  Created by Laxman on 24/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftyJSON
class CuntryAndPhoneViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var countryCodeTxt: UITextField!
    @IBOutlet var mobileNumTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        countryCodeTxt.text = "+91"
        // Do any additional setup after loading the view.
    }

    @IBAction func validatePhoneNumver(_ sender: UIButton) {
        validatePhonenumbers()
    }
    func validatePhonenumbers() {
        let info = [
            "ISDCode":"+91",
            "MobileNumber":mobileNumTxt.text!] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+"MobileVerificationToGetOTPByUserName", para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "otpView") as! ForgotPwdOTPViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
            
        })
        
    }
    @IBAction func backToPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == countryCodeTxt || textField == mobileNumTxt {
            
        }
        
        textField.resignFirstResponder()
        return true
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
