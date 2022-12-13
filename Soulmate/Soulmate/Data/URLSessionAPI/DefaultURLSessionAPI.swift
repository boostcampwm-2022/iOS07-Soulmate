//
//  DefaultURLSessionAPI.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

enum URLSessionAPIError: Error {
    case invalidURLError
    case bodyEncodeError
    case noResponseError
    case invalidStatusCodeError
}

final class DefaultURLSessionAPI: URLSessionAPI {
    private enum HTTPMethod: String {
        case post = "POST"
    }
    
    func post<T: Codable>(
        _ data: T,
        url urlString: String,
        header: [String: String]?) async -> Result<Data?, URLSessionAPIError> {
        
            let result = await self.request(
                method: HTTPMethod.post.rawValue,
                url: urlString,
                bodyData: data,
                header: header
            )
            
            return result
    }
    
    private func request<T: Codable>(
        method: String,
        url: String,
        bodyData: T,
        header: [String: String]?) async -> Result<Data?, URLSessionAPIError> {
        
            guard let url = URL(string: url) else { return .failure(.invalidURLError) }
            guard let body = postPayload(from: bodyData) else {
                return .failure(.bodyEncodeError)
            }
            
            let request = urlRequest(of: url, header: header, httpMethod: method, body: body)
            
            let result = try? await URLSession.shared.data(for: request)
            
            guard let response = result?.1 as? HTTPURLResponse else {
                return .failure(.noResponseError)
            }
            guard 200...200 ~= response.statusCode else {
                return .failure(.invalidStatusCodeError)
            }
            
            let data = result?.0
            
            return .success(data)
    }
    
    private func postPayload<T: Codable>(from body: T) -> Data? {
        guard let data = body as? Data else { return nil }
        
        return try? JSONEncoder().encode(data)
    }
    
    private func urlRequest(
        of url: URL,
        header: [String: String]?,
        httpMethod: String,
        body: Data?) -> URLRequest {
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            header?.forEach { dict in
                request.addValue(dict.value, forHTTPHeaderField: dict.key)
            }
            if let body {
                request.httpBody = body
            }
            
            return request
        }
}
