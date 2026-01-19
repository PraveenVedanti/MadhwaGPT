//
//  NetworkManager.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/18/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed
}


final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    func fetch<T: Decodable>(
        urlString: String,
        type: T.Type
    ) async throws -> T {

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
