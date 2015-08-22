//
//  AuthViewController.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 8/21/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import UIKit

import Parse

enum AuthMode
{
    case SignIn
    case SignUp
}


class AuthViewController: UIViewController, UITextFieldDelegate {
    
    var authMode: AuthMode = AuthMode.SignUp
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.edgesForExtendedLayout = UIRectEdge.None
        
        var emailImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.emailTextField!.frame.size.height))
        emailImageView.image = UIImage(named: "EmailIcon")
        emailImageView.contentMode = .Center
        
        self.emailTextField!.leftView = emailImageView
        self.emailTextField!.leftViewMode = .Always
        
        
        var passwordImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.passwordTextField!.frame.size.height))
        passwordImageView.image = UIImage(named: "PasswordIcon")
        passwordImageView.contentMode = .Center
        
        self.passwordTextField!.leftView = passwordImageView
        self.passwordTextField!.leftViewMode = .Always
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.emailTextField?.becomeFirstResponder()
    }

    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if(textField == self.emailTextField)
        {
            self.emailTextField?.resignFirstResponder()
            self.passwordTextField?.becomeFirstResponder()
        }
        else if (textField == self.passwordTextField)
        {
            self.passwordTextField?.resignFirstResponder()
            self.authenticate()
        }
        
        return true
        
    }

    func authenticate()
    {
        var email = self.emailTextField?.text
        var password = self.passwordTextField?.text
        
        if(email?.isEmpty ==  true || password?.isEmpty  == true || email?.isEmailAddress() == false) //is this an email address
        {
            var alertController = UIAlertController(title: "Uh oh!" , message: "Test", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

            return
        
        }
        
        if authMode == .SignIn
            {
                self.signIn(email!, password:password!)
            }
        else
            {
                self.signUp(email!, password:password!)
            }
    }
    
    func signIn(email: String, password: String)
    {
        PFUser.logInWithUsernameInBackground(email, password: password){
            (user: PFUser?, error:NSError?) -> Void in
            
            if(user != nil)
            {
                println("sign in success!")
            }
            
            else
            {
                println("sign in error (alert the user)")
            }
        }
    }
    
    
    func signUp(email: String, password: String )
    {
       var user = PFUser()
        user.username   = email
        user.email = email
        user.password = password
        
        user.signUpInBackgroundWithBlock{
            (succeeded, error) -> Void in
            if error == nil
            {
                println("sign in success!")
            }
                
            else
            {
                println("sign in error (alert the user)")
            }

        }
        
        
    }

    
}
