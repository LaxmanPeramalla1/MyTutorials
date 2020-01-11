//
//  MobileVerificationViewController.swift
//  MixerRadio
//
//  Created by Laxman Peramalla on 06/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import Reachability
import SwiftyJSON
class MobileVerificationViewController: UIViewController {

    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    @IBOutlet var mobileISDcodeTxt: UITextField!
    @IBOutlet var mobileNoTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if !(10...15 ~= enterStr.characters.count) {
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
//        guard let isdCode = mobileISDcodeTxt.text, isValid(enterStr: isdCode) else {
//            self.alertviewWithStatus(APiStatus: "Please enter ISD code")
//            return
//        }
        guard let mobileNum = mobileNoTxt.text, isValid(enterStr: mobileNum) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid Mobile number")
            return
        }
        
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let info = [
            "ISDCode":"+91",
            "MobileNumber":mobileNoTxt.text!] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+FORGOTPWDVARIFYWITHOTP, para: info , onCompletion: { (responseJson) in
            self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                self.message.text = "Successfully validated Mobile Number"
                MDCSnackbarManager.show(self.message)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "signupOtpVC") as! OTPVerificationViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        })
        
    }
    @IBAction func verifyOtp_action(_ sender: Any) {
        varifyOTPcode()
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
