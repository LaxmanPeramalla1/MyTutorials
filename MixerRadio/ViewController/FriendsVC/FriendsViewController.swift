//
//  FriendsViewController.swift
//  MixerRadio
//
//  Created by Laxman on 26/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import  SwiftyJSON
import Reachability
import MaterialComponents.MaterialSnackbar
class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, FindFriendsCellDelegate, MyFriendsCellDelegate, FriendRequestCellDelegate {
    
    let message = MDCSnackbarMessage()
    let reachability = Reachability()!
    @IBOutlet var find_frd_tableview: UITableView!
    @IBOutlet var find_frd_view: UIView!
    @IBOutlet var find_frd_searchbar: UISearchBar!
    
    @IBOutlet var myfrd_reqfrd_view: UIView!
    @IBOutlet var myfrd_frd_req_tableview: UITableView!
    @IBOutlet var myfrd_show_lbl: UILabel!
    @IBOutlet var find_frd_show_lbl: UILabel!
    @IBOutlet var frd_req_show_lbl: UILabel!
     var findFrndData: [FindFriendData] = [FindFriendData]()
     var myFrndData: [MyFriendData] = [MyFriendData]()
     var reqestFrndData: [RequestFriendsData] = [RequestFriendsData]()
    var btnSelectionTab = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myfrd_show_lbl.isHidden = false
        myfrd_reqfrd_view.isHidden = false
        find_frd_view.isHidden = true
        myfrd_show_lbl.isHidden = false
        find_frd_show_lbl.isHidden = true
        frd_req_show_lbl.isHidden = true
        //        getMyFriendsList()
        myfrd_frd_req_tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToDashboard(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
//        myfrd_show_lbl.isHidden = false
//        myfrd_reqfrd_view.isHidden = false
//        find_frd_view.isHidden = true
//        myfrd_show_lbl.isHidden = false
//        find_frd_show_lbl.isHidden = true
//        frd_req_show_lbl.isHidden = true
////        getMyFriendsList()
//       myfrd_frd_req_tableview.reloadData()
        // btnSelectionTab = "Tab1"
        
       //
    }

