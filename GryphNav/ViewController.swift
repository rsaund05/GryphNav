//
//  ViewController.swift
//  GryphNav
//
//  Created by Robert Saunders on 2019-02-07.
//  Copyright © 2019 Robert Saunders. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 210
    let initialLocation = CLLocation(latitude: 43.53076529, longitude: -80.22899687)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Prefer larger title in navbar
        self.title = "GryphNav"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = optionsButton
        
        //Setting up location stuff...
        centerMapOnLocation(location: initialLocation)
        requestLocationAccess()
        mapView.delegate = self as MKMapViewDelegate
        mapView?.showsUserLocation = true
        //mapView?.addOverlay(<#T##overlay: MKOverlay##MKOverlay#>)
    }
    
    //Function for requesting location access
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIBarButtonItem) {
        print("Options pressed!")
        performSegue(withIdentifier: "Options", sender: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
//    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
//        <#code#>
//    }
}

