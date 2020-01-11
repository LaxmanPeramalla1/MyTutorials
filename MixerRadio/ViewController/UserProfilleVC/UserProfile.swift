//
//  ViewController.swift
//  Sample
//
//  Created by Laxman Peramalla on 19/05/18.
//  Copyright © 2018 NidhiSiri. All rights reserved.
//

import UIKit
import GooglePlacePicker
import Reachability
import MaterialComponents.MaterialSnackbar
import ALCameraViewController
import SwiftyJSON
class UserProfile: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateOfbirthTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var altermobileTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var gendarTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
     @IBOutlet weak var cuntryTxt: UITextField!
    @IBOutlet weak var zipcodeTxt: UITextField!
    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var favorateArtistTxt: UITextField!
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet var edit_update_btn: UIButton!
    var pickerData: [String] = [String]()
     var datePicker : UIDatePicker!
      var dateTimer = Timer()
    var myPickerView: UIPickerView!
      let reachability = Reachability()!
     let message = MDCSnackbarMessage()
    var gendar: Int!
    var selectedArressStr = NSString()
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = false
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var editProfileStatus: Bool = true
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         pickerData = ["Male", "Female"]
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: backView.frame.size.height+75)
        
        get_User_profileDetails()
//        searchplace()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selectedArressStr != "GoogleSDKSELECTED" {
            userProfileFieldsStatus(profileStatus: false)
           
        }
    }
    func userProfileFieldsStatus(profileStatus: Bool) {
        self.userNameTxt.isUserInteractionEnabled = false
        self.firstNameTxt.isUserInteractionEnabled = profileStatus
        self.lastNameTxt.isUserInteractionEnabled = profileStatus
        self.emailTxt.isUserInteractionEnabled = profileStatus
        self.favorateArtistTxt.isUserInteractionEnabled = profileStatus
        self.gendarTxt.isUserInteractionEnabled = profileStatus
        self.dateOfbirthTxt.isUserInteractionEnabled = profileStatus
        self.mobileTxt.isUserInteractionEnabled = false
        self.altermobileTxt.isUserInteractionEnabled = profileStatus
        self.cuntryTxt.isUserInteractionEnabled = profileStatus
        self.address2Txt.isUserInteractionEnabled = profileStatus
        self.address1Txt.isUserInteractionEnabled = profileStatus
        self.stateTxt.isUserInteractionEnabled = profileStatus
        self.cityTxt.isUserInteractionEnabled = profileStatus
        self.zipcodeTxt.isUserInteractionEnabled = profileStatus
    }
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
//            var fram = self.registerBtnView.frame
//            fram.origin.y = registerBackfram.origin.y
            //self.registerBtnView.frame = fram
            
        } else {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height+100, right: 0)
