//
//  AddIdiomViewModel.swift
//  My Dictionary
//
//  Created by Aleksandr Riakhin on 2/20/25.
//

import Combine
import SwiftUI

final class AddIdiomViewModel: ViewModel {
    @Published var inputText: String = ""
    @Published var inputDefinition: String = ""
    @Published var isShowingAlert = false

    private let idiomsManager: IdiomsManagerInterface

    init(
        inputText: String
    ) {
        self.inputText = inputText
        self.idiomsManager = IdiomsManager.shared
    }

    func addIdiom() {
        if !inputText.isEmpty, !inputDefinition.isEmpty {
            idiomsManager.addNewIdiom(inputText, definition: inputDefinition)
            saveContext()
        } else {
            isShowingAlert = true
        }
    }

    private func saveContext() {
        do {
            try idiomsManager.saveContext()
        } catch {
            handleError(error)
        }
    }
}
