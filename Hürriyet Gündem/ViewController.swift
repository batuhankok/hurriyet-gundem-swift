//
//  ViewController.swift
//  Hürriyet Gündem
//
//  Created by Batuhan Kök on 7.06.2017.
//  Copyright © 2017 Batuhan Kök. All rights reserved.
//


import UIKit
import Foundation
import RSLoadingView
import Magnetic
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    var allTags: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup view
        setupOfView()
        
        //Change the design of navigation bar
        navigationBarDesign()

    }
    
    
    func setupOfView(){
        
        //Loading animations (start)
        showOnViewTwins()
        
        //Hurriyet API is allowed to us to make 5 requests per a second so this is first 5 requests
        for var index in stride(from: 0, to: 250, by: 49){
            index = index + 1
            self.getJSON(skip: index)
        }
        
        //This is second 5 requests after 1.3 second previous request.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            for var index in stride(from: 250, to: 500, by: 49){
                index = index + 1
                self.getJSON(skip: index)
            }
        }
        
        //This is third 5 requests after 1.3 second previous request.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            for var index in stride(from: 250, to: 500, by: 49){
                index = index + 1
                self.getJSON(skip: index)
            }
        }
        
        //Add all nodes to the screen after 3.1 seconds from opening.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            
            //Sum of all words
            var i = 0; var sum:Double = 0
            for (_,v) in (Array(self.wordCount()).sorted {$0.1 > $1.1}) {
                sum = sum + Double(v)
                if i == 30{ break}
                i += 1
            }
            
            //Calculate the node's size and add them to the screen
            i = 0; let oran:Double = 100.0/sum //1br = what?
            for (k,v) in (Array(self.wordCount()).sorted {$0.1 > $1.1}) {
                
                //Calculate the additional size of node's
                var additional:Double = 0.0
                if v == 0 || v < 0{ additional = 30 }else if v > 0 && v < 2{ additional = 34 }
                else if v > 2 && v < 4{ additional = 36 }else if v > 4 && v < 6{ additional = 39 }
                else if v > 6 && v < 8{ additional = 42 }else if v > 8 && v < 12{ additional = 45 }
                else if v > 12 && v < 18{ additional = 48 }else if v > 18 && v < 25{ additional = 51 }
                else if v > 25 && v < 35{ additional = 54 }else if v > 35 && v < 45{ additional = 56 }
                else if v > 45 && v < 65{ additional = 58 }else if v > 65{ additional = 60 }
                
                //Calculate the full and real size of node's
                var rad = Double(oran * Double(v)) + additional
                
                //Check the size of node cannot be more than 72 or less than 30
                if(rad > 72){ rad = 72 }else if(rad < 30){ rad = 30 }
                
                //Add nodes!
                self.add(name: k, radius: Float(rad))
                
                //First 30 words are enough
                if i == 30{ break }
                i += 1
                
            }
            
            //Loading animation (stop)
            self.hideLoadingHub()
            
            
        }
        
    }

    
    //Cont the words of string to learn how many times that word has been used.
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
    
    
    //Make a request to get json from Hurriyet API.
    func getJSON(skip:Int){
        
        //Our headers
        let headers: HTTPHeaders = [
            "apikey": "08564ff940134627a6ded4ebada4d4f9", //Please change the api key to yours.
            "Accept": "application/json"
        ]
        
        //Parameters of the request
        let parameters: Parameters = ["$filter": "Path eq '/gundem/'", "$select": "Tags", "$top": "50", "$skip": "\(skip)"]
        
        Alamofire.request("https://api.hurriyet.com.tr/v1/articles", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<303)
            .validate(contentType: ["application/json"])
            .responseJSON{ response in
            
            switch response.result.isSuccess {
            
                //if everything is going true
                case true:
                
                    //if the response is nil
                    guard let resultValue = response.result.value else {
                        NSLog("Result value in response is nil")
                        return
                    }
                
                    let responseJSON = JSON(resultValue)
                
                    for (_,subJson):(String, JSON) in responseJSON {
                        for (_,subJson):(String, JSON) in subJson["Tags"] {
                        
                            let tag:String = "\(subJson[])"
                        
                            //Filter for tags!
                            if tag != "gazetehaberleri" || tag != "son dakika" || tag != "sondakika" || tag.characters.count < 26 {
                            
                                let lowertag:String = tag.lowercased()
                                self.allTags.append(lowertag)
                            
                            }
                        
                        }
                    }
                
                break
                
                //if something is going wrong
                case false:
                
                    NSLog("Result status is failure")
                
                break
                
            }
        
            
            /*
            ## OLD CODE ##
                 
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
            }*/
        }
        
        
    }
    
    
    //Add nodes to the view
    func add(name: String, radius:Float) {
        
        let name = name
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: CGFloat(radius))
        magnetic.addChild(node)

    }
    
    
    //Navigation bar's design
    func navigationBarDesign(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xED1C23)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSForegroundColorAttributeName: UIColor.white ]
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        infoButton.tintColor = UIColor.white
        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    
    //When info button is tapped
    func infoButtonTapped(){
        
        let alertController = UIAlertController(title: "Bilgi", message: "Bilgi almak istiyor musunuz?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Geliştiriciye E-mail Gönder", style: .default, handler: { (action) -> Void in
            print("İşlem yapılacak")
        })
        
        let  deleteButton = UIAlertAction(title: "Geliştirici: Batuhan Kök", style: .destructive, handler: { (action) -> Void in
        })
        
        let cancelButton = UIAlertAction(title: "İptal", style: .cancel, handler: { (action) -> Void in
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }

    
    //When refresh button is tapped
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
        allTags = []
        magneticView.magnetic.removeAllChildren()
        setupOfView()
        
    }
    
    
    //Magneticview
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
        }
    }
    
    
    //Magnetic
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    
    //Loading animation
    @IBAction func showOnViewTwins() {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.mainColor = UIColor(hex: 0xFFFFFF)
        loadingView.isBlocking = true
        loadingView.show(on: view)
    }
    
    
    //Hide loading animation
    func hideLoadingHub() {
        RSLoadingView.hide(from: view)
    }
    
    
    //White status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


