//
//  Extensions.swift
//  Hürriyet Gündem
//
//  Created by Batuhan Kök on 8.06.2017.
//  Copyright © 2017 Batuhan Kök. All rights reserved.
//

import Foundation
import UIKit


extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}


extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    static var red: UIColor {
        return UIColor(red: 255, green: 59, blue: 48)
    }
    
    static var orange: UIColor {
        return UIColor(red: 255, green: 149, blue: 0)
    }
    
    static var yellow: UIColor {
        return UIColor(red: 255, green: 204, blue: 0)
    }
    
    static var green: UIColor {
        return UIColor(red: 76, green: 217, blue: 100)
    }
    
    static var tealBlue: UIColor {
        return UIColor(red: 90, green: 200, blue: 250)
    }
    
    static var blue: UIColor {
        return UIColor(red: 0, green: 122, blue: 255)
    }
    
    static var purple: UIColor {
        return UIColor(red: 88, green: 86, blue: 214)
    }
    
    static var pink: UIColor {
        return UIColor(red: 255, green: 45, blue: 85)
    }

    static var orange1: UIColor {
        return UIColor(red: 237, green: 146, blue: 77)
    }

    static var purple1: UIColor {
        return UIColor(red: 143, green: 103, blue: 237)
    }

    static var purple2: UIColor {
        return UIColor(red: 78, green: 48, blue: 237)
    }

    static var darkblue: UIColor {
        return UIColor(red: 0, green: 16, blue: 237)
    }

    static var niceblue: UIColor {
        return UIColor(red: 20, green: 119, blue: 237)
    }
    
    static var niceblue1: UIColor {
        return UIColor(red: 33, green: 177, blue: 237)
    }
    
    static var niceblue2: UIColor {
        return UIColor(red: 0, green: 199, blue: 237)
    }
    
    static var green1: UIColor {
        return UIColor(red: 0, green: 237, blue: 66)
    }
    
    static var green2: UIColor {
        return UIColor(red: 34, green: 97, blue: 43)
    }
    
    static var nicepurple1: UIColor {
        return UIColor(red: 147, green: 49, blue: 115)
    }
    
    static var gold: UIColor {
        return UIColor(red: 100, green: 124, blue: 147)
    }
    
    static var darkblue2: UIColor {
        return UIColor(red: 183, green: 170, blue: 0)
    }

    static let colors: [UIColor] = [.red, .orange, .yellow, .green, .tealBlue, .blue, .purple, .pink, .darkblue2, .gold, .nicepurple1, .green2, .green1, .niceblue2, .niceblue1, .niceblue, .darkblue, .purple2, .purple1, .orange1]
    
}

extension UIImage {
    
    static let names: [String] = ["cinayet:\n2", "fetö\n%3", "recep tayyip erdoğan\n%5", "katil\n%5", "türkiye\n%4", "meclis başkanı\n%9", "katar\n%6"]
    
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
}

