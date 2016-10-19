//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/8/24.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageIamges = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var pageContent = ["Pin your favourite restaurants and create your own food guide",
                       "Search and locate your favourite restaurant on Maps",
                       "Find restaurants pinned by your friends and other foodies around  the world"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //set dataSource to self
        dataSource = self
        
        //create first view
        if let startingViewController = viewControllerAtIndex(0){
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        //create new viewController and its data
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthrouhghContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewController.imageFile = pageIamges[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
}









