//
//  LocationDetailViewController.swift
//  MapKitIntoLab
//
//  Created by casandra grullon on 2/25/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    public var school: School
    
    init?(coder: NSCoder, school: School) {
        self.school = school
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    private func updateUI() {
        schoolNameLabel.text = school.schoolName
        addressLabel.text = "\(school.primaryAddressLine) \n\(school.borough) \n\(school.city), \(school.state)"
        overViewLabel.text = school.overview
    }

}
