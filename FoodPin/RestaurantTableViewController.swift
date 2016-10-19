//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/3/28.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants:[Restaurant] = []
    var fetchResultController:NSFetchedResultsController!
    var searchController:UISearchController!
    var searchResults:[Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //remove BackBar text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Auto sizing
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ////get data by using CoreData with NSFetchedResultsController
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects as! [Restaurant]
            }catch{
                print(error)
            }
        }
        
        ////adding searching bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search restaurant..."
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //runs when view is opening
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active {
            return searchResults.count
        }else{
            return restaurants.count
        }
    }

    /////creating tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as!
        RestaurantTableViewCell
        
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]

        //setup cells
        cell.nameLabel.text = restaurant.name
        cell.thumbnailImageView?.image = UIImage(data:restaurant.image!)
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        //change ImageView to Circle
        /*
        cell.thumbnailImageView?.layer.cornerRadius = 30.0
        cell.thumbnailImageView?.clipsToBounds = true
        */
        
        /////bug-fix for repeated selection
        if let isVisited = restaurant.isVisited?.boolValue {
            cell.accessoryType = isVisited ? .Checkmark : .None
        }
        return cell
    }
    
    
//    ////////Actions when clicked TableView
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        //create a optionMenu -> AlertController
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .ActionSheet)
//        
//        //create an Action to AlertController
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//        
//        ////create Call Action
//        let callActinoHandler = { (action: UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Uavailable",
//                                                 message: "Sorry, the call feature is not available yet. Please retry later", preferredStyle: .Alert)
//            
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertMessage, animated: true, completion: nil)
//        }
//        
//        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)",
//                                       style: UIAlertActionStyle.Default, handler: callActinoHandler)
//        
//        optionMenu.addAction(callAction)
//        
//        ////create a hint Action
//        if restaurantIsVisited[indexPath.row]{
//            
//            let isVisitedAction = UIAlertAction(title: "I've not been here", style: .Default,
//                                                handler: {
//                                                    (action: UIAlertAction) -> Void in
//                                                    
//                                                    let cell = tableView.cellForRowAtIndexPath(indexPath)
//                                                    cell?.accessoryType = .None
//                                                    self.restaurantIsVisited[indexPath.row] = false
//                                                })
//            
//            optionMenu.addAction(isVisitedAction)
//            
//        }else{
//            
//            let isVisitedAction = UIAlertAction(title: "I've been here", style: .Default,
//                                                handler: {
//                                                    (action: UIAlertAction) -> Void in
//                                                    
//                                                    let cell = tableView.cellForRowAtIndexPath(indexPath)
//                                                    cell?.accessoryType = .Checkmark
//                                                    self.restaurantIsVisited[indexPath.row] = true
//                                                })
//            
//            optionMenu.addAction(isVisitedAction)
//        }
//        
//        
//
//        //show Menu
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        
//        ////cancel selected cell
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//        
//    }
    
    //////slide to delete function
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            restaurants.removeAtIndex(indexPath.row)
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    
    ////close function when searchController is active
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if searchController.active {
            return false
        }else{
            return true
        }
    }
    
    ///////More Actions for Row
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        /////share button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: {(action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
            if let imagesToShare = UIImage(data: self.restaurants[indexPath.row].image!) {
            let activityController = UIActivityViewController(activityItems: [defaultText, imagesToShare], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
        
        ///////delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default , title: "Delete", handler: {(action, indexPath) -> Void in
            
            ///delete from database
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                managedObjectContext.deleteObject(restaurantToDelete)
                
                do{
                    try managedObjectContext.save()
                }catch{
                    print(error)
                }
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    ////Segue Method: send information to other scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                
                destinationController.restaurant = (searchController.active) ?
                    searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
        
    }
    
    ////Segue unwind
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue){
        
    }
    
    
    
    ////////////NSFetchedRequesltsControllerDelegate functions
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    /////////function for searching bar
    func filterContnetForSearchText(searchText: String) {
        
        searchResults = restaurants.filter({ (restaurant:Restaurant) -> Bool in
            
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return nameMatch != nil || locationMatch != nil
            
            })
        
    }
    
    ///////updating searching bar
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContnetForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    
    
    
}



