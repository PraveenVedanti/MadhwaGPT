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


import Foundation

struct QueryRequest: Codable {
    let question: String
    let persona: String
    let stream: Bool
}

struct QueryResponse: Codable {
    let answer: String
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
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func askQuestion(
        question: String,
        persona: String = "intermediate"
    ) async throws -> String {
        
        guard let url = URL(string: "https://madhwagpt2.onrender.com/query") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = QueryRequest(
            question: question,
            persona: persona,
            stream: false
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(QueryResponse.self, from: data)
        return decodedResponse.answer
    }
}
