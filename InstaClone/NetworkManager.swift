//
//  NetworkManager.swift
//  InstaClone
//
//  Created by Cassio Kawakita on 8/25/15.
//  Copyright (c) 2015 Cassio Kawakita. All rights reserved.
//

import Foundation

typealias ErrorCompletionHandler = (error: NSError?) -> ()
typealias ObjectsCompletionHandler = (objects: [AnyObject]!, error: NSError?) -> ()
typealias ImageCompletionHandler = (image: UIImage?, error: NSError?) -> ()
typealias BooleanCompletionHandler = (isFollowing: Bool?, error: NSError?) -> ()

public class NetworkManager
{
    public class var sharedInstance:  NetworkManager
    {
        struct Singleton
        {
            static let instance = NetworkManager()
        }
        
        return Singleton.instance
    
    }
    
    
    
    func follow(user: PFUser!, completionHandler:(error: NSError?)-> () )
    {
        var relation = PFUser.currentUser()?.relationForKey("following")
        relation?.addObject(user)
        PFUser.currentUser()?.saveInBackgroundWithBlock{
            (success,error) -> Void in
            
            completionHandler(error: error)
        }
    }
    
    
    
    func fetchFeed(completionHandler: ObjectsCompletionHandler!)
    {
        var relation = PFUser.currentUser()!.relationForKey("following")
        var query = relation.query()
        query!.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            
            if (error != nil)
            {
                println("error fetching following")
                
                completionHandler(objects: nil, error: error!)
            }
            else
            {
                var postQuery = PFQuery(className: "Post")
                postQuery.whereKey("User", containedIn: objects!)
                postQuery.orderByDescending("createdAt")
                postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if (error != nil) {
                        println("error fetching feed posts")
                        completionHandler(objects: nil, error: error)
                    } else {
                        println("Success fetching feed posts \(objects)")
                        completionHandler(objects: objects!, error: nil)
                    }
                    
                })
            }
            
        }
    }
    
    
    
    func fetchImage(post: PFObject, completionHandler: ImageCompletionHandler)
    {
        var imageReference = post["Image"] as? PFFile
        imageReference?.getDataInBackgroundWithBlock{
                (data, error) -> Void in
                
                if (error != nil)
                {
                    println("Error fetching image \(error!.localizedDescription)")
                    completionHandler(image: nil, error: error)
                }
                else
                {
                    println(" we downloaded the image")
                    let image = UIImage(data: data!)
                    completionHandler(image:image, error: nil)
                }
            }
        }
    
    
    func findUsers(searchTerm: String!, completionHandler: ObjectsCompletionHandler!)
    {
        var query = PFUser.query()
        query!.whereKey("username", containsString: searchTerm)
        
        var descriptor = NSSortDescriptor(key: "username", ascending: false)
        query!.orderBySortDescriptor(descriptor)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error != nil)
            {
                println("Error search for users")
                completionHandler(objects: nil, error: error)
            }
            else
            {
                completionHandler(objects: objects, error: nil)
            }
            
        }
        
    }
    
    
    
    func isFollowing(user: PFUser!, completionHandler: BooleanCompletionHandler)
    {
        var relation = PFUser.currentUser()!.relationForKey("following")
        var query = relation.query()
        query!.whereKey("username", equalTo: user.username!)
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error != nil
            {
                println("error determining if currentuser follows other user")
                completionHandler(isFollowing: false, error: error)
            }
            else
            {
                //println(objects)
                var isFollowing = objects!.count > 0
                completionHandler(isFollowing: isFollowing, error: nil)
            }
            
        }
    }
    
    
    func updateFollowValue(value: Bool, user: PFUser!, completionHandler: ErrorCompletionHandler)
    {
        var relation = PFUser.currentUser()!.relationForKey("following")
        
        if (value == true)
        {
            relation.addObject(user)
        }
        else
        {
            relation.removeObject(user)
        }
        
        PFUser.currentUser()!.saveInBackgroundWithBlock {
            (success, error) -> Void in
            
            if error != nil
            {
                println("Error following/unfollowing user")
                
            }
            
            completionHandler(error: error)
        }
    }
    
    
    func fetchPosts(user: PFUser, completionHandler: ObjectsCompletionHandler)
    {
        var postQuery = PFQuery(className: "Post")
        postQuery.whereKey("User", equalTo: user)
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if (error != nil)
            {
                println("error fetching feed posts)")
                completionHandler(objects: nil, error: error!)
            }
            else
            {
                completionHandler(objects: objects!, error: nil)
            }
            
        })
    }
    
    
    func postImage(image: UIImage, completionHandler: ErrorCompletionHandler?)
    {
        var imageData = UIImagePNGRepresentation(image) // returns NSData
        var imageFile = PFFile(name: "image.png", data: imageData)
        
        var post = PFObject(className: "Post")
        post["Image"] = imageFile
        post["User"] = PFUser.currentUser()
        
        post.saveInBackgroundWithBlock {
            (success, error) -> Void in
            
            if let constError = error
            {
                println("Error uploading post object")
            }
            
            if let constCompletionHandler = completionHandler
            {
                constCompletionHandler(error: error)
            }
            
        }
    }
    
    

    
}
    
    
    


