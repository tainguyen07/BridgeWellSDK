//
//  BridgeWellSDK.swift
//  BridgewellSDK
//
//  Created by Tai Nguyen on 07/01/2024.
//

import Foundation

public class BridgeWellSDK {
    
    static let shared = BridgeWellSDK()
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    private var cache: [String: Any] = [:]
    private let cacheExpirationTime: TimeInterval = 60 * 60 // Cache expiration time in seconds (1 hour)
    
    private let apiQueue = DispatchQueue(label: "com.tainguyen.bridgewellSDK", attributes: .concurrent)
    
    private init() {}
    
    private func fetchData<T: Decodable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        
        // Check if data is cached and not expired
        if let cachedData = cache[endpoint] as? T,
           let cacheTimestamp = cache["\(endpoint)_timestamp"] as? Date,
           Date().timeIntervalSince(cacheTimestamp) < cacheExpirationTime {
            completion(.success(cachedData))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "YourSDKErrorDomain", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                // Cache the data
                self.cache[endpoint] = decodedData
                self.cache["\(endpoint)_timestamp"] = Date()
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        fetchData(from: "posts", completion: completion)
    }
    
    func getPostByIds(ids: [Int], completion: @escaping (Result<[Post], Error>) -> Void) {
        let group = DispatchGroup()
        var posts: [Post] = []
        var errorOccurred: Error?
        
        for postId in ids {
            group.enter()
            
            fetchData(from: "posts/\(postId)") { (result: Result<Post, Error>) in
                switch result {
                case .success(let post):
                    posts.append(post)
                case .failure(let error):
                    errorOccurred = error
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
            } else {
                completion(.success(posts))
            }
        }
    }
    
    
    func getPostWithCommentByIds(ids: [Int], completion: @escaping (Result<[Post], Error>) -> Void) {
        let group = DispatchGroup()
        var posts: [Post] = []
        var errorOccurred: Error?
        
        for postId in ids {
            group.enter()
            
            fetchData(from: "posts/\(postId)") { (result: Result<Post, Error>) in
                switch result {
                case .success(let post):
                    self.fetchData(from: "posts/\(postId)/comments") { (result: Result<[Comment], Error>) in
                        switch result {
                        case .success(let comment):
                            post.comments = comment
                        default:
                            break
                        }
                        posts.append(post)
                    }
                case .failure(let error):
                    errorOccurred = error
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
            } else {
                completion(.success(posts))
            }
        }
    }
}
