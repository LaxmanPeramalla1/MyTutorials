//
//  FieldValidations.swift
//  MixerRadio
//
//  Created by Archana Kaveti on 4/20/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation

func isValidUsername(_ username : String) -> Bool{
    let regex =  "[A-Z0-9a-z]{2,}"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
    return passwordTest.evaluate(with: username)
}


// validate Email/Username
func isValidEmail(email:String?) -> Bool {
    
    guard email != nil else { return false }
    
   // let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
    return pred.evaluate(with: email)
}

// validate password

func isPasswordValid(password:String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}

//Validate Phone Number
func validate(value: String) -> Bool {
    let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

//Validate Zipcode
func isValidPincode(value: String) -> Bool {
    if value.count == 6 {
        return true
    }
    else{
        return false
    }
}

// Validate current password and confirm password
func isPasswordSame(password: String , confirmPassword : String) -> Bool {
    if password == confirmPassword{
        return true
    }else{
        return false
    }
}