    @IBAction func friend_my_find_request_action(_ sender: UIButton) {
        if sender.tag == 1 {
            btnSelectionTab = "Tab1"
            myfrd_reqfrd_view.isHidden = false
            find_frd_view.isHidden = true
            
            myfrd_show_lbl.isHidden = false
            find_frd_show_lbl.isHidden = true
            frd_req_show_lbl.isHidden = true
            myfrd_frd_req_tableview.reloadData()
            
        }else if sender.tag == 2 {
             btnSelectionTab = "Tab2"
            myfrd_reqfrd_view.isHidden = true
            find_frd_view.isHidden = false
            
            myfrd_show_lbl.isHidden = true
            find_frd_show_lbl.isHidden = false
            frd_req_show_lbl.isHidden = true
             find_frd_tableview.reloadData()
           
        }else if sender.tag == 3 {
             btnSelectionTab = "Tab3"
            myfrd_reqfrd_view.isHidden = false
            find_frd_view.isHidden = true
            
            myfrd_show_lbl.isHidden = true
            find_frd_show_lbl.isHidden = true
            frd_req_show_lbl.isHidden = false
            myfrd_frd_req_tableview.reloadData()
        }
        
    }
    func getMyFriendsList() {
        let userDefaults = UserDefaults.standard
        //        let userName  = userDefaults.string(forKey: "USERNAME")
        let userID  = userDefaults.integer(forKey: "USERID")
        
        let URLstr = BASE_URL+GETMYFRIENDS+"\(userID)"
        _ = APIManager.sharedInstance.getApicall(url:URLstr,  onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                for findFriends in responseJson.array!
                {
                    let myfindFrndObj = MyFriendData()
                    myfindFrndObj.myFrnd_firstName = findFriends["FirstName"].stringValue
                    myfindFrndObj.myFrnd_lastName = findFriends["LastName"].stringValue
                    myfindFrndObj.myFrnd_address1_details = findFriends["Address1"].stringValue
                    myfindFrndObj.myFrnd_address2_details = findFriends["Address2"].stringValue
                    myfindFrndObj.myFrnd_user_ID = Int16(findFriends["FriendID"].intValue)
                    self.myFrndData.append(myfindFrndObj)
                }
            }
            self.myfrd_frd_req_tableview.reloadData()
        })
    }

    func getFindFriendList() {
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        
        let info = [
            "FirstName":find_frd_searchbar.text!,
            "LastName": "",
            "UserID":userID] as [String : Any]
      
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+FINDFRIENDS, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                for findFriends in responseJson.array!
                {
                    let findFrndObj = FindFriendData()
                     findFrndObj.findFrnd_firstName = findFriends["FirstName"].stringValue
                     findFrndObj.findFrnd_lastName = findFriends["LastName"].stringValue
                     findFrndObj.findFrnd_address1_details = findFriends["Address1"].stringValue
                     findFrndObj.findFrnd_address2_details = findFriends["Address2"].stringValue
                     findFrndObj.findFrnd_user_ID = Int16(findFriends["FriendID"].intValue)
                    self.findFrndData.append(findFrndObj)
                }
            }
            self.find_frd_tableview.reloadData()
        })
    }
    
    func getFriendRequestList() {
        let userDefaults = UserDefaults.standard
        //        let userName  = userDefaults.string(forKey: "USERNAME")
        let userID  = userDefaults.integer(forKey: "USERID")
        
        let URLstr = BASE_URL+GETFRIENDREQUESTLIST+"\(userID)"
        _ = APIManager.sharedInstance.getApicall(url:URLstr,  onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                for findFriends in responseJson.array!
                {
                    let requestFrndObj = RequestFriendsData()
                    requestFrndObj.requestFrnd_firstName = findFriends["FirstName"].stringValue
                    requestFrndObj.requestFrnd_lastName = findFriends["LastName"].stringValue
                    requestFrndObj.requestFrnd_address1_details = findFriends["Address1"].stringValue
                    requestFrndObj.requestFrnd_address2_details = findFriends["Address2"].stringValue
                    requestFrndObj.requestFrnd_user_ID = Int16(findFriends["FriendID"].intValue)
                    self.reqestFrndData.append(requestFrndObj)
                }
            }
            self.myfrd_frd_req_tableview.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        find_frd_searchbar.resignFirstResponder()
         getFindFriendList()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btnSelectionTab == "Tab1" || btnSelectionTab == "Tab3"{
            return 4
        }else if btnSelectionTab == "Tab2" {
            return findFrndData.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
        if btnSelectionTab == "Tab1" {
           let cell = self.myfrd_frd_req_tableview.dequeueReusableCell(withIdentifier: "myfrdcell", for: indexPath) as! MyFriendsCell
             return cell
        }else if btnSelectionTab == "Tab2" {
            
             let cell = self.find_frd_tableview.dequeueReusableCell(withIdentifier: "findfrdcell", for: indexPath) as! FindFriendsCell
            var findFrndObj = FindFriendData()
            findFrndObj = findFrndData[indexPath.row]
            cell.find_friend_name.text = findFrndObj.findFrnd_firstName! + findFrndObj.findFrnd_lastName!
            cell.find_friend_details.text = findFrndObj.findFrnd_address1_details! + findFrndObj.findFrnd_address2_details!
            cell.delegate = self
            return cell
        }else{
            let cell = self.myfrd_frd_req_tableview.dequeueReusableCell(withIdentifier: "frdrequestcell", for: indexPath) as! FriendRequestCell
            return cell
        }
    }
    
    
    //  Find Friend Functionality ....
    func addFriendRequestAction(selectedIndex: Int16){
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "FriendID":selectedIndex,
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+SENDFRIENDREQUEST, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.message.text = " Successfully Added Friend"
                MDCSnackbarManager.show(self.message)
            }
            self.find_frd_tableview.reloadData()
        })
    }
    func addFriendRequest(_ sender: FindFriendsCell) {
        guard let tappedIndexPath = find_frd_tableview.indexPath(for: sender) else { return }
        print("Trash", sender, tappedIndexPath)
        var findFrndObj = FindFriendData()
        findFrndObj = findFrndData[tappedIndexPath.row]
        addFriendRequestAction(selectedIndex: findFrndObj.findFrnd_user_ID!)
        // Delete the row
//        items.remove(at: tappedIndexPath.row)
//        tableView.deleteRows(at: [tappedIndexPath], with: .automatic)
    }
    
    
    // My Friend functionality...
    
    func deleteMyFriendRequestAction(selectedIndex: Int16){
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "FriendID":selectedIndex,
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+SENDFRIENDREQUEST, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.message.text = " Successfully My Friend Deleted"
                MDCSnackbarManager.show(self.message)
            }
            self.myfrd_frd_req_tableview.reloadData()
        })
    }
    func myFriendDeleteRequest(_ sender: MyFriendsCell) {
        guard let tappedIndexPath = myfrd_frd_req_tableview.indexPath(for: sender) else { return }
        print("Trash", sender, tappedIndexPath)
        var myFrndObj = MyFriendData()
        myFrndObj = myFrndData[tappedIndexPath.row]
        deleteMyFriendRequestAction(selectedIndex: myFrndObj.myFrnd_user_ID!)
    }
    
    
    // Request friend ....
    
    func acceptFriendRequestAction(selectedIndex: Int16){
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "FriendID":selectedIndex,
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+ACCEPTFRIENDREQUEST, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.message.text = " Successfully Accepted Friend Request"
                MDCSnackbarManager.show(self.message)
            }
            self.myfrd_frd_req_tableview.reloadData()
        })
    }
    func denyFriendRequestAction(selectedIndex: Int16){
        if !reachability.isReachable {
            self.message.text = CONNECTIONERROR
            MDCSnackbarManager.show(self.message)
            return
        }
        let userDefaults = UserDefaults.standard
        let userID  = userDefaults.integer(forKey: "USERID")
        print(userID)
        let info = [
            "FriendID":selectedIndex,
            "UserID":userID] as [String : Any]
        
        _ = APIManager.sharedInstance.postApicall(url: BASE_URL+ACCEPTFRIENDREQUEST, para: info , onCompletion: { (responseJson) in
            if responseJson != JSON.null
            {
                self.message.text = " Successfully Deny Friend Request"
                MDCSnackbarManager.show(self.message)
            }
            self.myfrd_frd_req_tableview.reloadData()
        })
    }
    
    func acceptFriendRequest(_ sender: FriendRequestCell) {
        guard let tappedIndexPath = find_frd_tableview.indexPath(for: sender) else { return }
        print("Trash", sender, tappedIndexPath)
        var requestFrndObj = RequestFriendsData()
        requestFrndObj = reqestFrndData[tappedIndexPath.row]
        acceptFriendRequestAction(selectedIndex: requestFrndObj.requestFrnd_user_ID!)
    }
    
    func denyFriendRequest(_ sender: FriendRequestCell) {
        guard let tappedIndexPath = find_frd_tableview.indexPath(for: sender) else { return }
        print("Trash", sender, tappedIndexPath)
        var requestFrndObj = RequestFriendsData()
        requestFrndObj = reqestFrndData[tappedIndexPath.row]
        denyFriendRequestAction(selectedIndex: requestFrndObj.requestFrnd_user_ID!)
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
