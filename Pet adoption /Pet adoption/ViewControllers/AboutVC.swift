//
//  AboutVC.swift
//  Petadoption
//
//  Created by Durga Sambhavi Mamillapalli on 4/18/24.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call function to fetch data from the API
        fetchData()
    }
    
    func fetchData() {
        // URL of the API
        guard let url = URL(string: "http://demo3652393.mockable.io/about") else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            // Check if response is valid
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            // Check if data is valid
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Parse JSON data
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Extract message from JSON
                if let message = json?["msg"] as? String {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        self?.aboutLabel.text = message
                    }
                } else {
                    print("Message not found in JSON")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        // Start the data task
        task.resume()
    }
}
