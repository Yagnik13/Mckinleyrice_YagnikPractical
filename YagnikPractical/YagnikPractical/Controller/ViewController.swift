//
//  ViewController.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 14/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tokenValue = USER_DEFAULT.value(forKey: kToken) as? String , !tokenValue.isEmpty {
            openWebViewController(tokenValue: tokenValue)
        }
    }
    
    //MARK:- Button Actions
    @IBAction func LoginButtonAction(_ sender: Any) {
        if isValid() {
            apiCall(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        }
    }
    
    //MARK:- Custom Methods
    private func setupUI() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.masksToBounds = true
        
        loginButton.setCornerRadiusWithShadow(radius: 8, opacity: 0.15, offSet: CGSize(width: 0, height: 4), color: UIColor.black.withAlphaComponent(0.5), cornerRadius: 8)
    }
    
    private func isValid() ->Bool {
        
        if emailTextField.text?.isEmpty ?? false{
            showAlertWithTitleFromVC(vc: self, andMessage: "Please enter Email Address")
            return false
        }
        
        if !(emailTextField.text?.isEmail ?? false){
            showAlertWithTitleFromVC(vc: self, andMessage: "Please enter valid Email Address")
            return false
        }
        
        if passwordTextField.text?.isEmpty ?? false{
            showAlertWithTitleFromVC(vc: self, andMessage: "Please enter Password")
            return false
        }
        
        return true
    }
    
    private func apiCall(email: String, password: String) {
        var parameter : [String : Any] = [:]
        parameter["email"] = email
        parameter["password"] = password
        
        if IS_INTERNET_AVAILABLE() {
            loginWS(parameters: parameter as! [String : String]) { (response) in
                if let responseData = response as? [String:Any]{
                    if let token = responseData["token"] as? String {
                        USER_DEFAULT.set(token, forKey: kToken)
                        USER_DEFAULT.synchronize()
                        self.openWebViewController(tokenValue: token)
                    }
                }
            }
        }else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please check your internet connection, Please try again later")
        }
        
    }
    
    private func openWebViewController(tokenValue : String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
        vc.token = tokenValue
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
}

//MARK: API CALL
extension ViewController {
    
    func loginWS(parameters:[String:String], completionHandler: @escaping (Any?) -> Swift.Void) {
        
        guard let gitUrl = URL(string: "https://reqres.in/api/login") else { return }
        print(gitUrl)
        
        var request = URLRequest(url: gitUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("https://reqres.in", forHTTPHeaderField: "Access-Control-Allow-Origin")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    completionHandler(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
