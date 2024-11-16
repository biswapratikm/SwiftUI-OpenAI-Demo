//
//  NetworkManager.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager() // Singleton instance
    
    // Retrieves the API key from config or defaults to an empty string.
    private var apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    
    // Create request headers
    func createHeaders(contentType: String) -> [String: String] {
        return [
            "Content-Type": contentType,
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    
    // Send a network request
    private func sendRequest(
        to url: URL,
        method: String = HTTPMethod.post.rawValue,
        headers: [String: String] = [:], body: Data?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Handle request errors
            if let error = error {
                completion(.failure(NetworkError.custom(error.localizedDescription)))
                return
            }
            
            // Validate response status
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                completion(.failure(NetworkError.custom(Strings.invalidResponse + statusCode.description)))
                return
            }
            
            // Return data or no-data error
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
        
        task.resume()
    }
    
    // Perform a request with custom parsing
    func performRequest<T>(
        to url: URL,
        method: String = HTTPMethod.post.rawValue,
        headers: [String: String] = [:],
        body: Data?,
        parse: @escaping (Data, @escaping (Result<T, Error>) -> Void) -> Void,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        sendRequest(to: url,
                    method: method,
                    headers: headers,
                    body: body
        ) { result in
            switch result {
            case .success(let data):
                parse(data, completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// HTTP methods enumeration
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}



