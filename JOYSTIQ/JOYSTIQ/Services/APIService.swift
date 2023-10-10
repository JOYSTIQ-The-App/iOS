//
//  APIService.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/23/23.
//

import Foundation
import Amplify
import AWSS3StoragePlugin

protocol APIServiceProtocol {
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void)
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void)
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deletePost(email: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteUserSocial(username: String, socialType: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getFollowersList(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getFollowingList(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void)
    func getGlobalFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void)
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
    func getUserAvatar(username: String, completion: @escaping (Result<String?, Error>) -> Void)
    func getUserFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void)
    func getUserPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUserProfile(for username: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func getUserSocials(for username: String, completion: @escaping (Result<[String: String]?, Error>) -> Void)
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void)
    func searchUsernames(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserPost(email: String, postId: Int, bodyText: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserProfile(username: String, bio: String?, resume: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserSocials(username: String, socialType: String, socialUsername: String, completion: @escaping (Result<Void, Error>) -> Void)
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
    
//    func createUser(email: String, username: String, completion: @escaping (Result<Comment, Error>) -> Void) {
//        // Encode the email to ensure it's safe for URLs
//        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
//            return
//        }
//
//        guard let commentURL = URL(string: "\(baseURL)/handlers/create_user") else {
//            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
//            return
//        }
//        
//        var request = URLRequest(url: commentURL)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let userData = UserData(email: email, username: username)
//
//        do {
//            let jsonData = try JSONEncoder().encode(userData)
//            request.httpBody = jsonData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
//                    let message = "Server returned status code: \(httpResponse.statusCode)"
//                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
//                    return
//                }
//
//                completion(.success(()))
//            }
//        }
//        task.resume()
//    }
    
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
                
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    func deletePost(email: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let deletePostURL = URL(string: "\(baseURL)/handlers/delete_post?email=\(encodedEmail)&post_id=\(postId)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: deletePostURL)
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
                
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    func deleteUserSocial(username: String, socialType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for deleting the user's specific social
        let deleteURL = URL(string: "\(baseURL)/handlers/delete_user_social")!
        
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "username": username,
            "social_type": socialType
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to delete user social"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getFollowersList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }

        let followersURL = URL(string: "\(baseURL)/handlers/get_followers_list?username=\(usernameEncoded)")!

        var request = URLRequest(url: followersURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let followersResponse = try JSONDecoder().decode(FollowersResponse.self, from: data)
                        completion(.success(followersResponse.followers))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getFollowingList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }

        let followingURL = URL(string: "\(baseURL)/handlers/get_following_list?username=\(usernameEncoded)")!

        var request = URLRequest(url: followingURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let followingResponse = try JSONDecoder().decode(FollowingResponse.self, from: data)
                        completion(.success(followingResponse.following))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
        // Encode the email to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let feedURL = URL(string: "\(baseURL)/handlers/get_leaderboard_feed?email=\(emailEncoded)")!
        
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
                        let posts = try JSONDecoder().decode([FeedPost].self, from: data)
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
    
    func getUserAvatar(username: String, completion: @escaping (Result<String?, Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL for retrieving the user avatar
        let getUserAvatarURL = URL(string: "\(baseURL)/handlers/get_user_avatar?username=\(usernameEncoded)")!
        
        var request = URLRequest(url: getUserAvatarURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Parse the response data
                    do {
                        if let data = data, let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let s3Key = jsonResponse["s3_key"] as? String
                            completion(.success(s3Key))
                        } else {
                            completion(.success(nil))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user avatar"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }


    func getUserFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
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
                        let posts = try JSONDecoder().decode([FeedPost].self, from: data)
                        print(posts)
                        completion(.success(posts))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getUserPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let profileURL = URL(string: "\(baseURL)/handlers/get_user_posts?username=\(usernameEncoded)")!
        
        var request = URLRequest(url: profileURL)
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
    
    func getUserProfile(for username: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let profileURL = URL(string: "\(baseURL)/handlers/get_user_profile?username=\(usernameEncoded)")!
        
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: data)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getUserSocials(for username: String, completion: @escaping (Result<[String: String]?, Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let socialsURL = URL(string: "\(baseURL)/handlers/get_user_socials?username=\(usernameEncoded)")!
        
        var request = URLRequest(url: socialsURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        // Decode the data into a dictionary
                        let socials = try JSONDecoder().decode([String: String].self, from: data)
                        
                        if socials.isEmpty {
                            // If the dictionary is empty, return nil
                            completion(.success(nil))
                        } else {
                            completion(.success(socials))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    
    func getGlobalFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
        // Encode the email to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let feedURL = URL(string: "\(baseURL)/handlers/get_global_feed?email=\(emailEncoded)")!
        
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
                        let posts = try JSONDecoder().decode([FeedPost].self, from: data)
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
    
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for updating the user avatar
        let updateURL = URL(string: "\(baseURL)/handlers/update_user_avatar")!

        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body
        let requestBody: [String: Any] = [
            "username": username,
            "s3_key": newS3Key
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // If oldS3Key is provided, then delete it from the storage
                    if let keyToDelete = oldS3Key {
                        Task {
                            do {
                                let removedKey = try await Amplify.Storage.remove(key: keyToDelete)
                                print("Deleted \(removedKey)")
                                completion(.success(()))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.success(()))
                    }
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update user avatar"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func updateUserPost(email: String, postId: Int, bodyText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for updating the user post
        let updateURL = URL(string: "\(baseURL)/handlers/update_user_post")!
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "email": email,
            "post_id": postId,
            "body_text": bodyText
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update user post"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func updateUserProfile(username: String, bio: String?, resume: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if either bio or resume is provided
        guard (bio != nil && !bio!.isEmpty) || (resume != nil && !resume!.isEmpty) else {
            completion(.failure(NSError(domain: "InvalidInput", code: 400, userInfo: [NSLocalizedDescriptionKey: "Either bio or resume must be provided"])))
            return
        }

        // Construct the URL for updating the gamer profile
        let updateURL = URL(string: "\(baseURL)/handlers/update_user_profile")!
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "username": username,
            "bio": bio ?? NSNull(),
            "resume": resume ?? NSNull()
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update gamer profile"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func updateUserSocials(username: String, socialType: String, socialUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for updating the user's socials
        let updateURL = URL(string: "\(baseURL)/handlers/update_user_socials")!
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "username": username,
            "social_type": socialType,
            "social_username": socialUsername
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update user social"])
                    completion(.failure(error))
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
    
    func deletePost(email: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func deleteUserSocial(username: String, socialType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Mock: deleteUserSocial()")
        completion(.success(()))
    }


    func getFollowersList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let dummyFollowers = ["john_doe", "alice_smith", "charlie_brown", "david_jones", "elaine_white"]
        completion(.success(dummyFollowers))
    }
    
    func getFollowingList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let dummyFollowing = ["michael_scott", "dwight_schrute", "pam_beesly", "jim_halpert", "angela_martin"]
        completion(.success(dummyFollowing))
    }
    
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [FeedPost] = [
            FeedPost(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 3, user_id: 3, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 4, user_id: 4, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 6, user_id: 6, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 7, user_id: 7, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 8, user_id: 8, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 9, user_id: 9, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false),
            FeedPost(id: 10, user_id: 10, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false)
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
    
    func getUserAvatar(username: String, completion: @escaping (Result<String?, Error>) -> Void) {
        print("Mock: getUserAvatar()")
        completion(.success(nil))
    }
    
    func getUserFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [FeedPost] = [
            FeedPost(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true),
            FeedPost(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUserPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        print("Mock: getUserPosts()")
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "Valorant", body: "Content for first post by Joystiq_dev", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 7),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "Content for second post by Joystiq_dev", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", updated_at: "2023-09-19T19:58:06.499746Z", likes_count: 3)
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUserProfile(for username: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        print("Mock: getUserProfile()")
        // Mocked profile data
        let mockProfile = Profile(bio: "a a a a a a a a a a", resume: "Resume for develpoment", followers: 12, following: 8)

        // Immediately call the completion with the mock data
        completion(.success(mockProfile))
    }
    
    func getUserSocials(for username: String, completion: @escaping (Result<[String: String]?, Error>) -> Void) {
        print("Mock: getUserSocials()")
        let mockSocials: [String: String]? = ["discord": "Joystiq_dev", "twitch": "Joystiq_live", "xbox": "Joystiq_Xbox"]
        
        completion(.success(mockSocials))
    }
    
    func getGlobalFeed(for email: String, completion: @escaping (Result<[FeedPost], Error>) -> Void) {
        // Mocked posts data
        let mockPosts: [FeedPost] = [
            FeedPost(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), media: "none", game: "GameA", body: "Global feed post 1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true),
            FeedPost(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), media: "none", game: "Valorant", body: "global feed post 2", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false)
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
    
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Mock: updateUserAvatar()")
        completion(.success(()))
    }
    
    func updateUserPost(email: String, postId: Int, bodyText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Mock: updateUserPost()")
        completion(.success(()))
    }
    
    func updateUserProfile(username: String, bio: String?, resume: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Mock: updateUserProfile()")
        completion(.success(()))
    }
    
    func updateUserSocials(username: String, socialType: String, socialUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Mock: updateUserSocials()")
        completion(.success(()))
    }


}
