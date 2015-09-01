//
//  PersonCell.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 9/1/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    var user: PFUser?
    {
        didSet
        {
          self.configure()
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure()
    {
        if let constUser = user
        {
         self.textLabel?.text = constUser.username
        }
    }
    
}
