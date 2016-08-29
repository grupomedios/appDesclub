//
//  WarrantyHomeViewController.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 25/8/16.
//  Copyright © 2016 Grupo Medios. All rights reserved.
//

import Foundation

class WarrantyHomeViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnStart: UIButton!
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLayouts()
    }
    
    func configLayouts() {
        
        self.lblTitle.layer.cornerRadius = 10.0
        self.lblDescription.layer.cornerRadius = 10.0
        self.btnStart.layer.cornerRadius = 10.0
        
        self.lblTitle.font = UIFont(name: "OpenSans-Bold", size: 36.0)
        self.lblDescription.font = UIFont(name: "OpenSans-Bold", size: 14.0)
        self.btnStart.titleLabel?.font = UIFont(name: "OpenSans-ExtraBold", size: 14.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalitycUtil.trackScreenName("analytics.screen.warranty")

    }
    
    @IBAction func closeWarranty(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}