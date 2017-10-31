//
//  RecipeTableViewController.swift
//  BBQApp
//
//  Created by Jared Bruemmer on 10/29/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet var recipeTable: UITableView!
    
    var socialRank = [Double]()
    var recipeTitle1 = [String]()
    var recipeURL = [String]()
    var recipeImage1 = [String]()
    
    var searchController: UISearchController!

     override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeTitle1.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipecell", for: indexPath) as! RecipeTableViewCell
        
        

        

        cell.textLabel?.text = recipeTitle1[indexPath.row]
        cell.detailTextLabel?.text = String(socialRank[indexPath.row])
//        cell.imageView?.image = String(recipeImage1[indexPath.row])
        
        return cell
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTable.delegate = self
        recipeTable.dataSource = self
        

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func updateSearchResults(for searchController: UISearchController) {
    if let searchBar = searchController.searchBar.text {
//            let scope = searchBar[searchBar.selectedScopeButtonIndex]
//            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
            let url = URL (string: "http://food2fork.com/api/search?key=6fb8c103dfd7f27b64b5feaf97e65afc&q=pizza")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            var counter = 0
                            while counter < jsonResult["count"]   as! Int {
                                var recipeTitle1 = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["title"] as? String;
                                var socialRank = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["social_rank"] as? Double;
                                var recipeURL = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["f2f_url"] as? String;
                                var recipeImage1 = ((jsonResult["recipes"] as? NSArray)?[counter] as? NSDictionary)?["image_url"] as? String;
                                do {
                                    
                                    print(recipeTitle1)
                                    counter = counter + 1
                                }
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
        
    }
    // MARK: - Table view data source

    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
