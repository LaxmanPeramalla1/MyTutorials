
//
//  PreLoginViewController.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 17/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import SDWebImage

class PreLoginViewController: ParentViewController,FSPagerViewDataSource,FSPagerViewDelegate, RadioStreamingObserver {
    // MARK: - IBOutlet
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.hidesForSinglePage = true
        }
    }
    @IBOutlet var menuBarBtn: UIButton!
    @IBOutlet weak var vwRadioStreaming: RadioStreamingView!
    @IBOutlet weak var autoLayoutRadioStreamHeight: NSLayoutConstraint!
    @IBOutlet weak var autoLayoutLeadingConstBtnArrow: NSLayoutConstraint!
    @IBOutlet var albumNameLbl: UILabel!
    // MARK: - Properties
    var radioViewActualHeight:CGFloat!
    var arrowButtonActualHeight:CGFloat!
    var radioManager:RadioAudioManager?
    var bannerImagesUrls:[String] = []
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBannerImages()
        getRadioStreamingURL()
    }
    
    @IBAction func showingMenu(_ sender: Any) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //Caputuring Height for radio streaming view when loaded first.
        radioViewActualHeight = autoLayoutRadioStreamHeight.constant
        arrowButtonActualHeight = autoLayoutLeadingConstBtnArrow.constant
    }
    
    @IBAction func login(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        self.navigationController?.pushViewController(VC, animated: true)
        VC.radioManager = radioManager
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        albumNameLbl.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let defaults = UserDefaults.standard
//        defaults.set(radioManager, forKey: "RADIO")
       radioManager?.removeObserver(observer: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark: - Radio Streaming
    func initializeRadioMangaer(radioStreamingUrl:String) -> Void {
        //Loading url
        radioManager = RadioAudioManager.init(urlRadioStation: radioStreamingUrl)
        //Starting playing radio
        radioManager?.initialiazeObserverForManager()
        radioManager?.startPlayingRadio()
        radioManager?.attachObserver(observer: self)
    }
    
    // MARK: - FSPagerView Datasource
    /* Slider View for banner Images */
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerImagesUrls.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: URL(string: self.bannerImagesUrls[index]), placeholderImage: UIImage(named: "logo-grey"))
        return cell
    }
    
    // MARK:- FSPagerViewDelegate
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    // MARK: - IBActions
    /* MinimizeOrMaximizeRadioView */
    @IBAction func actionMinimizeOrMaximizeRadioView(_ sender: UIButton) {
        openOrCloseRadioView()
    }
    
    @IBAction func actionPlayorPauseRadioStreaming(_ sender: UIButton) {
        switch vwRadioStreaming.radioStreamingState {
        case .isPlaying:
            radioManager?.stopPlayingRadio()
            self.vwRadioStreaming.radioStreamingState = .isOnPause
            self.vwRadioStreaming.buttonPlayOrPause.setImage(UIImage(named: "Play-icon"), for: .normal)
        case .isOnPause:
            radioManager?.startPlayingRadio()
            vwRadioStreaming.radioStreamingState = .isPlaying
            self.vwRadioStreaming.buttonPlayOrPause.setImage(UIImage(named: "pause-icon"), for: .normal)
        default:
            print("default method called")
        }
    }
    
    private func openOrCloseRadioView(){
        vwRadioStreaming.labelArtistNameWhenRadioHidden.alpha = 0
        switch vwRadioStreaming.radioViewState {
        case .isOpen:
            albumNameLbl.isHidden = false
            vwRadioStreaming.radioViewState = .isHidden
            animateRadioViewBasedOnHeightConstant(radioViewHeight: vwRadioStreaming.radioViewHeightWhenMinimized, btnLeadingSpace:self.view.frame.size.width, animateImageAngle: Double.pi, hidePlayingView: false)
//            vwRadioStreaming.labelArtistNameWhenRadioHidden.isHidden = false
        case .isHidden:
            albumNameLbl.isHidden = true
            vwRadioStreaming.radioViewState = .isOpen
            animateRadioViewBasedOnHeightConstant(radioViewHeight: radioViewActualHeight, btnLeadingSpace: arrowButtonActualHeight, animateImageAngle: 180 * Double.pi, hidePlayingView: true)
//            vwRadioStreaming.labelArtistNameWhenRadioHidden.isHidden = true
        default:
            print("default method called")
        }
    }
    
    /* Animating radio view
     we are reducing the size of the radio view on hide and unhiding on tapping on it.
     */
    private func animateRadioViewBasedOnHeightConstant(radioViewHeight: CGFloat, btnLeadingSpace:CGFloat, animateImageAngle:Double, hidePlayingView: Bool){
        self.view.isUserInteractionEnabled = false
        self.autoLayoutRadioStreamHeight.constant = radioViewHeight
        self.autoLayoutLeadingConstBtnArrow.constant = btnLeadingSpace
        self.vwRadioStreaming.needsUpdateConstraints()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.vwRadioStreaming.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(animateImageAngle))
            if hidePlayingView {
                self?.vwRadioStreaming.labelArtistNameWhenRadioHidden.alpha = 0
                self?.vwRadioStreaming.viewPlaying.alpha = 1;
            }else{
                self?.vwRadioStreaming.viewPlaying.alpha = 0;
                self?.vwRadioStreaming.labelArtistNameWhenRadioHidden.alpha = 1
            }
            self?.view.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    /* Lisitner call back function */
    var id:String = "PreLogin"
    func updateArstistName(name: String?) {
        let sprenatedArtistAndAlbum = name!.components(separatedBy: " - ")
        self.vwRadioStreaming.labelArtistName.text = "\(sprenatedArtistAndAlbum[0])"
        self.vwRadioStreaming.labelAlbumName.text = "\(sprenatedArtistAndAlbum[1])"
        self.vwRadioStreaming.labelArtistNameWhenRadioHidden.text = name!
        albumNameLbl.text = "\(sprenatedArtistAndAlbum[0])"
//        mySpecialNotificationKey = "\(sprenatedArtistAndAlbum[0])"
        let defaults = UserDefaults.standard
        defaults.set("\(sprenatedArtistAndAlbum[0])", forKey: "SONG")
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialNotificationKey), object: self)

       

    }
    
    func updatePlayerStreaming(state:Bool) -> Void {
        vwRadioStreaming.viewOverlay.isHidden = state
    }
    
    // MARK: - API Calls
    private func getBannerImages() {
        APIClient.getBannerImages{ result in
            switch result {
            case .success(let BannerImagesResponseModel):
                print(BannerImagesResponseModel)
                for imageUrl in BannerImagesResponseModel.data { 
                    self.bannerImagesUrls.append(imageUrl)
                }
                self.pageControl.numberOfPages = BannerImagesResponseModel.data.count
                self.pagerView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getRadioStreamingURL() {
        APIClient.getRadioStreamingUrl { result in
            switch result {
            case .success(let RadioStreamingUrlResponseModel):
                print(RadioStreamingUrlResponseModel)
                let trimmedString = RadioStreamingUrlResponseModel.url!.trimmingCharacters(in: .whitespacesAndNewlines)
                self.initializeRadioMangaer(radioStreamingUrl: trimmedString)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