//            var fram = self.registerBtnView.frame
//            fram.origin.y = registerBackfram.origin.y-keyboardViewEndFrame.height
            //self.registerBtnView.frame = fram
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        //let selectedRange = scrollView.selectedRange
        //yourTextView.scrollRangeToVisible(selectedRange)
    }
    
    func get_User_profileDetails() {
        let userDefaults = UserDefaults.standard
//        let userName  = userDefaults.string(forKey: "USERNAME")
        let userID  = userDefaults.integer(forKey: "USERID")
        
        let URLstr = BASE_URL+GETUSERPROFILE+"\(userID)"
        _ = APIManager.sharedInstance.getApicall(url:URLstr,  onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.userNameTxt.text = responseJson["userdetail"]["UserName"].stringValue
                self.emailTxt.text = responseJson["userdetail"]["email"].stringValue
               self.dateOfbirthTxt.text = responseJson["userdetail"]["Birthdate"].stringValue
               self.lastNameTxt.text = responseJson["userdetail"]["LastName"].stringValue
                self.stateTxt.text = responseJson["userdetail"]["StateName"].stringValue
                self.zipcodeTxt.text = responseJson["userdetail"]["PostalCode"].stringValue
                self.address1Txt.text = responseJson["userdetail"]["Address1"].stringValue
                self.stateTxt.text = responseJson["userdetail"]["StateID"].stringValue
                self.address2Txt.text = responseJson["userdetail"]["Address2"].stringValue
                self.firstNameTxt.text = responseJson["userdetail"]["FirstName"].stringValue
                self.favorateArtistTxt.text = responseJson["userdetail"]["FavoriteArtistID"].stringValue
                self.cityTxt.text = responseJson["userdetail"]["City"].stringValue
                if responseJson["userdetail"]["GenderID"].stringValue == "1" {
                    self.gendarTxt.text = "Male"
                }else {
                    self.gendarTxt.text = "Female"
                }
               // self.gendarTxt.text = responseJson["userdetail"]["GenderID"].stringValue
                self.altermobileTxt.text = responseJson["userdetail"]["CellNumber"].stringValue
                 self.cuntryTxt.text = responseJson["userdetail"]["CountryName"].stringValue
                self.mobileTxt.text = responseJson["userdetail"]["MobileNumber"].stringValue
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
    func update_User_profileDetails() {
        if validatePhone(value: altermobileTxt.text!) {
            self.message.text = "Enter  Valid Mobile No."
            MDCSnackbarManager.show(self.message)
            return
        }
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        showActivityIndicator()
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
      //  let userName  = userDefaults.string(forKey: "USERNAME")
        let info = [
            "UserID":userID,
            "FirstName":firstNameTxt.text!,
            "LastName":lastNameTxt.text!,
            "UserName":userNameTxt.text!,
            "email":emailTxt.text!,
            "Name":favorateArtistTxt.text!,
            "GenderID":1,
            "Birthdate":dateOfbirthTxt.text!,
            "MobileNumber":mobileTxt.text!,
            "CellNumber":altermobileTxt.text!,
            "Address1":address1Txt.text!,
            "Address2":address2Txt.text!,
            "City":cityTxt.text!,
            "StateID":3,
            "PostalCode":508374,
            "CountryID":302,] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+UPDATEUSERPROFILE, para: info , onCompletion: { (responseJson) in
            //SVProgressHUD.dismiss()
             self.stopActivityIndicator()
            if responseJson != JSON.null
            {
               self.navigationController?.popViewController(animated: true)
            }
        })
    }
    @IBAction func backToDashBoardScreen(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resetPwd_action(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "resetpwdVC") as! ConformNewPwdViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func reset_PwdAndUpdate_Profile_Action(_ sender: UIButton) {
        if sender.tag == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "resetpwdVC") as! ConformNewPwdViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }else {
            update_User_profileDetails()
        }
        
    }
    
    @IBAction func editUserProfile(_ sender: Any) {
        
        if (editProfileStatus == true)
        {
             edit_update_btn.setImage(UIImage(named:"save_icon"), for: .normal)
            userProfileFieldsStatus(profileStatus: true)
            editProfileStatus = false;
        }
        else
        {
             update_User_profileDetails()
            editProfileStatus = true;
        }
        
        
    }
   
    @IBAction func uploadImage(sender: UIButton)
    {
        openCemara()
        
    }
    func openCemara()  {
        
        
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
//        let croppingEnabled = true
        
        
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
           
            if image != nil
            {
                self?.headerImageView.image = image
                let jpegCompressionQuality: CGFloat = 0.6
                let strbase64 : String = (UIImageJPEGRepresentation(image!, jpegCompressionQuality)?.base64EncodedString())!
                
//                let WholeBase64 = "data:image/png;base64,\(strbase64)"
                let  info = [
                    "fileName": ".png",
                    "containerName": "name",
                    "UserID": userID,
                    "RecordUrl": strbase64
                    ] as [String : Any]

                _ = APIManager.sharedInstance.postApicall(url: BASE_URL+MEDIA, para: info , onCompletion: { (responseJson) in
                    if responseJson != JSON.null
                    {
                        
                    }
                })
            }
            
            
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == dateOfbirthTxt {
            dateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(UserProfile.adddatePicker)), userInfo: nil, repeats: false)
        }
        else if textField == gendarTxt {
            pickUp(gendarTxt)
        }
        else if textField == address1Txt {
            selectedArressStr = "AutoFill"
            searchplace()
        }else if textField == address2Txt {
            selectedArressStr = "NoAutoFill"
            searchplace()
        }
        //}
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mobileTxt || textField == emailTxt || textField == userNameTxt {
            
        }
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet.letters
        if textField == self.firstNameTxt || textField == self.lastNameTxt{
            //            if  string.rangeOfCharacter(from: characterSet.inverted) != nil {
            //                return false
            //            }
            //           else {
            //            return true
            //           }
            let ACCEPTABLE_CHARECTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARECTERS).inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
            
        }
     
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func validatePhone(value: String) -> Bool {
        if value.count == 10 {
            return false;
        }
        else
        {
            return true;
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
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.gendarTxt.text = pickerData[row]
        if self.gendarTxt.text == "Male" {
            gendar = 1
        }else {
            gendar = 2
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
        

        //frmTxtFld.text = dateFormatter1.string(from: datePicker.date)
       
            self.pickUp(gendarTxt)
        
        gendarTxt.resignFirstResponder()
    }
    @objc func cancelClick() {
        gendarTxt.text = ""
 
        gendarTxt.resignFirstResponder()
    }
    @objc func adddatePicker()  {
//        dateTimer.invalidate()
        dateOfbirthTxt.resignFirstResponder()
        DatePickerDialog().showWithMax("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            self.dateOfbirthTxt.resignFirstResponder()
            if date != nil
            {
                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd-MM-yyyy"
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateStr = dateFormatter.string(from: date!)
                self.dateOfbirthTxt.text = dateStr
                let calendar = Calendar.current
                let now = Date()
                let ageComponents = calendar.dateComponents([.year], from: date!, to: now)
//                self.ageTxt.text=String(ageComponents.year!)
            }
            
        }
        
        
    }
    func dateOfBirthValidate(selecteddate: String) ->Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fromDatedate = dateFormatter.date(from: selecteddate)
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: fromDatedate!, to: now)
//        age = ageComponents.year!
//        if age<18 {
//            return true;
//        }
//        else
//        {
//            self.ageTxt.text=String(age)
//            return false;
//        }
        return false;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToDashBoard(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "dashboardVC") as! DashBoardViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func searchplace()  {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
}
extension UserProfile : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
//        selectedlatitude = place.coordinate.latitude
//        selectedlongitude = place.coordinate.longitude
//        selectedWholeAddress = place.formattedAddress!
        if selectedArressStr == "AutoFill"{
            self.address1Txt.text =  place.formattedAddress!
            for add in place.addressComponents! {
                if add.type == "locality"
                {
                    self.cityTxt.text = add.name
                }
                if add.type == "country"
                {
                    self.cuntryTxt.text = add.name
                }
                if add.type == "postal_code"
                {
                    self.zipcodeTxt.text = add.name
                }
                if add.type == "address"
                {
                    
                    
                }
                if add.type == "state"
                {
                    
                    self.stateTxt.text = add.name
                }
            }
        }else{
            self.address2Txt.text =  place.formattedAddress!
        }
         selectedArressStr = "GoogleSDKSELECTED"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
}
}

