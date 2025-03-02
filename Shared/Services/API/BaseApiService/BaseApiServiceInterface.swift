//
//  BaseApiServiceInterface.swift
//  My Dictionary
//
//  Created by Aleksandr Riakhin on 2/24/25.
//

import Foundation

protocol BaseApiServiceInterface {}

extension BaseApiServiceInterface {

    /// Generic method to fetch and decode data from any API
    func fetchData<T: Codable>(from path: ApiPath, customParams: [CustomQueryParam]) async throws -> T {
        guard let url = path.url(customParams: customParams) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        if let string = data.prettyPrintedJSONString {
            print("DEBUG50\nURL: \(url)\nPath: \(path.path)\nJSON: \(string)\\")
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
