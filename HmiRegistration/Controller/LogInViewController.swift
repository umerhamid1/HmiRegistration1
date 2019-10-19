//
//  LogInViewController.swift
//  HmiRegistration
//
//  Created by umer hamid on 10/18/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LogInViewController: UIViewController {
    
    
   
    let  LOGIN_URL = "http://qa.homechef.pk/api/v1/login"

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mainView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        


    }
    

    @IBAction func loginButoonPressed(_ sender: Any) {
        
        
       
        let v = Validation()
        

        
        let phoneNo = v.isValidatePhone(value: phoneNumberTextField.text!)
     
        
        
        if phoneNo == false {
       
            displayAlertMessage(messageToDisplay: "phone no is inCorrect")
            
        }else if passwordTextField.text! == "" {
        
            
            displayAlertMessage(messageToDisplay: "password should contain 6 character with atleat 1 number")
            
            
        }else{
            
            
      
        self.view.makeToastActivity(.center)
              
            
            
            
        let param = [ "mobile" : phoneNumberTextField.text! , "password" : passwordTextField.text!]
            
              //self.view.hideAllToasts()
        let result =   getLoginDetail(url: LOGIN_URL, parameters: param)
       
            
  

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWelcome" {
     
            
        }
    }
    
    
       
       //let param = ["name" : "sheikh aman", "mobile" : "03452932125" , "password" : "ABCdefgh12345!@"  , "email" : "smomerrock1947@yahoo.com"]
          
    
   
         

    // present the toast with the new style
   
  //  var dg = DispatchGroup()
       func getLoginDetail (url : String , parameters : [String : String])    {
        
        var userName = ""
        var msg = ""
        var style = ToastStyle()
        style.messageColor = .white
        //  self.view.hideAllToasts()
      
           Alamofire.request(url, method: .post , parameters: parameters).responseJSON {
               response in
               if response.result.isSuccess {
                
                
                 print("here is result ok")
               
                
                let loginJSON : JSON =  JSON(response.result.value!)
                
               //
                print(loginJSON)
                userName = loginJSON["name"].stringValue
                msg = loginJSON["message"].stringValue
                // self.view.hideAllToasts()
                if userName != "" {
                   
                    self.view.hideToastActivity()
                     self.view.makeToast("Login SuccesFully", duration: 1.0, position: .bottom, style: style)
                    
                    let secondsToDelay = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                       print("This message is delayed")
                       // Put any code you want to be delayed here
                       
                        self.performSegue(withIdentifier: "goToWelcome", sender: self)
                    }
                   
     
                    
                }else if msg != "" {
                  
                    
                    self.view.hideToastActivity()
                     self.view.makeToast("Error : \(msg)", duration: 4.0, position: .bottom, style: style)
                }
                
             
              
               
               }else{
                  
                  self.view.hideToastActivity()
                
                var style = ToastStyle()
                style.messageColor = .white
                self.view.makeToast("Error : \(response.result.error?.localizedDescription)", duration: 3.0, position: .center, style: style)
                
                print("Error : \(response.result.error?.localizedDescription)")
              
                
               }
           }
        
       }
    
    
    

    
    // here alert controller
    func displayAlertMessage(messageToDisplay: String)
           {
               let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
               
               let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                   
                   // Code in this block will trigger when OK button tapped.
                   print("Ok button tapped");
          
               }
               
               alertController.addAction(OKAction)
               
               self.present(alertController, animated: true, completion:nil)
           }
    
    
 
}

class Validation{
    
    
    // phone number validation
       func isValidatePhone(value: String) -> Bool {
            let PHONE_REGEX = "^[0][1-9]\\d{9}$|^[1-9]\\d{9}$"
           // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }
        
        
    
    // password validation
        func isValidPassword(value: String) -> Bool {
              let PASSWORD_REGEX = "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$"
             // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
              let phoneTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
              let result =  phoneTest.evaluate(with: value)
              return result
          }
        
        
        
  
        
        //email validation
        func isValidEmailAddress(emailAddressString: String) -> Bool {
    
             var returnValue = true
             let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
             do {
                 let regex = try NSRegularExpression(pattern: emailRegEx)
                 let nsString = emailAddressString as NSString
                 let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
    
                 if results.count == 0
                 {
                     returnValue = false
                 }
    
             } catch let error as NSError {
                 print("invalid regex: \(error.localizedDescription)")
                 returnValue = false
             }
    
             return  returnValue
         }
    
      func isValidName(value: String) -> Bool {
               let PASSWORD_REGEX = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
              // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
               let nameTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
               let result =  nameTest.evaluate(with: value)
               return result
           }
        
}

