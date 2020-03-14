//
//  UtilFunctions.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 14/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- ******** ALERT METHODS *********

func showAlertWithTitleFromVC(vc:UIViewController, andMessage message:String){
    showAlertWithTitleFromVC(vc: vc, title:"", andMessage: message, buttons: ["OK"]) { (index) in
    }
}

func showAlertWithTitleFromVC(vc:UIViewController, title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    var newMessage = message
    if newMessage == "The Internet connection appears to be offline. Please check and try again" {
        newMessage = "The Internet connection appears to be offline. Please check and try again"
    }

    let alertController = UIAlertController(title: title, message: newMessage, preferredStyle: .alert)
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.backgroundColor = UIColor.white
//    alertContentView.applyCornerRadius(radius: 10)
    alertContentView.tintColor = UIColor.black
    
    let messageMutableString = NSMutableAttributedString(string: newMessage)
    let messageRange = NSRange(location: 0, length: messageMutableString.length)
    messageMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: messageRange)
    messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: messageRange)
    alertController.setValue(messageMutableString, forKey: "attributedMessage")
    
    
    for index in 0..<buttons.count    { 
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        let attributedText = NSMutableAttributedString(string: buttons[index])
        
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: range)
        alertController.addAction(action)
    }
    vc.present(alertController, animated: true, completion: nil)
}
