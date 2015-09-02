//
//  PersonCell.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 9/1/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
     @IBOutlet var followButton: UIButton?
    
    var isFollowing: Bool?

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
        self.followButton?.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.isFollowing = false
        self.followButton?.hidden = true
        self.textLabel?.text = ""
        self.user = nil
    }
    
    
    
    func configure()
    {
        if let constUser = user
        {
            self.textLabel?.text = constUser.username
            
            // are we following this person?
            
            NetworkManager.sharedInstance.isFollowing(constUser, completionHandler: {
                (isFollowing, error) -> () in
                
                if let constError = error
                {
                    // Alert the user, or otherwise modify the UI
                }
                else
                {
                    self.isFollowing = isFollowing
                    
                    if isFollowing == true
                    {
                        var image = UIImage(named: "UnfollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    }
                    else
                    {
                        var image = UIImage(named: "FollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    }
                    
                    self.followButton?.hidden = false
                }
                
            })
        }
    }
    
    
    
    @IBAction func didTapFollow(sender: UIButton)
    {
        self.followButton?.enabled = false
        
        var newValue = !(self.isFollowing == true)
        NetworkManager.sharedInstance.updateFollowValue(newValue, user: self.user!) { (error) -> () in
            
            self.followButton?.enabled = true
            
            var image = (newValue == true) ? UIImage(named: "UnfollowButton") : UIImage(named: "FollowButton")
            self.followButton?.setImage(image, forState: .Normal)
            
            self.isFollowing = newValue
        }
    }
    
    
    
}
