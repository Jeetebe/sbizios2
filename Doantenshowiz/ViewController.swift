//
//  ViewController.swift
//  Doantenshowiz
//
//  Created by MacBook on 12/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}

class ViewController: UIViewController, ScratchCardImageViewDelegate , UICollectionViewDataSource, UICollectionViewDelegate{

    
    var songname:String="TRANTHANH"

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
    

    @IBOutlet weak var scratchCard: ScratchCardImageView!
    
    @IBOutlet weak var collv1songname: UICollectionView!
    @IBOutlet weak var collv: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        scratchCard.image = UIImage(color: UIColor.gray, size: scratchCard.frame.size)
        scratchCard.lineType = .square
        scratchCard.lineWidth = 10
        scratchCard.delegate = self
        
        repare(songname: songname)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scratchCardImageViewDidEraseProgress(eraseProgress: Float) {
        
        //print(eraseProgress)
    }
    func repare(songname:String) -> Void {
        let l=songname.lengthOfBytes(using: .ascii)
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
            return songname.lengthOfBytes(using: .ascii)
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
            cell.backgroundColor = UIColor.white
            var str:String=""
            //print("size:\(traloi.count)")
            if (indexPath.row<=traloi.count-1)
            {
                str=traloi[indexPath.item]
                //cell.backgroundColor = UIColor.blue
            }
            
            cell.lbsongname.text = str
            cell.backgroundColor = UIColor .clear
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
                lvisible[traloiInt[indexPath.row]]=true
                traloiInt.removeLast()
            }
            
            
        }
        self.collv1songname.reloadData()
        self.collv.reloadData()
        //print("\(lvisible)")
        
        if (traloi.count==songname.lengthOfBytes(using: .ascii))
        {
            //check kqua
            let strdapan=traloi.flatMap({$0}).joined()
            print("dapan:\(strdapan)")
            print("songname:\(currsong?.name)")
            if (strdapan==songname)
            {
                //show_congrate()
                point += 1
                coin += 1
                //update_label()
            }
            else
            {
                
            }
        }
        
    }

}

