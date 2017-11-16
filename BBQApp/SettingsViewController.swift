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
import CoreData

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    struct User {
        var useremail : String = ""
        var userid : String = ""
        var username : String = ""
        }
    
    var users : [User] = []
    var newUser : User = User()
    var people: [NSManagedObject] = []
    
    func postToServerFunction(){
        let url: NSURL = NSURL(string: "https://mmclaughlin557.com/bbqapp.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        let bodyData = ("data=" + "&id=" + users[0].userid + "&name=" + users[0].username + "&email=" + users[0].useremail)
        //print(bodyData)
        request.httpMethod = "POST"
        save(userid: users[0].userid)
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {
            (response, data, error) in
            print(response)
        }
        if let HTTPResponse = responds as? HTTPURLResponse {
            let statusCode = HTTPResponse.statusCode
            
            if statusCode == 200 {
                print("Status Code 200: connection OK")
            }
        }
        
    }
    
    func save(userid: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "User",
                                       in: managedContext)!
        
        let User = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        User.setValue(userid, forKeyPath: "id")
        
        // 4
        do {
            try managedContext.save()
            people.append(User)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
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
        //postToServerFunction()
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User has canceled login")
        } else {
            if result.grantedPermissions.contains("email") {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                        if error != nil {
                            print(error!)
                        } else {
                            var newUser : User = User()
                            let result = result as? NSDictionary
                            if let useremail = result!["email"] as? String{
                                newUser.useremail = useremail
                                //print(useremail)
                            }
                            if let username = result!["name"] as? String{
                                newUser.username = username
                                //print(username)
                            }
                            if let userid = result!["id"] as? String{
                                newUser.userid = userid
                                //print(userid)
                            }
                            self.users.append(newUser)
                            print(self.users[0])
                            self.postToServerFunction()
                            //if let userDeets = result {
                             //   print(userDeets)
                            //}
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
