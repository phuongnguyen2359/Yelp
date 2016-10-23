//
//  MapViewController.swift
//  Yelp
//
//  Created by Pj Nguyen on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var searchTerm:String? = nil
    var businesses:[Business]!
    var numRes:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                
            }
        }
        initMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onBack(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func initMapView() {
        mapView.delegate = self
        
        for busines in businesses {
            let latitude:Double = busines.latitude!
            let longitude:Double = busines.longitude!
            let latitudeDelta:CLLocationDegrees = 0.01
            let longtitudeDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longtitudeDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.title = busines.name
            annotation.subtitle = busines.categories
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
    }
}



extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        for b in businesses{
            imageView.setImageWith((b.imageURL)!)
        }
        annotationView?.leftCalloutAccessoryView = imageView
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    
    // Handel action click annatation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKBusiness{
            let business = annotation.business
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "detailVC") as! BusinessDetailViewController
            detailVC.business = business
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}



