//
//  PostService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/20/23.
//

import Foundation

protocol PostServiceProtocol {
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void)
}


class PostService: PostServiceProtocol {
    let baseURL = "http://127.0.0.1:8080"
    
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let postURL = URL(string: "\(baseURL)/handlers/create_post?email=\(email)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(postData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let message = "Server returned status code: \(httpResponse.statusCode)"
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                    return
                }
                
                completion(.success(()))
            }
        }
        task.resume()
    }
}


class MockPostService: PostServiceProtocol {
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void) {
        // Mocked implementation. For example, you can immediately call the completion with a success:
        completion(.success(()))
    }
}
