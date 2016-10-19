//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/4/23.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var ratingButton:UIButton!
    
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        restaurantImageView.image = UIImage(data: restaurant.image!)
        
        tableView.backgroundColor = UIColor(red:240.0/255.0, green: 200.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        //remove lines below
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //change color of separatorLines
        tableView.separatorColor = UIColor(red:200.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        title = restaurant.name
        
        //Auto Sizing
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let rating = restaurant.rating where rating != "" {
            ratingButton.setImage(UIImage(named: restaurant.rating!), forState: UIControlState.Normal)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //runs when view is opening
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell"
            , forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        
        //setup Cell
        switch indexPath.row {
            
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            if let isVisited = restaurant.isVisited?.boolValue {
                cell.valueLabel.text = isVisited ? "Yes, I've been here before" : "No"
            }
        case 5:
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.text = restaurant.rating
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        
        return cell
    }
    
    ////unwind segue
    @IBAction func close(segue: UIStoryboardSegue){
        //catch info from reviewViewController
        if let reviewViewController = segue.sourceViewController as?
            ReviewViewController {
            
            if let rating = reviewViewController.rating {
                restaurant.rating = rating
                ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    
                do{
                    try managedObjectContext.save()
                }catch{
                    print(error)
                }
            }
        }
            
            tableView.reloadData()
      }
    }
    
    //Segue Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
