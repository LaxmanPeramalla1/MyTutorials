//
//  ForgotPwdSecQueViewController.swift
//  MixerRadio
//
//  Created by Laxman on 22/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialSnackbar
import SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar

class ForgotPwdSecQueViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var askQuestionsView: UIView!
    @IBOutlet var usernameEntryView: UIView!
    @IBOutlet var userNameTxtFld: UITextField!
     @IBOutlet var askQueTxt: UITextField!
     @IBOutlet var ansQueTxt: UITextField!
    var pickerData: [String] = [String]()
    var myPickerView: UIPickerView!
     var questionsArray:[String] = []
    var validateUserStatus = NSString()
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()

        // pickerData = ["Question No1", "Question No2", "Question No3", "Question No4", "Question No5"]
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if validateUserStatus == "showAskQuestionView" {
            self.askQuestionsView.isHidden = false
            self.usernameEntryView.isHidden = true
             self.questionsRequest()
        }else{
            self.askQuestionsView.isHidden = true
            self.usernameEntryView.isHidden = false
        }
        self.usernameEntryView.backgroundColor = UIColor.clear
        self.askQuestionsView.backgroundColor = UIColor.clear
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
    func validateUserName() {
        guard let userName = userNameTxtFld.text, isValid(enterStr: userName) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid Username")
            return
        }
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let URLstr = BASE_URL+FORGOTPWDVALIDATEUSERNAME+userNameTxtFld.text!
        _ = APIManager.sharedInstance.getApicall(url:URLstr,  onCompletion: { (responseJson) in
            print(responseJson)
             self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                if responseJson["result"]["StatusCode"].intValue != 0 {
                    self.message.text = "Successfully validated Username"
                    MDCSnackbarManager.show(self.message)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set( Int16(responseJson["Data"].intValue), forKey: "USERID")
                    self.userNameTxtFld.resignFirstResponder()
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "forgotpwdVC") as! ForgotPasswordViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                else {
                    self.alertviewWithStatus(APiStatus: responseJson["result"]["StatusDescription"].stringValue as NSString)
                }
            }
        })
       
    }
    func alertviewWithStatus(APiStatus: NSString) {
        // create the alert
        let alert = UIAlertController(title: "MixerRadio", message: APiStatus as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func validateSequrityQuestions() {
        
        guard let question = askQueTxt.text, isValid(enterStr: question) else {
            self.alertviewWithStatus(APiStatus: "Please select the Question")
            return
        }
        guard let ansTxt = ansQueTxt.text, isValid(enterStr: ansTxt) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid Ans")
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
            "SecurityQuestion":askQueTxt.text!,
            "SecurityAnswer":ansQueTxt.text!,
            "UserID":value] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+FORGOTPWDVALIDATESECURITYQUESTION, para: info , onCompletion: { (responseJson) in
            //SVProgressHUD.dismiss()
             self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                   if responseJson["result"]["StatusCode"].intValue != 0 {
                    self.message.text = "Successfully validated"
                    MDCSnackbarManager.show(self.message)
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "conformView") as! ForgotPwdConformViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                   }else {
                    self.alertviewWithStatus(APiStatus: responseJson["result"]["StatusDescription"].stringValue as NSString)
                }
              
            }
            
            
        })
    }
    func questionsRequest() {
        let URLstr1 = BASE_URL+FORGOTPWDGETSECURITYQUESTIONS
        _ = APIManager.sharedInstance.getApicall(url:URLstr1,  onCompletion: { (responseJson) in
            
            if responseJson != JSON.null
            {
                print(responseJson)
                print(JSON(responseJson["Question"].stringValue))
                for newJson in responseJson.array! {
                    let questionNames =  newJson["Question"].stringValue
                    self.questionsArray.append(questionNames)
                }
                print(self.questionsArray)
                
                
            }
        })
    }
    @IBAction func nextAndVerify_Actions(_ sender: UIButton) {
        if sender.tag == 1 {
             // next functionality
//            self.askQuestionsView.isHidden = true
//            self.usernameEntryView.isHidden = false
            validateUserName()
        
        }else if sender.tag == 2 {
            // ask question Functionality
            validateSequrityQuestions()
        }else {
            self.navigationController?.popViewController(animated: true)
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
        return questionsArray.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return questionsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.askQueTxt.text = questionsArray[row]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == askQueTxt {
            pickUp(askQueTxt)
            self.myPickerView.reloadAllComponents()
        }
        
        
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
        
        askQueTxt.resignFirstResponder()
    }
    @objc func cancelClick() {
        askQueTxt.text = ""
        
        askQueTxt.resignFirstResponder()
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
