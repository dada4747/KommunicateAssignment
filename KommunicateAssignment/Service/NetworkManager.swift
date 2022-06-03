//
//  NetworkManager.swift
//  KommunicateAssignment
//
//  Created by admin on 01/06/22.
//

import Foundation
import UIKit
enum ResponseError: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again"
    case alreadyInFavorites = "You've already favorited this user, You must REALLY like them!"
}

class NetworkManager {
    
    static let shared   = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // MARK: - Network func for Followers
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], ResponseError>) ->Void ) {
         let endPoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        print(url)
         let task = URLSession.shared.dataTask(with: url) { data, response, error in

             if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
          
 
            do {
                let decoder = JSONDecoder()
                  decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
                print(followers)
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, ResponseError>) ->Void ) {
        let endPoint = baseURL + "\(username)"

        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
 }
