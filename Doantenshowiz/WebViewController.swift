//
//  WebViewController.swift
//  Doantenshowiz
//
//  Created by MacBook on 12/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import SwiftSoup
import  GoogleMobileAds

class WebViewController: UIViewController ,GADInterstitialDelegate {

    var nghesi: NghesiObj!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var myimage: UIImageView!
    
    @IBOutlet weak var myname: UILabel!
    
    @IBOutlet weak var myweb: UIWebView!
    
    @IBAction func close(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
         show_ads()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myname.text = nghesi.name
        
        let urlimage = URL(string: nghesi.urlimg)
        let data = try? Data(contentsOf: urlimage!)
        myimage.image = UIImage(data: data!)
        
        let url = URL (string: "http://google.com")
        let requestObj = URLRequest(url: url!)
        myweb.loadRequest(requestObj)
        
        
        
        var stringkqua=""
        
        do{
            let html: String = gethtml(nameid: nghesi.nameid)
           
            guard let els: Elements = try? SwiftSoup.parse(html).select("p")  else {return}
            for element: Element in els.array(){
                //print(try? element.html())
              
               try? stringkqua = stringkqua + element.html()
            }
        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }
        
        var customHtml = "<!DOCTYPE html><html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width\"><title>Untitled 1</title></head><body>" +     stringkqua ;
       customHtml=customHtml + "</body></html>";
        
        
        myweb.loadHTMLString(customHtml, baseURL: nil)
        
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8623108209004118/4267318788")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        

    }
    func createAndLoadInterstitial() -> GADInterstitial {
        //        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-8623108209004118/4267318788")
        //        interstitial.delegate = self as! GADInterstitialDelegate
        //        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // interstitial = createAndLoadInterstitial()
        self.dismiss(animated: true, completion: nil)
    }
    
    func gethtml(nameid:String) -> String {
        let myURLString = "http://nguoi-noi-tieng.com/tieu-su/" + nameid
        var myHTMLString=""
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return myHTMLString
        }
        
        do {
            myHTMLString = try NSString(contentsOf: myURL, encoding: String.Encoding.utf8.rawValue) as String
            //print("HTML : \(myHTMLString)")
        } catch let error {
            print("Error: \(error)")
        }
        return myHTMLString
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show_ads() -> Void {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
              self.dismiss(animated: true, completion: nil)
        }
        
    }

}
