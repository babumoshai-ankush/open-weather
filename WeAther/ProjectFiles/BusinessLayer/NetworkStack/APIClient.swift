//
//  NetworkStack.swift
//  KidsPlatform
//
//  Created by Ankush Chakraborty on 26/12/20.
//

import Foundation
import Alamofire

/// Default API timout time
let apiTimeout = 120

/// API client error types
enum APIClientError: Error {
    case custom(message: String, httpStatus: Int? = nil)
}

/// A generic structure that must confirm Codable protocol. This is payload resource of web API.
struct Resource<T: Codable> {
    /// API destination or endpoint
    let url: URLConvertible
    /// HTTP methods (.get/ .post/ .put, or .delete, etc.)
    var httpMethod: HTTPMethod = .get
    /// Parameters that need to send to server
    var body: [AnyHashable: Any]?
    /// API timeout time. Default value 120 seconds `apiTimeout`.
    var timeout = apiTimeout
    /// HTTP header. Default value contains application/json. You can add/ modify, if required.
    var header: HTTPHeaders = ["Accept": "application/json"]
    var files: [APIClientFile]?
}

struct APIClientFile {
    var mimeType: String
    var key: String
    var fileName: String
    var data: Data
    init(mimeType: String, name: String, fileName: String, data: Data) {
        self.fileName = fileName
        self.key = name
        self.mimeType = mimeType
        self.data = data
    }
}

/// This class is reponsible for communication with web through API
class APIClient {
    let session = AF
    
    /// Generic function to call web APIs
    /// - Parameters:
    ///   - resource: An object of `Resource` structure, bunch with URL endpoint, httpMethod, body etc.
    ///   - completion: Callback object that may return success or failure
    func load<T: Codable>(resource: Resource<T>,
                          completion: @escaping (Result<T, APIClientError>) -> Void) {
        Log.d("API => \nURL = \(resource.url)\nHeader = \(resource.header)\nMethod = \(resource.httpMethod)\n")
        // session.cancelAllRequests()
        var requestBody: [String: Any]?
        requestBody = resource.body as? [String : Any]
        session.request(resource.url,
                        method: resource.httpMethod,
                        parameters: requestBody,
                        headers: resource.header).responseJSON { response in
            self.process(response: response, resource: resource) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    private func process<T: Codable>(response: AFDataResponse<Any>,
                                     resource: Resource<T>,
                                     callBack: @escaping (Result<T, APIClientError>) -> Void) {
        guard
        (response.value as? [String: Any]) != nil else {
            if response.response != nil {
                Log.d(response.response ?? "")
                callBack(.failure(.custom(message: Messages.Alerts.failedDefault)))
            }
            return
        }
        // check for http errors
        guard
            let httpStatus = response.response?.statusCode,
            let data = response.data else { return }
        if httpStatus != 200 {
            do {
                guard
                    (try JSONSerialization.jsonObject(with: data,
                                                      options: [.mutableContainers]) as? [String: Any]) != nil else {
                        callBack(.failure(.custom(message: Messages.Alerts.failedDefault,
                                                  httpStatus: httpStatus)))
                        return
                    }
                guard
                    let errorResponse = try JSONSerialization.jsonObject(with: data,
                                                                         options: [.mutableContainers]) as? [String: Any],
                    let message = errorResponse["message"] as? String else {
                    callBack(.failure(.custom(message: Messages.Alerts.failedDefault,
                                              httpStatus: httpStatus)))
                    return
                }
                callBack(.failure(.custom(message: message,
                                          httpStatus: httpStatus)))
            } catch let error {
                callBack(.failure(.custom(message: error.localizedDescription,
                                          httpStatus: httpStatus)))
            }
            return
        }
        do {
            let responseObject = try JSONDecoder().decode(T.self, from: data)
            callBack(.success(responseObject))
        } catch {
            callBack(.failure(.custom(message: error.localizedDescription,
                                      httpStatus: httpStatus)))
        }
    }
    
    func cancelAllRequests() {
        session.cancelAllRequests()
    }
}
