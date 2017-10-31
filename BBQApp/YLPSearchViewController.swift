//  Converted with Swiftify v1.0.6488 - https://objectivec2swift.com/
//
//  YLPSearchTableViewController.m
//  YelpAPI
//
//  Created by David Chen on 3/31/16.
//  Copyright © 2016 Yelp. All rights reserved.
//

import YelpAPI

class YLPSearchTableViewController {
    var search: YLPSearch?
    
    func viewDidLoad() {
        AppDelegate.shared().search(withLocation: "St. Louis, MO", term: nil, limit: 20, offset: 0, categoryFilter: ["bbq"], sort: YLPSortTypeDistance, completionHandler: {(_ search: YLPSearch, _ error: Error?) -> Void in
            self.search = self.search
            DispatchQueue.main.async(execute: {() -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (search?.businesses.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        if indexPath.item > (search?.businesses.count)! {
            cell?.textLabel?.text = ""
        }
        else {
            cell?.textLabel?.text = search?.businesses[indexPath.item].name
        }
        return cell ?? UITableViewCell()
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard.instantiateViewController(withIdentifier: "YLPDetailBusinessViewController") as? YLPDetailBusinessViewController
        vc.business = search?.businesses[indexPath.item]
        //navigationController?.pushViewController(vc as? UIViewController ?? UIViewController(), animated: true)
    } */
}
