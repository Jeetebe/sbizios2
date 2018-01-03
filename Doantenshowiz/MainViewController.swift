//
//  MainViewController.swift
//  Doantenshowiz
//
//  Created by MacBook on 12/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import Social

class MainViewController: UIViewController {

    let link:String="Đoán tên showbiz  http://itunes.apple.com/app/id1331034164"
      var solan=0
    
    
    @IBAction func share(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            controller?.setInitialText(link)
            //controller.addImage(captureScreen())
            self.present(controller!, animated:true, completion:nil)
        }
            
        else {
            print("no Facebook account found on device")
            var alert = UIAlertView(title: "Thông báo", message: "Bạn chưa đăng nhập facebook", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
   
    @IBAction func go_store(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/developer/tran-duy/id1232657492")! as URL)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To retrieve from the key
        let userDefaults = UserDefaults.standard
        var device  = userDefaults.string(forKey: "device")
        print("device \(device)")
        
        if (device == nil)
        {
            let uuid = NSUUID().uuidString
            device = randomStringWithLength(len: 10) as String
            //device=uuid
            userDefaults.set(device, forKey: "device")
            userDefaults.set(0, forKey: "solan")
            userDefaults.set(10, forKey: "coin")
            userDefaults.set(0, forKey: "point")
            
        }
        else
        {
            
            device  = userDefaults.string(forKey: "device")
            solan  = userDefaults.integer(forKey: "solan")
        }
        
        
        print("solan \(solan)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len {
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }


}
