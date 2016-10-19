//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/6/3.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroudImageView:UIImageView!
    @IBOutlet var ratingStackView:UIStackView!
    @IBOutlet var dislikeButton:UIButton!
    @IBOutlet var goodButton:UIButton!
    @IBOutlet var greatButton:UIButton!
    
    var rating:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //background effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroudImageView.addSubview(blurEffectView)
        
        //Animation 1. set stack scale to 0.
        //ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        //change stack position
        //ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        //combine two Animation
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
        
        //animation for each button
        dislikeButton.transform = CGAffineTransformConcat(scale, translate)
        goodButton.transform = CGAffineTransformConcat(scale, translate)
        greatButton.transform = CGAffineTransformConcat(scale, translate)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Animation 2. return the stack scale and position
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: []
            , animations: {
                                    
                self.dislikeButton.transform = CGAffineTransformIdentity
                                    
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: []
            , animations: {
                
                self.goodButton.transform = CGAffineTransformIdentity
                
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: []
            , animations: {
                
                self.greatButton.transform = CGAffineTransformIdentity
                
            }, completion: nil)
        
    }
    
    //return selected button info
    @IBAction func ratingSelected(sender: UIButton){
        switch (sender.tag) {
        case 100: rating = "dislike"
        case 200: rating = "good"
        case 300: rating = "great"
        default: break
        }
        
        //to trigger a segue
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
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
