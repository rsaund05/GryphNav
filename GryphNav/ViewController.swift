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
import Foundation

protocol HandleMapSearch{
    func dropPinZoomIn(placemark: MKPlacemark)
}

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            mapView.removeAnnotations(mapView.annotations)
            let locationTap = sender.location(in: mapView)
            let tapCoordinate = mapView.convert(locationTap, toCoordinateFrom: mapView)
           
            //Since Apple doesnt expose the points of interest to developers in the API, I'm resorting to simply navigating to a generic annotation where the user taps, sorry Dennis!
            let annotation = MKPointAnnotation()
            annotation.coordinate = tapCoordinate
            mapView.addAnnotation(annotation)
            
        }
    }
    //var matchingItems:[MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    
    var reyn:MKPolygon? = nil
    
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    
    let regionRadius: CLLocationDistance = 1100
    let initialLocation = CLLocation(latitude: 43.53076529, longitude: -80.22899687)
    let centreMapLocation = CLLocationCoordinate2D(latitude: 43.531108, longitude: -80.226450)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checks if user has launched the app before, and if not, displays a welcome message
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            let testAlert = UIAlertController(title: "Welcome to GryphNav!", message: "Search for a building or location on the University of Guelph campus.", preferredStyle: .alert)
            testAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(testAlert, animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        //Prefer larger title in navbar
        self.title = "GryphNav"
       
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = optionsButton
        
        //Setting up search and location...
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationTableViewController") as! LocationTableViewController
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
        locationSearchTable.handleMapSearchDelegate = self
        
        //Setting up location stuff...
        centerMapOnLocation(location: centreMapLocation)
        requestLocationAccess()
        locationManager.startUpdatingLocation()
        mapView.delegate = self as MKMapViewDelegate
        mapView?.showsUserLocation = true
        
        //addPolygon()
    }
    
    
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
    
    //Function for requesting a route from Apple Maps and overlaying that on the mapView
    //Routes are drawn with start and end annotations
    func showRouteOnMap(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlace = MKPlacemark(coordinate: startCoordinate)
        let destinationPlace = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceMI = MKMapItem(placemark: sourcePlace)
        let destinationMI = MKMapItem(placemark: destinationPlace)
        
        let sourceAnn = MKPointAnnotation()
        
        //Unwrapping the conditional
        if let location = sourcePlace.location {
            sourceAnn.coordinate = location.coordinate
        }
        
        let destinationAnn = MKPointAnnotation()
        
        //Unwrapping the conditional
        if let location = destinationPlace.location {
            destinationAnn.coordinate = location.coordinate
        }
        
        //Set the annotations
        self.mapView.showAnnotations([sourceAnn, destinationAnn], animated: true)
        
        let directionRequest = MKDirections.Request()
        
        //Setting up the directionRequest
        directionRequest.source = sourceMI
        directionRequest.destination = destinationMI
        directionRequest.transportType = .walking
        
        //Calculate the actual directions now
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    let alert = UIAlertController(title: "Error occurred while getting directions: \(error)", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            
            var tempReg = MKCoordinateRegion(rect)
            tempReg.span.latitudeDelta = 0.007
            tempReg.span.longitudeDelta = 0.007
            self.mapView.setRegion(tempReg, animated: true)
        }
    }
    
    //-80.22917121648788,
    //43.5308994717941
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineView = MKPolylineRenderer(overlay: overlay)
        //polygonView.fillColor = UIColor(red: 0, green: 0.847, blue: 1, alpha: 0.25)
        polylineView.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        polylineView.lineWidth = 5.0
        return polylineView
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
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Warning will display if application fails to retrieve location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Error Occurred", message: "Failed to retrieve location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ViewController: HandleMapSearch{
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        
        if let city = placemark.locality,
            let province = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(province)"
        }
        //print("MY LOCATION: \(self.locationManager.location!.coordinate)\nDESTINATION: \(placemark.coordinate)")
        let currLocation = self.locationManager.location!.coordinate
        let destLocation = placemark.coordinate
        mapView.addAnnotation(annotation)
        let curLoc: CLGeocoder = CLGeocoder()
        curLoc.reverseGeocodeLocation(self.locationManager.location!, completionHandler:{(placemarks, error) in
            if(error != nil){
                print("Reverse geocoding failed! ErrorCode: \(error!.localizedDescription)")
            }
            let loc = placemarks! as [CLPlacemark]
            if(loc.count > 0) {
                let loc = placemarks![0]
                if(loc.locality == "Guelph"){
                    print("User is in Guelph!")
                     self.showRouteOnMap(startCoordinate: currLocation, destinationCoordinate: destLocation)
                } else {
                    //Alert the user that they need to be in guelph
                    let alert = UIAlertController(title: "Oh no! You're not in Guelph!", message: "Routes will only be displayed if you are in Guelph", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        })
        //print("MY LOCATION: \(self.locationManager.location!.)")
//        let span = MKCoordinateSpan(latitudeDelta: 0.0045, longitudeDelta: 0.0045)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
    }
}

