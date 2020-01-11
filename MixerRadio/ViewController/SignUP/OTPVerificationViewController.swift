//
//  OTPVerificationViewController.swift
//  MixerRadio
//
//  Created by Laxman Peramalla on 06/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import Reachability
import SwiftyJSON
class OTPVerificationViewController: UIViewController {
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    @IBOutlet var singupOtpTxtFld1: UITextField!
    @IBOutlet var singupOtpTxtFld2: UITextField!
    @IBOutlet var singupOtpTxtFld3: UITextField!
    @IBOutlet var singupOtpTxtFld4: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        singupOtpTxtFld1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        singupOtpTxtFld2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        singupOtpTxtFld3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        singupOtpTxtFld4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otpTxtFld1.becomeFirstResponder()
    }
    func showActivityIndicator() {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        spinnerActivity.isUserInteractionEnabled = false;
    }
    func stopActivityIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true);
        
    }
    
    func isValid(enterStr: String) -> Bool {
        // check the name is between 7 and 15 characters
        if !(1...15 ~= enterStr.characters.count) {
            return false
        }
        return true
    }
    func alertviewWithStatus(APiStatus: NSString) {
        // create the alert
        let alert = UIAlertController(title: "MixerRadio", message: APiStatus as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func varifyOTPcode() {
        guard let otp1 = otpTxtFld1.text, isValid(enterStr: otp1) else {
            self.alertviewWithStatus(APiStatus: "Please OTP")
            return
        }
        guard let otp2 = otpTxtFld2.text, isValid(enterStr: otp2) else {
            self.alertviewWithStatus(APiStatus: "Please OTP")
            return
        }
        guard let otp3 = otpTxtFld3.text, isValid(enterStr: otp3) else {
            self.alertviewWithStatus(APiStatus: "Please OTP")
            return
        }
        guard let otp4 = otpTxtFld4.text, isValid(enterStr: otp4) else {
            self.alertviewWithStatus(APiStatus: "Please OTP")
            return
        }
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let otpTxt = singupOtpTxtFld1.text!+singupOtpTxtFld2.text!+singupOtpTxtFld3.text!+singupOtpTxtFld4.text!
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "ISDCode":otpTxt,
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+FORGOTPWDVARIFYWITHOTP, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.stopActivityIndicator()
                self.message.text = "Successfully validated OTP"
                MDCSnackbarManager.show(self.message)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "conformView") as! ForgotPwdConformViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        })
        
    }
    @IBAction func verifyOtp_action(_ sender: Any) {
        varifyOTPcode()
    }
    
    @objc func  textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case otpTxtFld1:
                singupOtpTxtFld2.becomeFirstResponder()
            case singupOtpTxtFld2:
                singupOtpTxtFld3.becomeFirstResponder()
            case singupOtpTxtFld3:
                singupOtpTxtFld4.becomeFirstResponder()
            case singupOtpTxtFld4:
                singupOtpTxtFld4.resignFirstResponder()
            default:
                print("Some other character")
            }
            
        }
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
