//
//  UserService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/20/23.
//

import Foundation


protocol UserServiceProtocol {
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void)
}

class UserService: UserServiceProtocol {
    let baseURL = "http://127.0.0.1:8080"
    
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Encode the email to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let feedURL = URL(string: "\(baseURL)/handlers/get_user_feed?email=\(emailEncoded)")!
        
        var request = URLRequest(url: feedURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let posts = try JSONDecoder().decode([Post].self, from: data)
                        completion(.success(posts))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void) {

        var urlComponent: URLComponents?

        urlComponent = URLComponents(string: "\(baseURL)/handlers/get_username")
        
        switch query {
        case .email(let email):
            guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
                return
            }
            urlComponent?.queryItems = [URLQueryItem(name: "email", value: emailEncoded)]

        case .userID(let userID):
            urlComponent?.queryItems = [URLQueryItem(name: "user_id", value: userID)]
        }

        guard let url = urlComponent?.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let username = try JSONDecoder().decode(String.self, from: data)
                        completion(.success(username))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}


class MockUserService: UserServiceProtocol {
    let baseURL = "http://127.0.0.1:8080"
    
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: "s3key_user1_1", media: "none", title: "First Post by User1", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, created_at: "2023-09-19T19:58:06.499746Z"),
            Post(id: 10, user_id: 5, s3_key: "s3key_user5_2", media: "none", title: "Second Post by User5", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z")
        ]
        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Dev"))
    }
}
