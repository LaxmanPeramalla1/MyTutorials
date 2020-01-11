//
//  RadioAudioManager.swift
//  MixerRadioiOSApp
//
//  Created by Pavan Kothur on 10/04/18.
//  Copyright © 2018 Pavan Kothur. All rights reserved.
//

import UIKit
import AVFoundation

class RadioAudioManager: NSObject {
    // MARK: - Properties
    fileprivate var radioPlayer:AVPlayer!
    var urlRadioStation:String
    private var observerArray = [RadioStreamingObserver]()
    
    //MARK:- Init
    init(urlRadioStation:String!) {
        self.urlRadioStation = urlRadioStation
        let url = URL(string:self.urlRadioStation)
        radioPlayer = AVPlayer(url:url!)
        super.init()
    }
    
    /* calling this function start the radio streaming */
    public func startPlayingRadio() {
        radioPlayer?.play()
    }
    
    /* calling this function pause the radio streaming */
    public func stopPlayingRadio() {
        radioPlayer?.pause()
    }
    
    /* Adding player notification on state changes */
    public func initialiazeObserverForManager(){
        radioPlayer.currentItem?.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
        radioPlayer.currentItem?.addObserver(self, forKeyPath: "status", options:NSKeyValueObservingOptions.new, context: nil)
    }
    
    /* observer to observe state changes from the player */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let hasKeyPath = keyPath else{
            return
        }
        switch hasKeyPath {
        case "timedMetadata":
            decodeMetaData(object: object)
        case "status":
            notifyPlayerState()
        default:
            print("No action on avplayer observer")
        }
    }
    
    /* getting the Artist name from the observed object */
    func decodeMetaData(object: Any?) -> Void {
        let data: AVPlayerItem = object as! AVPlayerItem
        guard let _ = data.timedMetadata else {
            return
        }
        for item in (data.timedMetadata)! {
            guard let artistNameAndAlbum = item.stringValue else {
                return
            }
            notifyArtistChange(artistName: artistNameAndAlbum)
        }
    }
    
    //Mark: - Radio Streaming Observer
    /* attaching lisitners to the manager */
    func attachObserver(observer : RadioStreamingObserver){
        observerArray.append(observer)
    }
    /* removing lisitners */
    func removeObserver(observer : RadioStreamingObserver) {
        observerArray = observerArray.filter{ $0.id != observer.id }
    }
    /* Update/Notifying all the lisitners about the change */
    private func notifyArtistChange(artistName:String){
        for observer in observerArray {
            observer.updateArstistName(name: artistName)
        }
    }
    /* Update/Notifying all the lisitners about the change in playing*/
    private func notifyPlayerState(){
        for observer in observerArray {
            observer.updatePlayerStreaming(state: true)
        }
    }
    
    /* used to cleaning up manager */
    deinit {
        print("Avplayer Manager dellocated")
    }
}


