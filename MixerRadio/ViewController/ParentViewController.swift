//
//  ParentViewController.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 18/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SwiftMessages

class ParentViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarCustomView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:60))
        statusBarCustomView.backgroundColor = RadioTheme.primaryBackgroundColor;
        self.view.addSubview(statusBarCustomView)
        self.view.sendSubview(toBack: statusBarCustomView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorPopUpView(title:String, message:String) {
        setUpAlertView(title:title , message:message, buttonTitle:"Ok")
    }
    
    func setUpAlertView(title:String, message:String, buttonTitle:String) {
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .center
        
        // Display in a window at the specified window level: UIWindowLevelStatusBar
        // displays over the status bar while UIWindowLevelNormal displays under.
        config.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        
        // Disable the default auto-hiding behavior.
        config.duration = .forever
        
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = true
        
        // Specify one or more event listeners to respond to show and hide events.
//        config.eventListeners.append() { event in
//            if case .didHide = event { print("yep") }
//        }
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: buttonTitle) { _ in
            SwiftMessages.hide()
        }
        SwiftMessages.show(config: config, view: view)
    }
    
//    func  testApi() {
//        APIClient.testApi { result in
//            switch result {
//            case .success(let TestFileApi):
//                print(TestFileApi)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    let urlString = "http://192.168.21.49/mixerradio/api/ApiAccount/Login"
//    Alamofire.request(urlString, method: .post, parameters: ["foo": "bar"],encoding: JSONEncoding.default, headers: nil).responseJSON {
//    response in
//    switch response.result {
//    case .success:
//    print(response)
//    break
//    case .failure(let error):
//    print(error)
//    }
//    }
}


