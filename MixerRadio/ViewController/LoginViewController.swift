//
//  ViewController.swift
//  MixerRadio
//
//  Created by Archana Kaveti on 4/5/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
//import SwiftMessages
import Alamofire
import SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar
class LoginViewController: ParentViewController, RadioStreamingObserver {
  
    
    @IBOutlet weak var scrollView: LoginScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    // Constraints
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet var menuBarBtn: UIButton!
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
     var UsersList: [UserDetails] = [UserDetails]()
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
     var radioManager:RadioAudioManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3.  Observe (listen for) "special notification key"
//        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.actOnSpecialNotification), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)

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
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @IBAction func showingMenu(_ sender: Any) {
//         radioManager?.startPlayingRadio()
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        activeField?.resignFirstResponder()
        activeField = nil
    }

    private func validateFields() {
        guard isValidUsername(scrollView.txtUserName.text!) else {
            scrollView.txtUserName.hasError = true
            self.usernameErrorLabel.isHidden = false
            setBackGroundColorToSubmitButton(color: RadioTheme.buttonDisabledColor, buttonInteraction: false)
            return
        }
        self.usernameErrorLabel.isHidden = true
        scrollView.txtUserName.hasError = false
        guard isPasswordValid(password: scrollView.txtPassword.text!) else {
            scrollView.txtPassword.hasError = true
            self.passwordErrorLabel.isHidden = false
            setBackGroundColorToSubmitButton(color: RadioTheme.buttonDisabledColor, buttonInteraction: false)
            return
        }
        self.passwordErrorLabel.isHidden = true
        scrollView.txtPassword.hasError = false
        setBackGroundColorToSubmitButton(color: RadioTheme.primaryBackgroundColor, buttonInteraction: true)
    }
    
    private func setBackGroundColorToSubmitButton(color:UIColor, buttonInteraction: Bool) {
        scrollView.signUpButton.isEnabled = buttonInteraction
        scrollView.signUpButton.backgroundColor = color
    }
    func isValid(enterStr: String) -> Bool {
        // check the name is between 7 and 15 characters
        if !(7...15 ~= enterStr.characters.count) {
            return false
        }
        return true
    }

    @IBAction func clickedSubmitButton(_ sender: UIButton) {
        
        guard let userName = scrollView.txtUserName.text, isValid(enterStr: userName) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid Username")
            return
        }
        guard let pwd = scrollView.txtUserName.text, isValid(enterStr: pwd) else {
            self.alertviewWithStatus(APiStatus: "Please enter valid Password")
            return
        }
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let info = [
            "username":scrollView.txtUserName.text!,
            "password":scrollView.txtPassword.text!]
        let detailsObj = UserDetails()
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+LOGIN, para: info , onCompletion: { (responseJson) in
            self.stopActivityIndicator()
            if responseJson != JSON.null
            {
                if responseJson["result"]["StatusCode"].intValue != 0 {
                    
                    self.message.text = "Login Successfully"
                    MDCSnackbarManager.show(self.message)
                    
                    detailsObj.user_Name = responseJson["userdetail"]["UserName"].stringValue
                    detailsObj.user_ID = Int16(responseJson["userdetail"]["UserId"].intValue)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set( detailsObj.user_ID, forKey: "USERID")
                    userDefaults.set( detailsObj.user_Name, forKey: "USERNAME")
                    //  self.performSegue(withIdentifier: "loginSuccessfulSegue", sender:nil)
                    self.UsersList.append(detailsObj)
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "dashboardVC") as! DashBoardViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                    VC.radioManager = self.radioManager
                }else {
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
    var id: String = "Login"
    
    func updateArstistName(name: String?) {
        let sprenatedArtistAndAlbum = name!.components(separatedBy: " - ")
        
        print( "\(sprenatedArtistAndAlbum[0])")
    }
    
    func updatePlayerStreaming(state: Bool) {
        print("dfsdfsdfsf")
    }

    // MARK: - API Calls
    private func loginUser(username:String, password:String) {
        APIClient.login(username: username, password:password) { result in
            print(result)
            switch result {
            case .success(let loginModel):
                print(loginModel)
                self.validateServerResponse(response: loginModel)
            case .failure(let error):
                print(error.localizedDescription)
                self.showErrorPopUpView(title: "Error!", message: error.localizedDescription.description)
            }
        }
    }
    
    private func validateServerResponse(response:LoginResponseModel){
        guard response.statusCode != 0 else {
            showErrorPopUpView(title: "Login Failed!", message: response.statusDescription!)
            return
        }
        self.performSegue(withIdentifier: "loginSuccessfulSegue", sender:nil)
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        validateFields()
        if textField.tag == 8001 {
            scrollView.txtPassword.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        // Retrieve the size and top margin (inset is the fancy word used by Apple)
        // of the keyboard displayed.
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var mainViewFrame: CGRect = self.view.frame
            mainViewFrame.size.height -= keyboardSize.height
            
            let signupButtonFrameInSuperView = self.view.convert(scrollView.signUpButton!.frame, from:scrollView)
            
            if(mainViewFrame.contains(signupButtonFrameInSuperView) == false){
                let heightForContent:CGFloat = CGFloat(scrollView.signUpButton.frame.origin.x + scrollView.signUpButton.frame.size.height + 40)
                let contentInsets: UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, heightForContent, 0.0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
            
            //you may not need to scroll, see if the active field is already visible
            if (mainViewFrame.contains(activeField!.frame.origin) == false) {
                let scrollPoint:CGPoint = CGPoint(x:0.0, y:activeField!.frame.origin.y - keyboardSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        validateFields()
    }
}

