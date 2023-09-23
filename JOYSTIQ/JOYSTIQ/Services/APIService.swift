//
//  APIService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/23/23.
//

import Foundation

protocol APIServiceProtocol {
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getLeaderboardFeed(completion: @escaping (Result<[Post], Error>) -> Void)
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void)
}


class APIService: APIServiceProtocol {
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
    
    func getLeaderboardFeed(completion: @escaping (Result<[Post], Error>) -> Void) {
        // Construct the URL with the query parameter
        let feedURL = URL(string: "\(baseURL)/handlers/get_leaderboard_feed")!
        
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

        case .userId(let userID):
            let userIDString = String(userID)
            urlComponent?.queryItems = [URLQueryItem(name: "user_id", value: userIDString)]
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


class MockAPIService: APIServiceProtocol {
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void) {
        // Mocked implementation. For example, you can immediately call the completion with a success:
        completion(.success(()))
    }
    
    func getLeaderboardFeed(completion: @escaping (Result<[Post], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 3, user_id: 3, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 4, user_id: 4, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 6, user_id: 6, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 7, user_id: 7, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 8, user_id: 8, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 9, user_id: 9, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 10, user_id: 10, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7),
            Post(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Dev"))
    }
}
