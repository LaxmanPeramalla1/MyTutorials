//
//  ForGotPwdPhoneNumValidation.swift
//  MixerRadio
//
//  Created by Laxman on 08/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar
class ForGotPwdPhoneNumValidation: UIViewController,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    var pickerData: [String] = [String]()
    var myPickerView: UIPickerView!
    @IBOutlet var countryCodeTxt: UITextField!
    @IBOutlet var mobileNumTxt: UITextField!
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["+91", "+1"]
//        countryCodeTxt.text = "+91"
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
        if !(9 ~= enterStr.characters.count) {
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
    
    @IBAction func validatePhoneNumver(_ sender: UIButton) {
        validatePhonenumbers()
    }
    func validatePhonenumbers() {
        
        guard let mobileNum = countryCodeTxt.text, isValid(enterStr: mobileNum) else {
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
            "ISDCode":countryCodeTxt.text!,
            "MobileNumber":mobileNumTxt.text!] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+VALIDATEPHONENUMBERFOROTP, para: info , onCompletion: { (responseJson) in
             self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                if responseJson["StatusCode"].intValue != 0 {
                    self.message.text = "Successfully validated Mobile Number"
                    MDCSnackbarManager.show(self.message)
                    
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "otpView") as! ForgotPwdOTPViewController
                self.navigationController?.pushViewController(VC, animated: true)
                }else {
                    self.alertviewWithStatus(APiStatus: responseJson["StatusDescription"].stringValue as NSString)
                }
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryCodeTxt {
            pickUp(countryCodeTxt)
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.countryCodeTxt.text = pickerData[row]
    }
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UserProfile.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(UserProfile.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    @objc func doneClick() {
        self.pickUp(countryCodeTxt)
        countryCodeTxt.resignFirstResponder()
    }
    @objc func cancelClick() {
        countryCodeTxt.text = ""
        countryCodeTxt.resignFirstResponder()
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
