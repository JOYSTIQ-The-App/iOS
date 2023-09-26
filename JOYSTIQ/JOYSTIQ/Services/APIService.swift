//
//  APIService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/23/23.
//

import Foundation

protocol APIServiceProtocol {
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void)
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void)
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getLeaderboardFeed(completion: @escaping (Result<[Post], Error>) -> Void)
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void)
    func searchUsernames(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
}


class APIService: APIServiceProtocol {
    let baseURL = "http://127.0.0.1:8080"
    
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        guard let commentURL = URL(string: "\(baseURL)/handlers/create_comment") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: commentURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let commentData = CommentData(post_id: postId, username: username, text: text)
        
        do {
            let jsonData = try JSONEncoder().encode(commentData)
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
                
                if let data = data {
                    do {
                        let comment = try JSONDecoder().decode(Comment.self, from: data)
                        completion(.success(comment))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                }
            }
        }
        task.resume()
    }

    
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
    
    func createUser(email: String, username: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        // Encode the email to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        guard let commentURL = URL(string: "\(baseURL)/handlers/create_user") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: commentURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData = UserData(email: email, username: username)
        
        do {
            let jsonData = try JSONEncoder().encode(userData)
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
    
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let likeURL = URL(string: "\(baseURL)/handlers/create_like?username=\(encodedUsername)&post_id=\(postId)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: likeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                
                // On successful like creation, increment the like count
                self.incrementLikeCount(postId: postId) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    private func incrementLikeCount(postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let incrementURL = URL(string: "\(baseURL)/handlers/increment_like_count?id=\(postId)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed for incrementing like count"])))
            return
        }
        
        var request = URLRequest(url: incrementURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let message = "Server returned status code: \(httpResponse.statusCode) while incrementing like count"
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                    return
                }
                
                completion(.success(()))
            }
        }
        task.resume()
    }


    
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let likeURL = URL(string: "\(baseURL)/handlers/delete_like?username=\(encodedUsername)&post_id=\(postId)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: likeURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                
                // On successful like deletion, decrement the like count
                self.decrementLikeCount(postId: postId) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    private func decrementLikeCount(postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let decrementURL = URL(string: "\(baseURL)/handlers/decrement_like_count?id=\(postId)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed for decrementing like count"])))
            return
        }
        
        var request = URLRequest(url: decrementURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let message = "Server returned status code: \(httpResponse.statusCode) while decrementing like count"
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
    
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        // Construct the URL with the query parameter
        let commentsURL = URL(string: "\(baseURL)/handlers/get_post_comments?post_id=\(postId)")!
        
        var request = URLRequest(url: commentsURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let comments = try JSONDecoder().decode([Comment].self, from: data)
                        completion(.success(comments))
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
    
    func searchUsernames(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let searchURL = URL(string: "\(baseURL)/handlers/search_usernames?username=\(usernameEncoded)")!
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let usernames = try JSONDecoder().decode([String].self, from: data)
                        completion(.success(usernames))
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
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void) {
            DispatchQueue.main.async {
                let mockComment = Comment(id: 4,
                                          post_id: postId,
                                          user_id: 1,
                                          text: text,
                                          created_at: "\(Date())",
                                          updated_at: "\(Date())")
                completion(.success(mockComment))
            }
    }
    
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void) {
        // Mocked implementation. For example, you can immediately call the completion with a success:
        completion(.success(()))
    }
    
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func getLeaderboardFeed(completion: @escaping (Result<[Post], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 3, user_id: 3, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 4, user_id: 4, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 6, user_id: 6, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 7, user_id: 7, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 8, user_id: 8, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 9, user_id: 9, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3),
            Post(id: 10, user_id: 10, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        // Mock comments data
        let mockComments = [
            Comment(id: 1, post_id: postId, user_id: 1, text: "Great post!", created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z"),
            Comment(id: 2, post_id: postId, user_id: 2, text: "I agree with this.", created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z"),
            Comment(id: 3, post_id: postId, user_id: 3, text: "Interesting perspective.", created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z")
        ]
        
        completion(.success(mockComments))
    }
    
    func getUserFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7),
            Post(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Dev"))
    }
    
    func searchUsernames(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        // Simulate a delay to mimic network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Dummy data
            let usernames = ["john_doe", "jane_doe", "johnny_apple", "jane123", "johnny_bravo"]
            
            // Filter the dummy data to get usernames that contain the search term
            let filteredUsernames = usernames.filter { $0.contains(username) }
            
            completion(.success(filteredUsernames))
        }
    }

}
