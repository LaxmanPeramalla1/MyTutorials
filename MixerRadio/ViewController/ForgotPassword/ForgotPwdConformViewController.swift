//
//  ForgotPwdConformViewController.swift
//  MixerRadio
//
//  Created by Laxman on 22/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar
class ForgotPwdConformViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var conformPwdTxt: UITextField!
    @IBOutlet var reEnterconformPwdTxt: UITextField!
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        // Do any additional setup after loading the view.
    }

    @IBAction func saveConformationPwds(_ sender: UIButton) {
        validateSequrityQuestions()
    }
    func validateSequrityQuestions() {
        
        guard let confirmTxt = conformPwdTxt.text, isValid(enterStr: confirmTxt) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid text")
            return
        }
        guard let reenterTxt = reEnterconformPwdTxt.text, isValid(enterStr: reenterTxt) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid text")
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
        print(value)
        let info = [
            "NewPassword":conformPwdTxt.text!,
            "ConfirmPassword":reEnterconformPwdTxt.text!,
            "UserID":value] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+CREATENEWPWD, para: info , onCompletion: { (responseJson) in
            //SVProgressHUD.dismiss()
            if responseJson != JSON.null
            {
                self.stopActivityIndicator()
                self.message.text = "Successfully Changed Password"
                MDCSnackbarManager.show(self.message)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
            
        })
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == conformPwdTxt || textField == reEnterconformPwdTxt {
            
        }
        
        textField.resignFirstResponder()
        return true
    }
    @IBAction func backToPreview_screen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
