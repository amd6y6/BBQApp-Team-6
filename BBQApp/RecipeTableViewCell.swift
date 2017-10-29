//
//  RecipeTableViewCell.swift
//  BBQApp
//
//  Created by Jared Bruemmer on 10/29/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {    
    
    @IBOutlet weak var recipeRank: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func prepareForReuse() {
        recipeImage.image = nil
        recipeTitle.text = nil
        recipeRank.text = nil
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
