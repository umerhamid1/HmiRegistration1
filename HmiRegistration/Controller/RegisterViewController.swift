//
//  RegisterViewController.swift
//  HmiRegistration
//
//  Created by umer hamid on 10/18/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    
    let  REGISTRATION_URL = "http://qa.homechef.pk/api/v1/register"

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func registrationButtonPressed(_ sender: Any) {
  
        let v = Validation()
        
        let name = v.isValidName(value: nameTextField.text!)
        let phone = v.isValidatePhone(value: mobileTextField.text!)
        let email = v.isValidEmailAddress(emailAddressString: emailTextField.text!)
        let password = v.isValidPassword(value: passwordTextField.text!)
        
        print("here is name \(name)")
        print("here is phone \(phone)")
        print("here is email \(email)")
        print("here is password \(password)")
        
        if name == false {
            displayAlertMessage(messageToDisplay: "name should be contain only character")
        }else if phone == false {
            displayAlertMessage(messageToDisplay: "phone no is invalid")
        }else if email == false {
            displayAlertMessage(messageToDisplay: "email is invalid")
        }else if password == false {
            displayAlertMessage(messageToDisplay: "password should contain alteast one number and strings")
        }else{

            self.view.makeToastActivity(.center)
            
            let param = [ "name" : nameTextField.text! , "mobile" :mobileTextField.text!, "password" : passwordTextField.text! , "email" : emailTextField.text!]
            
            getRegistraionDetail(url: REGISTRATION_URL, parameters: param)
            
        }
        
    
    }
    
    
//    {
//      "special_msg" : "Done here",
//      "message" : "User registered successfully",
//      "uid" : "5daa7a7d4c95f33d7206bc37"
//    }

    func getRegistraionDetail (url : String , parameters : [String : String])   {
           
           var uID = ""
           var msg = ""
           var style = ToastStyle()
           style.messageColor = .white
           
          
              Alamofire.request(url, method: .post , parameters: parameters).responseJSON {
                  response in
                  if response.result.isSuccess {
                   
                   
                    print("here is result ok")
                  
                   
                   let loginJSON : JSON =  JSON(response.result.value!)
                   
                  //
                   print(loginJSON)
                   uID = loginJSON["uid"].stringValue
                   msg = loginJSON["message"].stringValue
                   if uID != "" {

                    
                    self.view.hideToastActivity()
                    self.view.makeToast("Registraion  SuccesFul", duration: 1.0, position: .bottom, style: style)

                    let secondsToDelay = 0.5
                       DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                          //print("This message is delayed")
                          // Put any code you want to be delayed here
                           self.performSegue(withIdentifier: "goToLogin", sender: self)
                       }







                   }
                   else if msg != "" {
                    
                        self.view.hideToastActivity()
                        self.view.makeToast("Error : \(msg)", duration: 4.0, position: .bottom, style: style)
                   }

                
                     
                  }else{
                  
                   
                   var style = ToastStyle()
                   style.messageColor = .white
                    
                    self.view.hideToastActivity()
                   self.view.makeToast("Error : \(response.result.error?.localizedDescription)", duration: 3.0, position: .center, style: style)
                   
                 
                   
                  }
              }
     
          }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLogin"{

            
            
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
