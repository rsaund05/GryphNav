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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Prefer larger title in navbar
        self.title = "GryphNav"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsMenu))
        self.navigationItem.rightBarButtonItem = optionsButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIBarButtonItem) {
        print("Options pressed!")
    }
    
    @objc func optionsMenu(){
        
    }
    
}

