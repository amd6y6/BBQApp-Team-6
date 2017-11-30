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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {
   
    //struct to hold the information returned from the facebook API to save recipes in the database
    struct User {
        var useremail : String = ""
        var userid : String = ""
        var username : String = ""
        }
    
    var users : [User] = []
    var newUser : User = User()
    var people: [NSManagedObject] = []
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBAction func registerUser(_ sender: UIButton) {
        
        let random1 = Int(arc4random_uniform(10000))
        let random2 = Int(arc4random_uniform(10000))
        let random3 = Int(arc4random_uniform(10000))
        let random4 = Int(arc4random_uniform(10000))
        let randomId = random1 + random2 + random3 + random4
        
        var newUser : User = User()
        
        if(people.count == 0){
            newUser.username = userNameField.text!
            newUser.useremail = userEmailField.text!
            newUser.userid = randomId.description
            self.users.append(newUser)
            print(users[0].userid,users[0].useremail,users[0].useremail)
            postToServerFunction()
            
            let alert = UIAlertController(title: "Success!", message: "You have successfully logged in", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { ACTION in
            }))
            self.present(alert, animated: true, completion: nil)
            sender.setTitle("Logged in", for: .normal)
        }
        let alert = UIAlertController(title: "Attention!", message: "You are already Logged in.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { ACTION in
        }))
        
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        userEmailField.text = ""
        
    }
    
    var text = ["About this Version", "The Developers", "Terms of Use/Copyrights"]
    var segueID = ["about", "developer", "terms"]
    
    //same concept as on recipe tab, storing all necesary information about the user to the database, gets connection with database and sends error otherwise
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
    
    //save function that performs the actual saving of the information
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
            if (people.count == 0){
            people.append(User)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //display the view when the tab is selected
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        //loginButton.addConstraint(NSLayoutConstraint.)
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        view.addSubview(loginButton)
        fetchUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = text[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID[indexPath.row], sender: self)
        settingsTable.deselectRow(at: indexPath, animated: true)
    }
    
    //delegates what happens when the user clicks on the facebook button
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //postToServerFunction()
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User has canceled login")
        } else {
            if result.grantedPermissions.contains("email") {
               //allows facebook login to open in app rather than taking the user off site to log in
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
    
    //getting the user data from when they log in to be able to save their recipes to their id in the database
    func fetchUserData(){
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
       // let index = people.count
      
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
