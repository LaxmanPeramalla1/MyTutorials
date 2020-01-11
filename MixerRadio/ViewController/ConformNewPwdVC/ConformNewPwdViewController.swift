//
//  ConformNewPwdViewController.swift
//  MixerRadio
//
//  Created by Laxman on 24/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar
class ConformNewPwdViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var oldPwdTxt: UITextField!
    @IBOutlet var newPwdTxt: UITextField!
    @IBOutlet var confirmPwdTxt: UITextField!
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func resetNewPwd_Action(_ sender: Any) {
        resetPwd_APi_Service()
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
        if !(7...15 ~= enterStr.characters.count) {
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
    func resetPwd_APi_Service() {
        
        guard let oldPwd = oldPwdTxt.text, isValid(enterStr: oldPwd) else {
            self.alertviewWithStatus(APiStatus: "Please enter old password")
            return
        }
        guard let newPwd = newPwdTxt.text, isValid(enterStr: newPwd) else {
            self.alertviewWithStatus(APiStatus: "Please enter new password")
            return
        }
        guard let confirmPwd = confirmPwdTxt.text, isValid(enterStr: confirmPwd) else {
            self.alertviewWithStatus(APiStatus: "Please enter confirm password")
            return
        }
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let userDefaults = UserDefaults.standard
        let value  = userDefaults.integer(forKey: "USERID")
        let info = [
            "OldPassword":oldPwdTxt.text!,
            "NewPassword":newPwdTxt.text! ,
            "ConfirmPassword":confirmPwdTxt.text!,
            "UserID":value] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+RESETPWD, para: info , onCompletion: { (responseJson) in
            //SVProgressHUD.dismiss()
             self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                self.message.text = "Successfully reset your password"
                MDCSnackbarManager.show(self.message)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
            
        })
    }
    @IBAction func backToDashboard(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
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
