//
//  CurrentAuctionsViewController.swift
//  MixerRadio
//
//  Created by Laxman on 13/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class CurrentAuctionsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            cell = tableView.dequeueReusableCell(withIdentifier: "currentcell", for: indexPath) as! CurrentAuctionsCell
        return cell
    }
    @IBAction func backToPreviousView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

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
