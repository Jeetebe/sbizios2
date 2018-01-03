//
//  ViewController.swift
//  Doantenshowiz
//
//  Created by MacBook on 12/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import  GoogleMobileAds
import Alamofire
import PopupDialog
import AVFoundation

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}

class ViewController: UIViewController, ScratchCardImageViewDelegate , UICollectionViewDataSource, UICollectionViewDelegate,GADInterstitialDelegate{

    
    var songname:String=""

    var currsong = NghesiObj(name: "tranthanh", nameid: "tranthanh", urlimg: "url")

    var characters:[String]=[]
    var traloi:[String]=[]
    var traloiInt:[Int]=[]
    var lvisible:[Bool]=[]

    var list=[NghesiObj]()
    var currInt=0;
    var num = 18
    var coin=10
    var point=0
    var type1:String!
    var device:String!
    
     var bombSoundEffect: AVAudioPlayer?
    var interstitial: GADInterstitial!
    
    
    @IBOutlet weak var scratchCard: ScratchCardImageView!
    
    @IBOutlet weak var collv1songname: UICollectionView!
    @IBOutlet weak var collv: UICollectionView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var lbpint: UILabel!
    
    @IBAction func back(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
          show_ads()
    }
    
    
    @IBAction func showhelp(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let editTaskVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        editTaskVC.nghesi = self.currsong
        
        self.present(editTaskVC, animated:true, completion:nil)
    }
    
