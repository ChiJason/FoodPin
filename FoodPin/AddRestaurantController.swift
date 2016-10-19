//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/6/20.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var phoneNumberTextField:UITextField!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    var isVisited:Bool = true
    
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    ////calls when photo is selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        leadingConstraint.active = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        trailingConstraint.active = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        topConstraint.active = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        bottomConstraint.active = true
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///////saving data
    @IBAction func saveData(){
        
        if nameTextField.text == "" {
            print("Name: no input")
        }
        if typeTextField.text == "" {
            print("Type: no input")
        }
        if locationTextField.text == "" {
            print("Location: no input")
        }
        if phoneNumberTextField.text == "" {
            print("PhoneNumber: no input")
        }
        else{
            ///get managedObjectContext from AppDelegate
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
                
                restaurant.name = nameTextField.text!
                restaurant.type = typeTextField.text!
                restaurant.location = locationTextField.text!
                restaurant.phoneNumber = phoneNumberTextField.text!
                
                if let restaurantImage = imageView.image {
                    restaurant.image = UIImagePNGRepresentation(restaurantImage)
                }
                
                restaurant.isVisited = isVisited
                
                /////save context to database
                do{
                    try managedObjectContext.save()
                }catch{
                    print(error)
                    return
                }
            }
            
            ///unwind when finished
            performSegueWithIdentifier("unwindToHomeScreen", sender: self)
        }
            
    }
    
    @IBAction func toggleBeenHereButton(sender: UIButton){
        
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor.redColor()
            noButton.backgroundColor = UIColor.grayColor()
        }else if sender == noButton {
            isVisited = false
            noButton.backgroundColor = UIColor.redColor()
            yesButton.backgroundColor = UIColor.grayColor()
        }
    }
    
    
    
    
}
