//
//  TeamViewController.swift
//  BBQApp
//
//  Created by Jared Bruemmer on 11/30/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
}

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var names = ["Robert Backus", "Jared Bruemmer", "Austin Dotto", "Christopher King", "Michael McLaughlin", "Soya Ouk"]
    var descriptions = ["Over the course of my time here at Mizzou I’ve learned some C, HTML, PHP, MySQL, Bootstrap, and Java. Besides programming I’ve learned to use some other software tools like Maya, Adobe Photoshop, Premiere, and After Effects. I do a lot of sketching and drawing in my free time and I’m interested in doing animation or creating games.", "Throughout my time at Mizzou I have studied several different languages such as C, HTML, PHP, MySQL, Bootstrap, and Javascript. I have also had many classes dealing with animation and design and have come to know the Adobe software quite well. I enjoy being outside and watching basketball or baseball and playing pickup games when I can. I hope to pursue a career in either the effects, networking, or software implementation field.", "While at Mizzou I have taken courses learning many different languages such as Java, C, HTML, PHP and Javascript. My favorite programming language is swift. I have learned how to use Adobe software such as Premiere and After Effects. I am a huge hockey fan. Enjoy disc golfing, music, video games, and being with friends and family.", "Throughout my Mizzou career I have developed many skills including Java, Swift, C#/.NET, HTML, PHP, MongoDB, and AWS. In addition to backend development, I enjoy using AWS and developing on the cloud and plan to pursue it as a career. In my free time I enjoy watching hockey and playing soccer.", "Mizzou has been an amazing experience thus far. I have worked with several programming languages including HTML, Java, C, C#, SQL, JavaScript, PHP and others. I have had 2 internships in the information Technology field. At Barry-Wehmiller Design Group I designed and developed the system infrastructure for 2 production facilities. Also, I wrote a 1500 line MSSQL program that created reports about the machinery, operators, etc.. At Clayco I managed active directories, virtual machines and used a ticket system to help employees with software/computer issues. In my free time I enjoy mountain biking, working out and playing guitar.", "Here at Mizzou I’ve learned several programming languages; C, HTML, CSS, Java, C#, and a little bit of Perl.  Programs that I am also familiar with are Adobe After Effects, Photoshop, and Premier.  When I’m not doing homework or working, I’m usually outdoors on the trails or riding the motorcycle with friends."]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamTable.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! TeamTableViewCell
        let currentName = names[indexPath.row]
        let currentDescription = descriptions[indexPath.row]
        cell.nameLabel?.text = currentName
        cell.imageView?.image = UIImage(named: currentName)
        cell.descriptionTextView.text = currentDescription
        
        return cell
    }
    

    
    @IBOutlet weak var teamTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
