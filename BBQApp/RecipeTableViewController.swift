//
//  RecipeTableViewController.swift
//  BBQApp
//
//  Created by Jared Bruemmer on 10/29/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit
import WebKit
import CoreData


class RecipeTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    //creates a struct to hold the information returned from the Food2Fork API
    struct Recipe {
        var title : String = ""
        var socialRank : String = ""
        var image : UIImage? = nil
        var imageString : String = ""
        var url : String = ""
    }
    //segment control for recipes and favorited recipes
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //delegates which table view to display
    private func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Search", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Favorites", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    var recipes : [Recipe] = []
    
    @IBOutlet var recipeTable: UITableView!
    
    //other variables to determine what user is doing on the app
    var yourSearch = "BBQ"
    var searchActive : Bool = false
    var selectedItem : Int = 0
    var userId : String = ""
    var people: [NSManagedObject] = []

    
    let searchController = UISearchController(searchResultsController: nil)
    
    //setting up the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeTable.dequeueReusableCell(withIdentifier: "recipecell", for: indexPath)
        var title : String
        guard indexPath.row >= 0 && indexPath.row < recipes.count else {return cell}
        title = recipes[indexPath.row].title
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = "Rating: " + (recipes[indexPath.row].socialRank)

        return cell
    }
    
    //display correct view based on segment control option selected
    private func setupView(){
        setupSegmentedControl()
        updateView()
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        doSomethingWithItem(index: indexPath.row)
    }
    
    //sends favorited recipe to database
    func doSomethingWithItem(index: Int ){
        postToServerFunction(index: index)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) -> Int  {
        selectedItem = indexPath.row
        //print(selectedItem)
        return selectedItem
    }
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(uiView: UIView) {
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = uiView.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(indicator)
        indicator.startAnimating()
    }
    //update the search results based on users search
    private func updateView() {
        showActivityIndicator(uiView: view)
        if (userId == ""){
            fetchUserData()
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            updateSearchResults(for: searchController)
            
        } else {
            //print("Favorite recipes clicked")
            if(userId == ""){
                let alert = UIAlertController(title: "Attention!", message: "You must be logged in to access your favorite recipes", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { ACTION in
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.updateSearchResults(for: self.searchController)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            recipes.removeAll()
            self.tableView.reloadData()
            if (userId != ""){
            fetchUsersFavorites()
            }else {
                fetchUserData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
  
    }
    
    //provides either a delete or favorite option when cell is slid to the left
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if segmentedControl.selectedSegmentIndex == 1 {
        return "Delete"
        }
        else {
            return "Favorite"
        }
    }

    //actually removes the cell from the table view if favorited and selected to unfavorite
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 1 {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            unfavoriteRecipe(index: indexPath.row)
            self.recipes.remove(at: indexPath.row)
            self.recipeTable.reloadData()
        }
        } else
        {
            doSomethingWithItem(index: indexPath.row)
        }
    }
    
    //action of unfavoriting the recipe from the database
    func unfavoriteRecipe(index: Int){
        let doDelete = 1
        let url: NSURL = NSURL(string: "https://mmclaughlin557.com/bbqapp.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        let string1 = ("recipedata=" + "&id=" + userId + "&recipeurl=" + recipes[index].url + "&delete=" + (doDelete.description))
        //let string2 =  ("&title=" + recipes[index].title + "&socialrank=" + (recipes[index].socialRank.description))
        let bodyData = string1
        print(bodyData)
        request.httpMethod = "POST"
        //save(userid: users[0].userid)
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
    
    //fetching the users favorites from the database
    func fetchUsersFavorites(){
        
        let URL_GET_FAVORITES:String = "https://mmclaughlin557.com/getRecipes.php"
        //created NSURL
        let requestURL = NSURL(string: URL_GET_FAVORITES)
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        //setting the method to post
        request.httpMethod = "POST"
        let bodyData = "data=&userid=" + userId
        //print(bodyData)
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //creating a task to send the post request
        //NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            //exiting if there is some error
            if error != nil{
                print("error is \(error)")
                return;
            }
            //parsing the response
            do {
                //converting resonse to NSDictionary
                var RecipeJSON: NSDictionary!
                RecipeJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
             
                //getting the JSON array teams from the response
                let favoriteRecipes: NSArray = RecipeJSON["recipes"] as! NSArray
                print(favoriteRecipes.description)
                print("Recipes returned ", favoriteRecipes.count)
                self.recipes.removeAll()
                var counter = 0
                while counter < favoriteRecipes.count{
                    var newRecipe : Recipe = Recipe()
                    print(counter)
                
                    //getting the data at each index
                    if let RecipeUrl = ((RecipeJSON["recipes"] as? NSArray)?[counter] as? NSDictionary)?["RecipeURL"] as? String
                    {
                    newRecipe.url = RecipeUrl
                    }
                    if let RecipeTitle = ((RecipeJSON["recipes"] as? NSArray)?[counter] as? NSDictionary)?["Title"] as? String
                    {
                    newRecipe.title = RecipeTitle
                    }
                    if let RecipeRank = ((RecipeJSON["recipes"] as? NSArray)?[counter] as? NSDictionary)?["SocialRank"] as? String {
                    newRecipe.socialRank = RecipeRank
                    }

                    self.recipes.append(newRecipe)
                    counter = counter + 1
                }
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.recipeTable.reloadData()
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
        
    }
    
    //displaying the view to appear on initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        recipeTable.delegate = self
        recipeTable.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.delegate = self as? UISearchControllerDelegate
        fetchUserData()
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
        
        let index = people.count
        if (index != 0){
        let person = people[index - 1]
        userId = (person.value(forKeyPath: "id") as? String)!
        } else {
            userId = ""
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //search bar delegation
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("search active = true")
        searchActive = true
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("search active = false")
        searchActive = false
        updateSearchResults(for: searchController)
        showActivityIndicator(uiView: view)
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard self.searchActive == false else {return}
        print("update search results called")
        if searchController.searchBar.text == "" {
            apiSearch("BBQ")
        } else {
        yourSearch = searchController.searchBar.text!
        apiSearch(yourSearch)
        }
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Food2Fork API call
    func apiSearch( _:String) {
    
        let url = URL (string: "http://food2fork.com/api/search?key=6fb8c103dfd7f27b64b5feaf97e65afc&q=" + yourSearch.replacingOccurrences(of: " ", with: "%20") )!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        var counter = 0
                        self.recipes.removeAll()
                        while counter < jsonResult["count"] as! Int {
                            var newRecipe : Recipe = Recipe()
                            if let title1 = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["title"] as? String {
                                newRecipe.title = title1
                            }
                            if let rank = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["social_rank"] as? Double {
                                newRecipe.socialRank = String (format: "%.2f",rank)
                            }
                            if let path = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["f2f_url"] as? String {
                                newRecipe.url = path
                            }
                            if let image = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["image_url"] as? String {
                                newRecipe.image = UIImage(data: image.data(using: String.Encoding.utf8)!)
                            }
                            self.recipes.append(newRecipe)
                            
                            counter = counter + 1
                        }
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.recipeTable.reloadData()
                        }
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        
        
        task.resume()
        self.tableView.reloadData()
    }
    
    //saves all necessary data to the database, gets connection with database and sends error otherwise
    func postToServerFunction(index: Int){
        let url: NSURL = NSURL(string: "https://mmclaughlin557.com/bbqapp.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        let string1 = ("recipedata=" + "&id=" + userId + "&recipeurl=" + recipes[index].url)
        let string2 =  ("&title=" + recipes[index].title + "&socialrank=" + (recipes[index].socialRank))
        let bodyData = (string1 + string2).replacingOccurrences(of: "'", with: " ")
        //print(bodyData)
        request.httpMethod = "POST"
        //save(userid: users[0].userid)
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
    
    //send the user to appropriate webview based on the title selected from the tableview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipesegue" {
            let nextScene = segue.destination as? RecipeWebView
            if let selectedItem = tableView.indexPathForSelectedRow?.row {
                nextScene?.website = (recipes[selectedItem].url)
            }
        }
    }
    
}


