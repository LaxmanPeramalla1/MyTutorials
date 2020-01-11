//
//  RadioStreamingObserver.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 18/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

protocol RadioStreamingObserver{
    var id : String{ get }
    func updateArstistName(name:String?)
    func updatePlayerStreaming(state:Bool)
}
