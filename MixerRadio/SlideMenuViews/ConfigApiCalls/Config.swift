
//

import Foundation
//Online Payment check Url

//UAT CHOICE URL
var BASE_URL                                = "http://192.168.21.49/mixerradio/api/"

//var BASE_URL                                = "http://wjjo.mixerradio.com/api/"



// Login
var LOGIN                               = "Account/Login"

// Forgot password
var FORGOTPWDVALIDATEUSERNAME           = "Account/ValidateUser?userName="
var FORGOTPWDVALIDATESECURITYQUESTION   = "Account/ValidateSecurityQuestion"
var FORGOTPWDOTPVALIDATE                = "Account/MobileVerificationToGetOTPByUserName"
var FORGOTPWDGETSECURITYQUESTIONS       = "Account/GetSecurityQuestions"
var FORGOTPWDVARIFYWITHOTP              = "Account/VerifyForForgotPasswordWithOTP"
var CREATENEWPWD                        = "Account/CreateNewPassword"

var RESETPWD                            = "Account/ResetPassword"


//   Profile
var GETUSERPROFILE                      = "Account/GetUserProfile?UserID="
var UPDATEUSERPROFILE                   = "Account/UpdateUserProfile"
var UPLOADAUDIOCLIP                     = "Account/UploadAudioClip"

// Friends
var GETMYFRIENDS                        = "Friend/GetMyFriends?UserID="
var FINDFRIENDS                         = "Friend/FindFriends"
var GETFRIENDREQUESTLIST                = "Friend/FriendRequestList?UserID="

var SENDFRIENDREQUEST                   = "Friend/SendFriendRequest"
var ACCEPTFRIENDREQUEST                 = "Friend/AcceptFriendRequest"
var DENYFRIENDREQUEST                   = "Friend/DenyFriendRequest"

//


//

var MEDIA                               = "Media/UploadAudioClip"


var CONNECTIONERROR                     = "No internet connection available.  Please check and try again."
var mySpecialNotificationKey = "com.MightyLoud.MightyLoudMixerRadio"



// API Call Method Names

