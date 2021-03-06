//
//  AgeOfEmpiresService.swift
//  AgeOfEmpiresInfo
//
//  Created by user on 26/05/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//  https://age-of-empires-2-api.herokuapp.com/docs/

import Foundation

protocol AgeOfEmpiresService {
    typealias CivilizationsCompletion = ([Civilization]?, Error?) -> Void
    typealias ProgressCompletion = (Double) -> Void
    
    static func getCivilizations(
        completion: @escaping CivilizationsCompletion,
        progressCompletion: @escaping ProgressCompletion
    )
}

final class AgeOfEmpiresServiceImp: AgeOfEmpiresService {
    
    private static var observation: NSKeyValueObservation?
    
    enum Endpoints {
        static let base = "https://age-of-empires-2-api.herokuapp.com/api/v1"
        
        case civilizations
        
        var stringValue: String {
            switch self {
            case .civilizations: return Endpoints.base + "/civilizations"
            }
        }
    }
    
    static func getCivilizations(
        completion: @escaping CivilizationsCompletion,
        progressCompletion: @escaping ProgressCompletion
        ) {
        taskForGETRequest(url: Endpoints.civilizations.stringValue, responseType: СivilizationList.self, completion:  { (response, error) in
            
            if let error = error {
                completion([], error)
            }
            
            guard let response = response else { return }
            completion(response.civilizations, nil)
            
        }, progressCompletion: { (progress) in
            progressCompletion(progress)
        })
    }
    
    private static func taskForGETRequest<ResponseType: Decodable> (
        url: String,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void,
        progressCompletion: @escaping (Double) -> Void
        ){
        guard let url = URL(string: url) else { return }
   
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        observation = task.progress.observe(\.fractionCompleted) { progress, _ in
            let progress = progress.fractionCompleted
            progressCompletion(progress)
        }
        
    }
    
    
}
