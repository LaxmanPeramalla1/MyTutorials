//
//  PointsViewController.swift
//  MixerRadio
//
//  Created by Laxman on 28/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var points_historyView: UIView!
    @IBOutlet var points_accruedView: UIView!
    @IBOutlet var accrued_history_points_tableview: UITableView!
    @IBOutlet var accrued_showLbl: UILabel!
    @IBOutlet var history_showLbl: UILabel!
    var btnSelectionTab = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()

        points_historyView.isHidden = true
        points_accruedView.isHidden = false
        
        accrued_showLbl.isHidden = false
        history_showLbl.isHidden = true
        
        btnSelectionTab = "Tab1"
        accrued_history_points_tableview.reloadData()
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = .red
        self.view.addSubview(view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// all this related to point
    @IBOutlet var backTopreviousView: UIButton!
    @IBAction func backTopriviousScreen(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func headerView_btn_actions(_ sender: UIButton) {
        if sender.tag == 1 {
            // back button action
            
        }else if sender.tag == 2 {
            // Accured Points Action
            btnSelectionTab = "Tab1"
            points_historyView.isHidden = true
            points_accruedView.isHidden = false
            
            accrued_showLbl.isHidden = false
            history_showLbl.isHidden = true
            
        }else {
            // Points History
            btnSelectionTab = "Tab2"
            points_historyView.isHidden = false
            points_accruedView.isHidden = true
            
            accrued_showLbl.isHidden = true
            history_showLbl.isHidden = false
        }
        accrued_history_points_tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btnSelectionTab == "Tab1" {
            return 4
        }
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if btnSelectionTab == "Tab1" {
            cell = tableView.dequeueReusableCell(withIdentifier: "accruedcell", for: indexPath) as! AccruedPointsCell
        }else if btnSelectionTab == "Tab2" {
            cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryPointsCell
        }
        return cell
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
