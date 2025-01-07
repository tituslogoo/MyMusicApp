//
//  ServiceManager.swift
//  MyMusicApp
//
//  Created by Titus Logo on 20/12/24.
//

import Foundation

public typealias JSONObject = [String: Any]

final class ServiceManager {
    static let defaultErrorMessage: String = NSLocalizedString("common.error.body.something-wrong", comment: "")
    
    /// Fetches data from the given API URL with optional parameters and headers.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - method: The HTTP method
    ///   - headers: The HTTP headers (default is nil).
    ///   - parameters: The query parameters (default is nil).
    ///   - completion: A closure called with the result of the request (success or failure).
    /// - Returns: A `URLSessionDataTask` that can be resumed or cancelled.
    static func fetchAPI(
        url: URL,
        method: ServiceManagerMethodType = .post,
        headers: [String: String]? = nil,
        parameters: JSONObject? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        // Create URL request
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers
        if let headers: [String: String] = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add parameters (for POST or PUT requests)
        if let parameters = parameters, ["POST", "PUT"].contains(method.rawValue.uppercased()) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            catch {
                completion(.failure(error))
                return URLSessionDataTask()
            }
        }
        
        print("🛜 API Call: \(request.url?.absoluteString ?? "")")
        // Create data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Validate response
            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(
                    domain: "com.mymusicapp.service",
                    code: statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid response or data."]
                )
                completion(.failure(error))
                return
            }
            
            // Success
            completion(.success(data))
        }
        
        task.resume()
        
        // Return the data task
        return task
    }
}
