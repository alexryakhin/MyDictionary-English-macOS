//
//  WordnikApiService.swift
//  My Dictionary
//
//  Created by Aleksandr Riakhin on 2/24/25.
//

import Foundation

protocol WordnikApiServiceInterface: BaseApiServiceInterface {
    /// Return definitions for a word
    func getDefinitions(
        for word: String,
        params: DefinitionsQueryParams?
    ) async throws -> [WordDefinition]
}

// MARK: - WordnikApiService

struct WordnikApiService: WordnikApiServiceInterface {

    static let shared = WordnikApiService()

    private init() {}

    func getDefinitions(
        for word: String,
        params: DefinitionsQueryParams?
    ) async throws -> [WordDefinition] {
        try await fetchData(
            from: WordnikApiPath.definitions(
                word: word,
                params: params
            ),
            customParams: [.apiKey]
        )
    }
}
