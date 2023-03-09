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
    var targetSettings = TargetSettings()
    var propositions = Propositions()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Adobe Experience Platform - Send XDM Event
        //Prep Data
        let stateName = "luma: content: ios: us: en: offers"
        var xdmData: [String: Any] = [:]

        self.applyPropositions();

        let experienceEvent = ExperienceEvent(xdm: xdmData)
        Edge.sendEvent(experienceEvent: experienceEvent)


    }
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getAndSetImage(from url: URL) {
        getImageData(from: url) { imgdata, response, err in
            guard let data = imgdata, err == nil else { return }
            DispatchQueue.main.async {
                if (self.offerImage != nil) {
                    self.offerImage.image = UIImage(data: data)
                }
            }
            
        }
    }

    func showOffers(offer: [String:String]) {
        DispatchQueue.main.async {
            var url = URL(string: "https://example.com/81b91e817aac9a8cd090723111085cdd_mj12-orange_main.jpeg")!
            if let offerImg = offer["offerImage"] {
                url = URL(string: offerImg)!
            } else {
                url = url
            }
            self.getAndSetImage(from: url)
            self.offerTargetLabel.text = offer["offerTitle"]
            self.offerTargetLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.offerTargetLabel.numberOfLines = 0
            self.subTitle1.text = offer["offerSubTitle1"]
            self.subTitle2.text = offer["offerSubTitle2"]
            self.offerCTA.setTitle(offer["offerCTA"], for: .normal)
        }
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
    
    func applyPropositions() {
        var errorMessage = ""
        let targetScope = DecisionScope(name: "app_view_offers")

        Optimize.getPropositions(for: [
            targetScope
        ]) {
            propositionsDict, error in
            
            if let error = error {
                errorMessage = error.localizedDescription
                print(errorMessage)
            } else {
                guard let propositionsDict = propositionsDict else {
                    return
                }

                if propositionsDict.isEmpty {
                    self.propositions.targetProposition = nil
                    return
                }
                
                if let targetProposition = propositionsDict[targetScope] {
                    for offer in targetProposition.offers {
                        let data = Data(offer.content.utf8)
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let object = json as? [String: String] {
                                self.showOffers(offer:object)
                                offer.displayed()
                                //self.applyConversion()
                                
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
   

    
    func applyConversion() {
        var errorMessage = ""
        let targetScope = DecisionScope(name: "app_view_offers")

        Optimize.getPropositions(for: [
            targetScope
        ]) {
            propositionsDict, error in
            
            if let error = error {
                errorMessage = error.localizedDescription
                print(errorMessage)
            } else {
                guard let propositionsDict = propositionsDict else {
                    return
                }

                if propositionsDict.isEmpty {
                    self.propositions.targetProposition = nil
                    return
                }
                
                if let targetProposition = propositionsDict[targetScope] {
                    for offer in targetProposition.offers {
                        print("tnt, \(offer)")
                        //  offer.displayed();
                        offer.tapped();
                    }
                }
            }
        }
    }
}
