//
//  ViewController.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setCustomNavigation(title: Utils.localizedString(forKey: Keys.airportHome, table: nil))
    }
    
    @IBAction func btnAirportLocatorTapped(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ALMapViewController") as? ALMapViewController {
            self.navigationController?.show(vc, sender: nil)
        }
    }
}

