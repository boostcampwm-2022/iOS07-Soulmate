//
//  URLSessionAPI.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

protocol URLSessionAPI {
    func post<T: Codable>(_ data: T, url urlString: String, header: [String: String]?) async -> Result<Data?, URLSessionAPIError>
}
