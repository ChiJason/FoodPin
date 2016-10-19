//
//  MapViewController.swift
//  FoodPin
//
//  Created by 紀宣志 on 2016/6/13.
//  Copyright © 2016年 JasonChi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView:MKMapView!
    
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self;
        
        //some effect
        self.mapView.showsTraffic = true
        self.mapView.showsCompass = true
        self.mapView.showsTraffic = true

        // Do any additional setup after loading the view.
        //change address to coordinate
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: {
            placemarks, error in
            if error != nil {
              print(error)
                return
            }
            if let placemarks = placemarks {
                //get first coordinate
                let placemark = placemarks[0]
                
                //add info
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //show info
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identitfier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        //如可以的話回收使用這個標註
        var annotationView:MKPinAnnotationView? =
        mapView.dequeueReusableAnnotationViewWithIdentifier(identitfier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identitfier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 053, 53))
        leftIconView.image = UIImage(data: restaurant.image!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        //change color
        annotationView?.pinTintColor = UIColor.greenColor()
        
        
        return annotationView
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
