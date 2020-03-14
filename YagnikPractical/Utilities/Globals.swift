//
//  Globals.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 14/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.persistentContainer.viewContext
let USER_DEFAULT = UserDefaults.standard
let kToken = "kToken"

//MARK:- *********** INTERNET CHECK *************

var INTERNET_MESSAGE:String = ""

func IS_INTERNET_AVAILABLE() -> Bool {
    return BTReachabilityManager.shared.isInternetAvailableForAllNetworks()
}

extension UIButton {
    
    func setCornerRadiusWithShadow(radius: CGFloat = 0, opacity: Float = 0, offSet: CGSize = CGSize(width: 0.0, height: 0.0), color: UIColor = .black, cornerRadius: CGFloat = 0.0) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
