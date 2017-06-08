//
//  ViewController.swift
//  Hürriyet Gündem
//
//  Created by Batuhan Kök on 7.06.2017.
//  Copyright © 2017 Batuhan Kök. All rights reserved.
//

import SpriteKit
import Magnetic
import Magnetic
import Alamofire
import UIKit
import Foundation


class ViewController: UIViewController {
    
    var allTags: Array<String> = []
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
        
        for var index in stride(from: 0, to: 250, by: 50){
            self.getJSON(skip: index)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            for var index in stride(from: 250, to: 500, by: 50){
                self.getJSON(skip: index)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            for var index in stride(from: 250, to: 500, by: 50){
                self.getJSON(skip: index)
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            
            var i = 0
            var sum:Double = 0
            
            for (k,v) in (Array(self.wordCount()).sorted {$0.1 > $1.1}) {
                sum = sum + Double(v)
                if i == 25{
                    break
                }
                i += 1
            }
            
            i = 0
            let oran:Double = 100.0/sum //bir birim sayıya düşen katsayı
            
            for (k,v) in (Array(self.wordCount()).sorted {$0.1 > $1.1}) {
                
                var additional:Double = 0.0
                if v == 0 || v < 0{
                    additional = 30
                }else if v > 0 && v < 2{
                    additional = 34
                }else if v > 2 && v < 4{
                    additional = 36
                }else if v > 4 && v < 6{
                    additional = 39
                }else if v > 6 && v < 8{
                    additional = 42
                }else if v > 8 && v < 12{
                    additional = 45
                }else if v > 12 && v < 18{
                    additional = 48
                }else if v > 18 && v < 25{
                    additional = 51
                }else if v > 25 && v < 35{
                    additional = 54
                }else if v > 35 && v < 45{
                    additional = 56
                }else if v > 45 && v < 65{
                    additional = 58
                }else if v > 65{
                    additional = 60
                }
                
                var rad = Double(oran * Double(v)) + additional

                if(rad > 72){
                    rad = 72
                }else if(rad < 30){
                    rad = 30
                }
                
                self.add(name: k, radius: Float(rad))

                
                if i == 25{
                    break
                }
                
                i += 1
            }
            
        }
            
        // All three of these calls are equivalent
        //Alamofire.request("http://localhost/hurriyet/a.php", method: .post, parameters: parameters)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xED1C23)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSForegroundColorAttributeName: UIColor.white ]

  
      
    }

    
    func wordCount() -> Dictionary<String, Int> {
        var wordDictionary = Dictionary<String, Int>()
        for word in allTags {
            if ((wordDictionary[word]) != nil) {
                wordDictionary[word] = wordDictionary[word]! + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
    
    
    func getJSON(skip:Int){
        
        let headers: HTTPHeaders = [
            "apikey": "08564ff940134627a6ded4ebada4d4f9",
            "Accept": "application/json"
        ]
        
        let parameters: Parameters = ["$filter": "Path eq '/gundem/'", "$select": "Tags", "$top": "50", "$skip": "\(skip)"]
        
        Alamofire.request("https://api.hurriyet.com.tr/v1/articles", parameters: parameters, headers: headers).responseJSON{ response in
            
            if let json = response.result.value {
                for tags in (json as? [Dictionary<String, AnyObject>])!{
                    for tag in tags["Tags"] as! [String]{
                        
                        if tag == "gazetehaberleri" || tag == "son dakika" || tag == "sondakika" || tag.characters.count > 25{
                            
                        }else{
                            let lowertag:String = tag.lowercased()
                            self.allTags.append(lowertag)
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    func add(name: String, radius:Float) {
        let name = name
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: CGFloat(radius))
        magnetic.addChild(node)

    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// MARK: - MagneticDelegate
extension ViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
}

// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            sprite.texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}


