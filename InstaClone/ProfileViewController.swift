//
//  ProfileViewController.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 9/2/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {

    var items = []
    var user: PFUser?
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "PostCell" , bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
        
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedInstance.fetchPosts(self.user!, completionHandler: { (objects, error) -> () in
            
            if let constError = error
            {
                // Show alert user
            }
            else
            {
                self.items = objects!
                self.tableView?.reloadData()
            }
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCellIdentifier") as! PostCell
        var item =  items[indexPath.row] as! PFObject
        
        cell.post = item
        return cell
    }
    
}
