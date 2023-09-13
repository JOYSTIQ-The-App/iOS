//
//  FeedbackService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/12/23.
//
import Foundation

struct Feedback: Codable {
    let feedback: String
    let username: String
}

class FeedbackService {
    
    func sendFeedback(feedbackText: String, username: String) {
        // Check if feedback text or username is empty
        if feedbackText.isEmpty || username.isEmpty {
            print("Feedback text and username cannot be empty.")
            return
        }
        
        // Create an instance of Feedback
        let feedbackData = Feedback(feedback: feedbackText, username: username)

        // Create a URL object
        guard let url = URL(string: "https://2u4a9josc6.execute-api.us-east-1.amazonaws.com/alpha/send-feedback") else {
            fatalError("Invalid URL")
        }

        // Create a URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode your data
        do {
            let jsonData = try JSONEncoder().encode(feedbackData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding feedback data")
            return
        }

        // Make the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Convert the data to a String
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
            }
        }

        task.resume()
    }
}

