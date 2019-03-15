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

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var reyn:MKPolygon? = nil
    
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    
    let regionRadius: CLLocationDistance = 1100
    let initialLocation = CLLocation(latitude: 43.53076529, longitude: -80.22899687)
    let centreMapLocation = CLLocation(latitude: 43.531108, longitude: -80.226450)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Prefer larger title in navbar
        self.title = "GryphNav"
       
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = optionsButton
        
        //Setting up search and location...
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search UofG Locations"
        self.navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView //Passes along the handle for the mapview to locationsearchtable
        
        //Setting up location stuff...
        centerMapOnLocation(location: centreMapLocation)
        requestLocationAccess()
        mapView.delegate = self as MKMapViewDelegate
        mapView?.showsUserLocation = true
        //mapView?.addOverlay(<#T##overlay: MKOverlay##MKOverlay#>)
        addPolygon()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        searchBar.resignFirstResponder()
//    }
    
    func searchBarIsEmpty() -> Bool {
            return resultSearchController?.searchBar.text?.isEmpty ?? true
    }
    
    func addPolygon() {
        var points = [CLLocationCoordinate2DMake(43.53094030858364, -80.22913634777069),
                      CLLocationCoordinate2DMake(43.53087419186293, -80.2292275428772),
                      CLLocationCoordinate2DMake(43.53082168735662, -80.22916316986084),
                      CLLocationCoordinate2DMake(43.53075557050586, -80.2292463183403),
                      CLLocationCoordinate2DMake(43.53066806279785, -80.22913366556166),
                      CLLocationCoordinate2DMake(43.53064278276968, -80.22916585206985),
                      CLLocationCoordinate2DMake(43.5306116688743, -80.22911757230759),
                      CLLocationCoordinate2DMake(43.53082363196877, -80.22882521152496),
                      CLLocationCoordinate2DMake(43.53095586544857, -80.22901564836502),
                      CLLocationCoordinate2DMake(43.53090919484174, -80.22908538579941),
                      CLLocationCoordinate2DMake(43.53094030858364, -80.22913634777069)]
        reyn = MKPolygon(coordinates: &points, count: points.count)
        
        mapView.addOverlay(reyn!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-80.22917121648788,
    //43.5308994717941
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polygonView = MKPolygonRenderer(overlay: overlay)
        polygonView.fillColor = UIColor(red: 0, green: 0.847, blue: 1, alpha: 0.25)
            
        return polygonView
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
    
    
    
    //Options button handling
    @IBAction func optionsButtonPressed(_ sender: UIBarButtonItem) {
        //print("Options pressed!")
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

