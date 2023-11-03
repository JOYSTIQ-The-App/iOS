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
    func checkUsernameAvailability(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void)
    func createFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void)
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deletePost(email: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteUserSocial(username: String, socialType: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getFollowersList(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getFollowingList(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func getGamerProfile(for email: String, username: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
    func getGlobalFeed(for email: String, lastSeenCreatedAt: String?, completion: @escaping (Result<[Post], Error>) -> Void)
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
    func getUserAvatar(username: String, completion: @escaping (Result<Avatar, Error>) -> Void)
    func getUserBio(for username: String, completion: @escaping (Result<Bio, Error>) -> Void)
    func getUserFeed(for email: String, lastSeenCreatedAt: String?, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUserPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void)
    func getUserProfile(for username: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
    func getUserSocials(for username: String, completion: @escaping (Result<[String: String]?, Error>) -> Void)
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void)
    func isFollowing(username: String, followingUsername: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func reportPost(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func searchUsernames(for username: String, completion: @escaping (Result<[String], Error>) -> Void)
    func updateUsername(email: String, newUsername: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, enviro: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserPost(email: String, postId: Int, bodyText: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserProfile(username: String, bio: String?, resume: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserSocials(username: String, socialType: String, socialUsername: String, completion: @escaping (Result<Void, Error>) -> Void)
}


class APIService: APIServiceProtocol {
    let baseURL = "https://api.joystiq.gg"
    
    func checkUsernameAvailability(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }

        let checkURL = URL(string: "\(baseURL)/handlers/check_username_availability?username=\(usernameEncoded)")!

        var request = URLRequest(url: checkURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let availabilityResponse = try JSONDecoder().decode(UsernameAvailabilityResponse.self, from: data)
                        completion(.success(availabilityResponse.availability))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
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
    
    func createFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let followURL = URL(string: "\(baseURL)/handlers/create_follow") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }

        var request = URLRequest(url: followURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let followData = ["follower_username": username, "followed_username": followingUsername]

        do {
            let jsonData = try JSONEncoder().encode(followData)
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
                
                completion(.success(()))
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
                
                if let data = data {
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        print(serverResponse.message)  // Logging the message
                    } catch {
                        print("Error decoding server message: \(error)")
                    }
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

    func createUser(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        createUniqueUsername { result in
            switch result {
            case .success(let username):
                
                guard let commentURL = URL(string: "\(self.baseURL)/handlers/create_user") else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
                    return
                }
                
                var request = URLRequest(url: commentURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let userData = CreateUserPayload(email: email, username: username, role: "gamer", account: "public")

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

                        completion(.success((username)))
                    }
                }
                task.resume()

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Function to create a unique username
    func createUniqueUsername(completion: @escaping (Result<String, Error>) -> Void) {
        let randomSuffix = String(Int.random(in: 100000..<999999))  // Generates a random six-digit number
        let username = "Newbie\(randomSuffix)"
        print("Creating new username:", username)
        
        checkUsernameAvailability(username: username) { result in
            switch result {
            case .success(let available):
                if available {
                    completion(.success(username))
                } else {
                    self.createUniqueUsername(completion: completion) // Recursively call the function if the username isn't unique
                }
            case .failure(let error):
                print("Error checking username availability: \(error)")
            }
        }
    }
    
    func deleteFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let followURL = URL(string: "\(baseURL)/handlers/delete_follow") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }

        var request = URLRequest(url: followURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let followData = ["follower_username": username, "followed_username": followingUsername]

        do {
            let jsonData = try JSONEncoder().encode(followData)
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
                        let followerList = try JSONDecoder().decode([String].self, from: data)
                        completion(.success(followerList))
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
                        let followingList = try JSONDecoder().decode([String].self, from: data)
                        completion(.success(followingList))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
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
    
    func getUserAvatar(username: String, completion: @escaping (Result<Avatar, Error>) -> Void) {
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
                
                if let data = data {
                    do {
                        let comments = try JSONDecoder().decode(Avatar.self, from: data)
                        completion(.success(comments))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getUserBio(for username: String, completion: @escaping (Result<Bio, Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let profileURL = URL(string: "\(baseURL)/handlers/get_user_bio?username=\(usernameEncoded)")!
        
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
                        let bio = try JSONDecoder().decode(Bio.self, from: data)
                        completion(.success(bio))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }


    func getUserFeed(for email: String, lastSeenCreatedAt: String? = nil, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Encode the username to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        // Start by constructing the base URL
        var feedURLComponents = URLComponents(string: "\(baseURL)/handlers/get_user_feed")
        
        // Create query items for the encoded email, limit, and (if present) the lastSeenCreatedAt
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "email", value: emailEncoded)
        ]
        
        if let lastSeenTimestamp = lastSeenCreatedAt {
            queryItems.append(URLQueryItem(name: "last_seen_created_at", value: lastSeenTimestamp))
        }
        feedURLComponents?.queryItems = queryItems
        
        // Ensure the URL is valid
        guard let feedURL = feedURLComponents?.url else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }

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
    
    func getUserProfile(for username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
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
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getGamerProfile(for email: String, username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // Encode the email and username to ensure it's safe for URLs
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        guard let usernameEncoded = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidUsername", code: 400, userInfo: nil)))
            return
        }
        
        // Construct the URL with the query parameter
        let profileURL = URL(string: "\(baseURL)/handlers/get_gamer_profile?email=\(emailEncoded)&username=\(usernameEncoded)")!
        
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
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
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

    
    func getGlobalFeed(for email: String, lastSeenCreatedAt: String? = nil, completion: @escaping (Result<[Post], Error>) -> Void) {
        
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }
        
        // Start by constructing the base URL
        var feedURLComponents = URLComponents(string: "\(baseURL)/handlers/get_global_feed")
        
        // Create query items for the encoded email and (if present) the lastSeenCreatedAt
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "email", value: emailEncoded)]
        
        if let lastSeenTimestamp = lastSeenCreatedAt {
            queryItems.append(URLQueryItem(name: "last_seen_created_at", value: lastSeenTimestamp))
        }
        feedURLComponents?.queryItems = queryItems
        
        // Ensure the URL is valid
        guard let feedURL = feedURLComponents?.url else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }

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
    
    func isEmailRegistered(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidEmail", code: 400, userInfo: nil)))
            return
        }

        let checkURL = URL(string: "\(baseURL)/handlers/is_email_registered?email=\(emailEncoded)")!

        var request = URLRequest(url: checkURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let registrationResponse = try JSONDecoder().decode(EmailRegisteredResponse.self, from: data)
                        completion(.success(registrationResponse.isRegistered))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func isFollowing(username: String, followingUsername: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let followURL = URL(string: "\(baseURL)/handlers/is_following?username=\(username)&following_username=\(followingUsername)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }

        var request = URLRequest(url: followURL)
        request.httpMethod = "GET"

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
                        let responseObject = try JSONDecoder().decode([String: Bool].self, from: data)
                        if let isFollowing = responseObject["isFollowing"] {
                            completion(.success(isFollowing))
                        } else {
                            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                        }
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
    
    func reportPost(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let reportPostURL = URL(string: "\(baseURL)/handlers/report_post") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL Creation Failed"])))
            return
        }
        
        var request = URLRequest(url: reportPostURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let reportData = ReportData(username: username, post_id: postId)
        
        do {
            let jsonData = try JSONEncoder().encode(reportData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
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
    
    func updateUsername(email: String, newUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for updating the username
        let updateURL = URL(string: "\(baseURL)/handlers/update_username")!
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "email": email,
            "new_username": newUsername
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
                    let error = NSError(domain: "NetworkError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update username"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, enviro: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the URL for updating the user avatar
        let updateURL = URL(string: "\(baseURL)/handlers/update_user_avatar")!

        var request = URLRequest(url: updateURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body
        let requestBody: [String: Any] = [
            "username": username,
            "s3_key": newS3Key,
            "environment": enviro
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
    func checkUsernameAvailability(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("MockAPIService: checkUsernameAvailability() with username:", username)
        if username == "Test" {
            completion(.success(false))
            return
        }
        
        completion(.success(true))
    }
    
    func createComment(postId: Int, username: String, text: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        print("MockAPIService: createComment() with username:", username, " and comment:", text)
        DispatchQueue.main.async {
            let mockComment = Comment(id: 4,
                                      post_id: postId,
                                      user_id: 1,
                                      text: text,
                                      created_at: "\(Date())",
                                      username: username)
            completion(.success(mockComment))
        }
    }
    
    func createFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: createFollow() with username:", username, " and followingUsername as:", followingUsername)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    func createLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: createLike() with uesrname:", username, " and postId as:", postId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Introduce a 1-second delay
            completion(.success(()))
        }
    }
    
    func createPost(email: String, postData: PostData, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: createPost() with email:", email, " and postData as:", postData)
        completion(.success(()))
    }
    
    func deleteLike(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: deleteLike() with uesrname:", username, " and postId as:", postId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Introduce a 1-second delay
            completion(.success(()))
        }
    }
    
    func deleteFollow(username: String, followingUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: deleteFollow() with username:", username, " and followingUsername as:", followingUsername)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    func deletePost(email: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: deleteLike() with email:", email, " and postId as:", postId)
        completion(.success(()))
    }
    
    func deleteUserSocial(username: String, socialType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: deleteUserSocial() with username:", username, " and socialType:", socialType)
        completion(.success(()))
    }

    func getFollowersList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        print("MockAPIService: getFollowersList() with username:", username)
        let dummyFollowers = ["john_doe", "alice_smith", "charlie_brown", "david_jones", "elaine_white"]
        completion(.success(dummyFollowers))
    }
    
    func getFollowingList(for username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        print("MockAPIService: getFollowingList() with username:", username)
        let dummyFollowing = ["michael_scott", "dwight_schrute", "pam_beesly", "jim_halpert", "angela_martin"]
        completion(.success(dummyFollowing))
    }
    
    func getGamerProfile(for email: String, username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        print("MockAPIService: getGamerProfile() with email:", email, " and username:", username)
        // Mocked profile data
        let mockProfile = UserProfile(
            avatar_s3_key: S3Key(String: "", Valid: false),
            bio: "This is a sample bio for development",
            environment: "",
            followers: 12,
            following: 8,
            posts: [
                Post(
                    id: 1,
                    user_id: 10,
                    s3_key: S3Key(String: "", Valid: false),
                    thumbnail_s3_key: S3Key(String: "", Valid: false),
                    media: "none",
                    game: "MockGameA",
                    body: "Check out this cool mock video!",
                    status: "live",
                    likes: 5,
                    comments: 2,
                    created_at: "2023-09-25T16:56:31.187556Z",
                    user_liked: true,
                    username: "mockUsernameA",
                    avatar_s3_key: S3Key(String: "", Valid: false)
                ),
                Post(
                    id: 2,
                    user_id: 11,
                    s3_key: S3Key(String: "", Valid: false),
                    thumbnail_s3_key: S3Key(String: "", Valid: false),
                    media: "none",
                    game: "MockGameB",
                    body: "Another mock video!",
                    status: "live",
                    likes: 3,
                    comments: 1,
                    created_at: "2023-09-24T16:56:31.187556Z",
                    user_liked: false,
                    username: "mockUsernameB",
                    avatar_s3_key: S3Key(String: "", Valid: false)
                )
            ],
            resume: "Resume for development",
            socials: ["twitch": "mockTwitchHandle", "xbox": "mockXboxHandle"]
        )


        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockProfile))
        }
    }
    
    func getGlobalFeed(for email: String, lastSeenCreatedAt: String? = nil, completion: @escaping (Result<[Post], Error>) -> Void) {
        print("MockAPIService: getGlobalFeed() with email:", email, " and lastSeenCreatedAt:", lastSeenCreatedAt ?? "")
        if lastSeenCreatedAt != nil {
            // Mocked posts data for load more
            let mockPosts: [Post] = [
                Post(id: 6, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User1", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 7, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 8, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 9, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
            ]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(mockPosts))
            }
            return
        }
        
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User1", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User2", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 3, user_id: 3, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User3", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 4, user_id: 4, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User4", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
        ]

        
        // Immediately call the completion with the mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockPosts))
        }
    }
    
    func getLeaderboardFeed(for email: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        print("MockAPIService: getLeaderboardFeed() with email:", email)
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User1", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User2", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 3, user_id: 3, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User3", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 4, user_id: 4, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User4", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 6, user_id: 6, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User6", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 7, user_id: 7, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User7", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 8, user_id: 8, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User8", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 9, user_id: 9, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User9", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 10, user_id: 10, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User10", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockPosts))
        }
    }
    
    func getPostComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        print("MockAPIService: getPostComments() with postId:", postId)
        // Mock comments data
        let mockComments = [
            Comment(id: 1, post_id: postId, user_id: 1, text: "Great post!", created_at: "2023-09-19T19:58:06.499746Z", username: "Apical"),
            Comment(id: 2, post_id: postId, user_id: 2, text: "I agree with this.", created_at: "2023-09-19T19:58:06.499746Z", username: "Nooch"),
            Comment(id: 3, post_id: postId, user_id: 3, text: "Interesting perspective.", created_at: "2023-09-19T19:58:06.499746Z", username: "NarattoCotto")
        ]
        
        completion(.success(mockComments))
    }
    
    func getUserAvatar(username: String, completion: @escaping (Result<Avatar, Error>) -> Void) {
        print("MockAPIService: getUserAvatar() with username:", username)
        let mockAvatar = Avatar(s3_key: nil, environment: "gameroom")
        completion(.success(mockAvatar))
    }
    
    func getUserBio(for username: String, completion: @escaping (Result<Bio, Error>) -> Void) {
        print("MockAPIService: getUserBio() with username", username)
        
        let mockBio: Bio = Bio(bio: "this is the bio for development")
        completion(.success(mockBio))
    }
    
    func getUserFeed(for email: String, lastSeenCreatedAt: String? = nil, completion: @escaping (Result<[Post], Error>) -> Void) {
        print("MockAPIService: getUserFeed() with email:", email, " and lastSeenCreatedAt:", lastSeenCreatedAt ?? "")
        if lastSeenCreatedAt != nil {
            // Mocked posts data for load more
            let mockPosts: [Post] = [
                Post(id: 6, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "GameA", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 7, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 8, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 9, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
                Post(id: 10, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
            ]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(mockPosts))
            }
            return
        }
        
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 1, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Rocket League", body: "Content for first post by User1", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 2, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Chess", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 3, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Apex", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 4, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Bloodhunt", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 5, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "MultiVerse", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 11, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Overwatch", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 12, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "For Honor", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 13, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "League of Legends", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 14, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Call of Duty", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 15, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "MW2", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 16, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Fortnite", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 17, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "MWIII", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 18, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "GTA 5", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 19, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "The Finals", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 20, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 21, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 22, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 23, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 24, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 25, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 26, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 27, user_id: 5, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for post by User", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockPosts))
        }
    }
    
    func getUserPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        print("MockAPIService: getUserPosts() with username:", username)
        // Mocked posts data
        let mockPosts: [Post] = [
            Post(id: 1, user_id: 2, s3_key: S3Key(String: "someKey1", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for first post by Joystiq_dev", status: "live", likes: 7, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 2, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for second post by Joystiq_dev", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 3, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for second post by Joystiq_dev", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: true, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 4, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for second post by Joystiq_dev", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false)),
            Post(id: 5, user_id: 2, s3_key: S3Key(String: "someKey2", Valid: false), thumbnail_s3_key: S3Key(String: "", Valid: false), media: "none", game: "Valorant", body: "Content for second post by Joystiq_dev", status: "live", likes: 3, comments: 1, created_at: "2023-09-19T19:58:06.499746Z", user_liked: false, username: "User5", avatar_s3_key: S3Key(String: "someKey1", Valid: false))
        ]

        
        // Immediately call the completion with the mock data
        completion(.success(mockPosts))
    }
    
    func getUserProfile(for username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        print("MockAPIService: getUserProfile() with username:", username)
        // Mocked profile data
        let mockProfile = UserProfile(
            avatar_s3_key: S3Key(String: "", Valid: false),
            bio: "This is a sample bio for development",
            environment: "",
            followers: 12,
            following: 8,
            posts: [
                Post(
                    id: 1,
                    user_id: 10,
                    s3_key: S3Key(String: "", Valid: false),
                    thumbnail_s3_key: S3Key(String: "", Valid: false),
                    media: "none",
                    game: "MockGameA",
                    body: "Check out this cool mock video!",
                    status: "live",
                    likes: 5,
                    comments: 2,
                    created_at: "2023-09-25T16:56:31.187556Z",
                    user_liked: true,
                    username: "mockUsernameA",
                    avatar_s3_key: S3Key(String: "", Valid: false)
                ),
                Post(
                    id: 2,
                    user_id: 11,
                    s3_key: S3Key(String: "", Valid: false),
                    thumbnail_s3_key: S3Key(String: "", Valid: false),
                    media: "none",
                    game: "MockGameB",
                    body: "Another mock video!",
                    status: "live",
                    likes: 3,
                    comments: 1,
                    created_at: "2023-09-24T16:56:31.187556Z",
                    user_liked: false,
                    username: "mockUsernameB",
                    avatar_s3_key: S3Key(String: "", Valid: false)
                )
            ],
            resume: "Resume for development",
            socials: ["twitch": "mockTwitchHandle", "xbox": "mockXboxHandle"]
        )


        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockProfile))
        }
    }
    
    func getUserSocials(for username: String, completion: @escaping (Result<[String: String]?, Error>) -> Void) {
        print("MockAPIService: getUserSocials() with username:", username)
        let mockSocials: [String: String]? = ["discord": "Joystiq_dev", "twitch": "Joystiq_live", "xbox": "Joystiq_Xbox"]
        
        completion(.success(mockSocials))
    }
    
    func getUsername(for query: UserIdentifier, completion: @escaping (Result<String, Error>) -> Void) {
        print("MockAPIService: getUsername() with:", query.self)
        completion(.success("Dev"))
    }
    
    func isFollowing(username: String, followingUsername: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(false))
    }
    
    func reportPost(username: String, postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: reportPost() user:", username, ", post id:", postId)
        completion(.success(()))
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
    
    func updateUsername(email: String, newUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: updateUsername() with email:", email, " and newUsername:", newUsername)
        completion(.success(()))
    }
    
    func updateUserAvatar(username: String, oldS3Key: String?, newS3Key: String, enviro: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: updateUserAvatar()")
        completion(.success(()))
    }
    
    func updateUserPost(email: String, postId: Int, bodyText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: updateUserPost()")
        completion(.success(()))
    }
    
    func updateUserProfile(username: String, bio: String?, resume: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: updateUserProfile()")
        completion(.success(()))
    }
    
    func updateUserSocials(username: String, socialType: String, socialUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("MockAPIService: updateUserSocials()")
        completion(.success(()))
    }

}
