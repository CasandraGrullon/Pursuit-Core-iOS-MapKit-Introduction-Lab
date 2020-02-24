//
//  SchoolAPIClient.swift
//  MapKitIntoLab
//
//  Created by casandra grullon on 2/24/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import NetworkHelper

class SchoolAPIClient {
    static func getSchools(completion: @escaping (Result<[School], AppError>) -> ()) {
        let endpointURL = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data) :
                do {
                    let schools = try JSONDecoder().decode([School].self, from: data)
                    completion(.success(schools))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
