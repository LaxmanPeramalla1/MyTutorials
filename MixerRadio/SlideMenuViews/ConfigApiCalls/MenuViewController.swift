//
//  MenuViewController.swift
//  MixerRadio
//
//  Created by Laxman on 31/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    @IBOutlet var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        profileImg.layer.borderWidth = 2
        profileImg.layer.borderColor = UIColor.green.cgColor
        profileImg.layer.cornerRadius = 20
        
        profileImg.layer.masksToBounds = false
        profileImg.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func updateArrayMenuOptions(){
        //        ManuNameArray = ["Profile","Rate Song","Contact","Interact","Friends","Points","Events","Surveys","Auctions","Share","Notifications","Sign Out"]
        //        iconArray = [UIImage(named:"sm_profile_icon")!,UIImage(named:"sm_rate_song_icon")!,UIImage(named:"sm_contact_icon")!,UIImage(named:"sm_interact_icon")!,UIImage(named:"sm_friends_icon")!,UIImage(named:"sm_points_icon")!,UIImage(named:"sm_events_icon")!,UIImage(named:"sm_survey_icon")!,UIImage(named:"sm_auctions_icon")!,UIImage(named:"sm_share_icon")!,UIImage(named:"sm_notification_icon")!,UIImage(named:"sm_signout_icon")!]
        arrayMenuOptions.append(["title":"Profile", "icon":"sm_profile_icon"])
        arrayMenuOptions.append(["title":"Rate Song", "icon":"sm_rate_song_icon"])
        arrayMenuOptions.append(["title":"Contact", "icon":"sm_contact_icon"])
        arrayMenuOptions.append(["title":"Interact", "icon":"sm_interact_icon"])
        arrayMenuOptions.append(["title":"Friends", "icon":"sm_friends_icon"])
        arrayMenuOptions.append(["title":"Points", "icon":"sm_points_icon"])
        arrayMenuOptions.append(["title":"Events", "icon":"sm_events_icon"])
        arrayMenuOptions.append(["title":"Surveys", "icon":"sm_survey_icon"])
        arrayMenuOptions.append(["title":"Auctions", "icon":"sm_auctions_icon"])
        arrayMenuOptions.append(["title":"Share", "icon":"sm_share_icon"])
        arrayMenuOptions.append(["title":"Notifications", "icon":"sm_notification_icon"])
        arrayMenuOptions.append(["title":"Sign Out", "icon":"sm_signout_icon"])
        
        
        tblMenuOptions.reloadData()
    }
    @IBAction func loginOrRegisterNewUser(_ sender: Any) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = 100
        self.onCloseMenuClick(btn)
        // self.onCloseMenuClick(sender as! UIButton)
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        if indexPath.row == 3 && indexPath.row == 4{
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        //
        //        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        //        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
