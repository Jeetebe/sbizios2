//
//  AlbumViewController.swift
//  FRios
//
//  Created by MacBook on 7/16/17.
//  Copyright © 2017 MacBook. All rights reserved.
//
import UIKit
import Alamofire
import  GoogleMobileAds


class AlbumViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var collAlbum: UICollectionView!
    
        var list = [NghesiObj]()
        
        let columnLayout = ColumnFlowLayout2(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.collAlbum?.collectionViewLayout = columnLayout
            alamofireGetAlbum()
            
            //ads
            bannerView.adSize=kGADAdSizeSmartBannerPortrait
            print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
            //bannerView.adUnitID = "ca-app-pub-8623108209004118/3364165189"
            
            //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //test
            bannerView.adUnitID = "ca-app-pub-8623108209004118/9908546789"  //new sbizbanner
            
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        //collv
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row%2 == 0
            {
                cell.backgroundColor = UIColor.gray
            }
            else
            {
                cell.backgroundColor = UIColor.brown
            }
            
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return list.count
            //return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell:CellCasi = collectionView.dequeueReusableCell(withReuseIdentifier: "cellalbum", for: indexPath) as! CellCasi
            
            let imgurl = list[indexPath.row].urlimg
            Alamofire.request(imgurl.replacingOccurrences(of: " ", with: "%20")).response { response in
                if let data = response.data {
                    let image = UIImage(data: data)
                    cell.imageView.image = image
                } else {
                    print("Data is nil. I don't know what to do :(")
                }
            }
            cell.singername.text = list[indexPath.row].name
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 4
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 4
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath as IndexPath) {
                
                let id=list[indexPath.row].nameid.lowercased().replacingOccurrences(of: " ", with: "")
                showplayer(position:indexPath.row)
            } else {
                // Error indexPath is not on screen: this should never happen.
            }
        }
    func showplayer(position: Int) -> Void {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let editTaskVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            editTaskVC.nghesi = self.list[position]
     
            self.present(editTaskVC, animated:true, completion:nil)
        }
        

        
        
        func alamofireGetAlbum() {
            let todoEndpoint: String = "http://123.30.100.126:8081/Restapi/rest/showbiz/getnghesiv2?diemso=1"
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
                    
                    for element in json {
                        if let todoResult = NghesiObj(json: element) {
                            self.list.append(todoResult)
                        }
                    }
                    print("out listalbum:\(self.list.count)")
                    self.collAlbum.reloadData()
                    
            }
        }
}
