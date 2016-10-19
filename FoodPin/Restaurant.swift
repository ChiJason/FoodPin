//
//  Restaurant.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/5/2.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import Foundation
import CoreData


class Restaurant: NSManagedObject {
    
    @NSManaged var name:String
    @NSManaged var type:String
    @NSManaged var location:String
    @NSManaged var image:NSData?
    @NSManaged var phoneNumber:String?
    @NSManaged var isVisited:NSNumber?
    @NSManaged var rating:String?
    
}