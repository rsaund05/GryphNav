//
//  LocationSearchViewController.swift
//  GryphNav
//
//  Created by Robert Saunders on 2019-03-12.
//  Copyright © 2019 Robert Saunders. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable: UITableViewController, UISearchResultsUpdating{
    var mapView: MKMapView? = nil
    var matchingItems:[MKMapView] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
    }
    
    
}
