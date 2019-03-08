//
//  OptionsViewController.swift
//  GryphNav
//
//  Created by Robert Saunders on 2019-03-07.
//  Copyright © 2019 Robert Saunders. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    
    
    var optionsList:[String] = ["About", "Navigation Preferences"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    //Here be required functions to conform to constraints...
//    //********************************************************************************************************************************************
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
