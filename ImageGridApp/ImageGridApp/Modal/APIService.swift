//
//  APICall.swift
//  ImageGridApp
//
//  Created by NFC User on 10/05/24.
//

import Foundation
import SwiftyJSON

class APIService {

    var result = [String]()
    
    func fetchAPI(viewController:UIViewController, callback:@escaping (AnyObject)->()) {
        
        if GeneralViewController.isConnectedToNetwork() {
            
            DispatchQueue.global(qos:.userInitiated).async {
                // Define the URL
                let urlString = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }

                // Create a URLSession instance
                let session = URLSession.shared

                // Create a data task
                let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                    // Check for errors
                    if let error = error {
                        print("Error: \(error)")
                        let message = "Error in fetching image try again"
                        callback(message as AnyObject)
                        return
                    }
                    
                    if let safeData = data {
                        if let apiResult  = self?.parse(apiData: safeData) {
                            callback(apiResult as AnyObject)
                        }
                    }
                }

                // Resume the task
                task.resume()
            }
            
        } else {
            DispatchQueue.main.async {
                GeneralViewController.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:viewController)
            }
        }
        
    }
    
    func parse(apiData: Data) -> [String]? {

        do {
            let apiArray = try JSONDecoder().decode([APIModal].self, from: apiData)
                for oneData in apiArray {
                    let domain = oneData.thumbnail.domain
                    let basePath = oneData.thumbnail.basePath
                    let key = oneData.thumbnail.key
                    
                    let image = domain + "/" + basePath + "/0/" + key
                    
                    result.append(image)
                    
                }
            return result
            
        } catch {
            print(error)
            return []
        }
    }
    
}
