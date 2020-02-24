//
//  School.swift
//  MapKitIntoLab
//
//  Created by casandra grullon on 2/24/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct School: Codable {
    let schoolName: String
    let primaryAddressLine: String
    let city: String
    let zip: String
    let state: String
    let borough: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case primaryAddressLine = "primary_address_line_1"
        case city
        case zip
        case state = "state_code"
        case borough
        case latitude
        case longitude
    }
}
