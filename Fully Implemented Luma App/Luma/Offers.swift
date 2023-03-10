//
//  Offers.swift
//  Luma iOS Mobile Application
//
//  Developed by XScoder, https://xscoder.com
//  Enhanced by Adobe Inc. to support Adobe Experience Cloud and Adobe Experience Platform
//  All Rights reserved - 2022
//

import Foundation
import UserNotifications

//Adobe AEP SDKs
import AEPCore
import AEPEdge

import AEPOptimize
import AEPEdgeIdentity


class Offers: UIViewController
{
    @IBOutlet weak var offerTargetLabel: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var subTitle1: UILabel!
    @IBOutlet weak var subTitle2: UILabel!
    @IBOutlet weak var offerCTA: UIButton!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Adobe Experience Platform - Send XDM Event
        //Prep Data
        let stateName = "luma: content: ios: us: en: offers"
        var xdmData: [String: Any] = [:]
        
        
        let experienceEvent = ExperienceEvent(xdm: xdmData)
        Edge.sendEvent(experienceEvent: experienceEvent)
        
        
    }

    
    // ------------------------------------------------
    // VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layouts
        //myOrdersButton.layer.cornerRadius = 8
        //containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 800)
        //avatarImg.layer.cornerRadius = avatarImg.bounds.size.width/2
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
}