    @IBAction func playnext(_ sender: Any) {
        alamofireGetAlbum() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let userDefaults = UserDefaults.standard
        coin  = userDefaults.integer(forKey: "coin")
        point  = userDefaults.integer(forKey: "point")
        device  = userDefaults.string(forKey: "device")

        
        scratchCard.image = UIImage(color: UIColor.gray, size: scratchCard.frame.size)
        scratchCard.lineType = .square
        scratchCard.lineWidth = 5
        scratchCard.delegate = self
        
        repare(songname: songname)
        alamofireGetAlbum()
        
        
        //ads
        bannerView.adSize=kGADAdSizeSmartBannerPortrait
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        //bannerView.adUnitID = "ca-app-pub-8623108209004118/3364165189"
        
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //test
        bannerView.adUnitID = "ca-app-pub-8623108209004118/9908546789"  //new sbizbanner
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        
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
    
    func show_ads() -> Void {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func setupgame() -> Void {
        self.num=18;
        traloiInt.removeAll()
        traloi.removeAll()
        lvisible.removeAll()
        
        currInt=0 //fix
        currsong = list[currInt]
        songname=(currsong?.name.replacingOccurrences(of: " ", with: ""))!
        print("song:\(songname)")
        
        //songname=(currsong?.tonename.replacingOccurrences(of: " ", with: ""))!
        repare(songname: songname)
      
        let urlimage = URL(string: (currsong?.urlimg)!)
        let data = try? Data(contentsOf: urlimage!)
        myImage.image = UIImage(data: data!)
        
        
        collv1songname.isUserInteractionEnabled = true
        collv.isUserInteractionEnabled = true
        collv1songname.reloadData()
        collv.reloadData()
        currInt += 1
       
        scratchCard.image = UIImage(color: UIColor.gray, size: scratchCard.frame.size)
    }
    func  playnext() -> Void {
       alamofireGetAlbum()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scratchCardImageViewDidEraseProgress(eraseProgress: Float) {
        
        //print(eraseProgress)
    }
    func repare(songname:String) -> Void {
        //let l = songname.lengthOfBytes(using: .utf16)
        let l = songname.count
        print("len:\(l)")
        let randstr=randomString(length: 18-l) + songname.uppercased()
        
        characters = randstr.characters.map { String($0) }
        print(characters)
        characters.shuffle()
        print(characters)
        for i in 0...17
        {
            lvisible.append(true)
        }
        collv1songname.reloadData()
        collv.reloadData()
        
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        if (collectionView==self.collv)
        {
            return num
        }
        else
        {
            //let l = songname.lengthOfBytes(using: .utf16)
            let l = songname.count
            print("len:\(l)")
            return l
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView==self.collv)
        {
            let cell = collv.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! Mycell
            // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
            cell.backgroundColor = UIColor.white
            cell.lb.text = characters[indexPath.item]
            cell.backgroundColor = UIColor .clear
            if (lvisible[indexPath.row])
            {
                //cell.lb.isHidden=false
                cell.isHidden = false
                
            }
            else
            {
                //cell.lb.isHidden=true
                cell.isHidden = true
            }
            return cell
        }
        else{
            let cell = collv1songname.dequeueReusableCell(withReuseIdentifier: "mycellsongname", for: indexPath) as! Mycell1
            // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
            //cell.backgroundColor = UIColor.cyan
            var str:String=""
            //print("size:\(traloi.count)")
            if (indexPath.row<=traloi.count-1)
            {
                str=traloi[indexPath.item]
                //cell.backgroundColor = UIColor.blue
            }
            
            cell.lbsongname.text = str
            //cell.backgroundColor = UIColor .clear
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        playsoundclick()
        if (collectionView==self.collv)
        {
            //xli gridview 2
            
            lvisible[indexPath.row]=false
            
            traloi.append(characters[indexPath.item])
            traloiInt.append(indexPath.row)
            
            
            //collectionView.reloadData()
        }
        else
        {
            //xli grid 1
            if traloi.count>0
            {
                traloi.removeLast()
                lvisible[traloiInt.last!]=true
                traloiInt.removeLast()
            }
            
            
        }
        self.collv1songname.reloadData()
        self.collv.reloadData()
        //print("\(lvisible)")
        
        if (traloi.count==songname.count)
        {
            //check kqua
            let strdapan=traloi.flatMap({$0}).joined()
            print("dapan:\(strdapan)")
            print("songname:\(songname)")
            
            if (strdapan==songname.uppercased())
            {
                print("kqua:dung")
                show_congrate()
                point += 1
                coin += 1
                update_label()
            }
            else
            {
                  print("kqua:sai")
            }
        }
        
    }
    func playsoundclick()  {
        let path = Bundle.main.path(forResource: "click.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    func alamofireGetAlbum() {
        let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/showbiz/getnghesiv2?num=40&device=" + device
        print("url:"+todoEndpoint)
        Alamofire.request(todoEndpoint)
            
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print(response.result.error!)
                    //completionHandler(.failure(response.result.error!))
                    return
                }
                
                // make sure we got JSON and it's an array of dictionaries
                guard let json = response.result.value as? [[String: AnyObject]] else {
                    print("didn't get todo objects as JSON from API")
                    //                    completionHandler(.failure(BackendError.objectSerialization(reason: "Did not get JSON array in response")))
                    return
                }
                
                // turn each item in JSON in to Todo object
                self.list.removeAll()
                for element in json {
                    if let todoResult = NghesiObj(json: element) {
                        self.list.append(todoResult)
                    }
                }
                print("out listalbum:\(self.list.count)")
                self.setupgame()
                
        }
    }
    func show_congrate() -> Void {
        // Prepare the popup assets
        let title = ""
        let message = ""
        let image = UIImage(named: "congra")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CHƠI TIẾP") {
            //print("You canceled the car dialog.")
            self.playnext()
        }
        let button2 = CancelButton(title: "TIỂU SỬ") {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let editTaskVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            editTaskVC.nghesi = self.currsong
            
            self.present(editTaskVC, animated:true, completion:nil)
        }
        
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([button2])
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    func update_label() -> Void {
        lbpint.text = String(point)
        //lbcoin.text = String(coin)
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(coin, forKey: "coin")
        userDefaults.set(point, forKey: "point")
    }
    

}

