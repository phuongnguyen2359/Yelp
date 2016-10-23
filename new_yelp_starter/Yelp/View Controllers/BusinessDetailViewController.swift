//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Pj Nguyen on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking
import MapKit

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {
    
    var business:Business!
    var nameRes:String!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var nameRestaurant: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewCountLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameRestaurant.text = business.name
        resImage.setImageWith(business.imageURL!)
        distanceLable.text = business.address
        ratingImage.setImageWith(business.ratingImageURL!)
        reviewCountLable.text = "\(business.reviewCount!) reviews"
        addressLable.text = business.distance
        initMapView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showDirection(_ sender: AnyObject) {
        
        print("show directions click")
        // create MK Driection request
        drawPolyLine()
        
        
    }
    
    
    
    func drawPolyLine() {
        
        print("draw poly line")
        // Connect all the mappoints using Poly line.
        
        let myLocation = CLLocationCoordinate2DMake(37.785771, -122.406165)
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(myLocation)
        let resLoacation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(business.latitude!, business.longitude!)
        points.append(resLoacation)
        let polyLine = MKPolyline(coordinates: points, count: points.count)
        mapView.add(polyLine, level: MKOverlayLevel.aboveRoads)
        initMapView()
    }
    
    func initMapView() {
        mapView.delegate = self
        let latitude:Double = business.latitude!
        let longitude:Double = business.longitude!
        let latitudeDelta:CLLocationDegrees = 0.01
        let longtitudeDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longtitudeDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = business.name
        annotation.subtitle = business.categories
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    // render poly line overlay
    @objc(mapView:rendererForOverlay:) func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    
    
}






