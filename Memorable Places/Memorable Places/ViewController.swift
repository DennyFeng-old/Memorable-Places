//
//  ViewController.swift
//  Memorable Places
//
//  Created by Denny Feng on 11/21/18.
//  Copyright © 2018 Denny Feng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var Map: MKMapView!
    
    var manager = CLLocationManager()
  
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        Map.addGestureRecognizer(uilpgr)
        
        
        
        if activePlace == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            
        } else{
            
            if places.count > activePlace {
                
                if let name = places[activePlace]["name"] {
                    
                    if let lat = places[activePlace]["lat"] {
                        
                        if let lon = places[activePlace]["lon"] {
                           
                            if let latitude = Double(lat){
                              
                                if let longtitude = Double(lon) {
                                   
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                                    
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.Map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.coordinate = coordinate
                                    
                                    annotation.title = name
                                    
                                    self.Map.addAnnotation(annotation)
                                }
                            }
                        }
                   
                    }
                    
                    
                    
                }
                
            }
            
            
            
            
        }
        
    }
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
        
            let touchPoint = gestureRecognizer.location(in: self.Map)
        
            let newCoordinate = self.Map.convert(touchPoint, toCoordinateFrom: self.Map)
            
            let location  = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
       
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    
                    print(error!)
                } else{
                   
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare! + "\n"
                        }
                    }
                    if title == "" {
                        title = " Added \(NSDate())"
                    }
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = newCoordinate
                    
                    annotation.title = "Temp title"
                    
                    self.Map.addAnnotation(annotation)
                    
                     places.append(["name":title,"lat":String(newCoordinate.latitude),"lon": String(newCoordinate.longitude)])
                    
                       UserDefaults.standard.set(places, forKey: "places")
                }
            }
        
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.Map.setRegion(region, animated: true)
    
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

