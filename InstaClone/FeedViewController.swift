//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 8/25/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource  {

    var items = [ "","","","" ]
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "PostCell", bundle: nil)
        tableView?.dataSource = self
        tableView?.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedInstance.fetchFeed{
            (objects, error) -> () in
                println(objects)
                print(error)
            
            }
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
       
     //    var item = items[indexPath.row] as! PFObject
        
     //  cell.item = item
        
        return cell 
    }
   

}
