//
//  SettingsViewController.swift
//  BBQApp
//
//  Created by Jared Bruemmer on 10/3/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User has canceled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            if let userDeets = result {
                                print(userDeets)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged Out")
    }
    
//    // Add this to the header of your file, e.g. in ViewController.m
//    // after #import "ViewController.h"
//    #import <FBSDKCoreKit/FBSDKCoreKit.h>
//    #import <FBSDKLoginKit/FBSDKLoginKit.h>
//
//    // Add this to the body
//    @implementation ViewController
//
//    - (void)viewDidLoad {
//    [super viewDidLoad];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
//    }
//
//    @end

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
