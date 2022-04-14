//
//  NetworkManager.swift
//  ApiRequest
//
//  Created by Neha Gupta on 31/07/21.
//

import Foundation

final class NetworkManager {
    
    //MARK: - Network  Status -
    
    static func fetchData<T:Decodable>(requestUrl: URL, resultType: T.Type ,completionHandler:@escaping (Result<T, NetworkError>)-> Void) {
        let objReach:Reachability = Reachability()
        if objReach.isConnectedToNetwork() == false {
            completionHandler(.failure(.noInternetconnection(err: "No Internet Connection")))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            guard error == nil else {
                print(String(describing: error))
                completionHandler(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let responseData = responseData else {
                completionHandler(.failure(.invalidData))
                return
            }
                //parse the responseData here
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: responseData)
                completionHandler(.success(result))
            }
            catch let error{
                debugPrint("error occured while decoding = \(error.localizedDescription)")
                completionHandler(.failure(.DecoadingError(err: error.localizedDescription)))
            }
            

        }.resume()
    }
    
    static func postData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping (Result<T, NetworkError>)-> Void) {
        let objReach:Reachability = Reachability()
        if objReach.isConnectedToNetwork() == false {
            completionHandler(.failure(.noInternetconnection(err: "No Internet Connection")))
            return
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            guard error == nil else {
                print(String(describing: error))
                completionHandler(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let responseData = data else {
                completionHandler(.failure(.invalidData))
                return
            }
                //parse the responseData here
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: responseData)
                completionHandler(.success(result))
            }
            catch let error{
                debugPrint("error occured while decoding = \(error.localizedDescription)")
                completionHandler(.failure(.DecoadingError(err: error.localizedDescription)))
            }
            do {
                
                let response = try JSONDecoder().decode(T.self, from: data!)
                completionHandler(.success(response))
            }
            catch let decodingError {
                debugPrint(decodingError)
                completionHandler(.failure(.DecoadingError(err: decodingError.localizedDescription)))
            }
            
        }.resume()
    }
    
}

enum NetworkError: Error{
 
    case invalidResponse
    case invalidData
    case error(err: String)
    case DecoadingError(err: String)
    case noInternetconnection(err: String)
}
