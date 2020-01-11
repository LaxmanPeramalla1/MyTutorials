//
//  DashBoardViewController.swift
//  MixerRadio
//
//  Created by Laxman on 21/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import AVFoundation
class DashBoardViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, FSPagerViewDataSource,FSPagerViewDelegate, RadioStreamingObserver {

    var dashBoardImgsArray: [String] = []
    var dashBoardNamessArray: [String] = []
     var bannerImagesUrls:[String] = []
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var vwRadioStreaming: RadioStreamingView!
    @IBOutlet weak var autoLayoutRadioStreamHeight: NSLayoutConstraint!
    @IBOutlet weak var autoLayoutLeadingConstBtnArrow: NSLayoutConstraint!
    
    @IBOutlet var menuBarBtn: UIButton!
    // MARK: - Properties
    var radioViewActualHeight:CGFloat!
    var arrowButtonActualHeight:CGFloat!
    var radioManager:RadioAudioManager?
    fileprivate var radioPlayer:AVPlayer!
    var preview = PreLoginViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwRadioStreaming.labelArtistName1.text! = UserDefaults.standard.string(forKey: "SONG")!
       
        dashBoardNamessArray = ["Rate Song","Auction","Survey","Earn Points","Sound Off","Upload"]
        dashBoardImgsArray = ["unselect_rate_songs_icon","unselect_auction","survy_img","earn_points_icon","unselected_soundoff","unselected_upload_icon"]
         getBannerImages()
        
//        let defaults = UserDefaults.standard
//        if let name = defaults.object(forKey: "RADIO") {
//            radioManager = (name as! RadioAudioManager)
//             radioManager?.stopPlayingRadio()
//            print(name)
//        }
     
      //   getRadioStreamingURL()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(DashBoardViewController.actOnSpecialNotification), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
       
    }
    @objc func actOnSpecialNotification() {
        
        print("showing notification method")
        self.vwRadioStreaming.labelArtistName1.text! = UserDefaults.standard.string(forKey: "SONG")!
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // radioManager?.removeObserver(observer: self)
    }
    @IBAction func showingMenu(_ sender: Any) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashBoardImgsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! DashBoardCell
       // myCell.backgroundColor = UIColor.blue
//        myCell.numbersLbl.text = String(indexPath.row)
        myCell.dashboard_Img.image = UIImage(named: dashBoardImgsArray[indexPath.row])
        myCell.dashboard_names_lbl.text = dashBoardNamessArray[indexPath.row]
        return myCell
    }
    
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
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
    // MARK:- FSPagerViewDelegate
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
         vwRadioStreaming.viewOverlay1.isHidden = true
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
             vwRadioStreaming.radioStreamingState = .isPlaying
            self.vwRadioStreaming.buttonPlayOrPause.setImage(UIImage(named: "pause-icon"), for: .normal)
        default:
            print("default method called")
        }
    }
    
    private func openOrCloseRadioView(){
        vwRadioStreaming.labelArtistNameWhenRadioHidden1.alpha = 0
        switch vwRadioStreaming.radioViewState1 {
        case .isOpen:
            vwRadioStreaming.radioViewState1 = .isHidden
            animateRadioViewBasedOnHeightConstant(radioViewHeight: vwRadioStreaming.radioViewHeightWhenMinimized1, btnLeadingSpace:self.view.frame.size.width, animateImageAngle: Double.pi, hidePlayingView: false)
        //            vwRadioStreaming.labelArtistNameWhenRadioHidden.isHidden = false
        case .isHidden:
            vwRadioStreaming.radioViewState1 = .isOpen
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
        self.view.isUserInteractionEnabled = true
        self.autoLayoutRadioStreamHeight.constant = radioViewHeight
        self.autoLayoutLeadingConstBtnArrow.constant = btnLeadingSpace
        self.vwRadioStreaming.needsUpdateConstraints()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.vwRadioStreaming.arrowImage1.transform = CGAffineTransform(rotationAngle: CGFloat(animateImageAngle))
            if hidePlayingView {
                self?.vwRadioStreaming.labelArtistNameWhenRadioHidden1.alpha = 0
                self?.vwRadioStreaming.viewPlaying1.alpha = 1;
            }else{
                self?.vwRadioStreaming.viewPlaying1.alpha = 0;
                self?.vwRadioStreaming.labelArtistNameWhenRadioHidden1.alpha = 1
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
        self.vwRadioStreaming.labelArtistName1.text = "\(sprenatedArtistAndAlbum[0])"
        self.vwRadioStreaming.labelAlbumName1.text = "\(sprenatedArtistAndAlbum[1])"
        self.vwRadioStreaming.labelArtistNameWhenRadioHidden1.text = name!
    }
    
    func updatePlayerStreaming(state:Bool) -> Void {
        vwRadioStreaming.viewOverlay1.isHidden = state
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
