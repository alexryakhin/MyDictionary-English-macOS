import SwiftUI
import Combine
import CoreData

protocol IdiomsManagerInterface {
    /// Creates a new idiom into the Core Data (does not save the data)
    func addNewIdiom(_ idiom: String, definition: String)

    /// Removes a given idiom from the Core Data (does not save the data)
    func deleteIdiom(_ idiom: Idiom)

    /// Saves all changes in the Core Data
    func saveContext() throws
}

final class IdiomsManager: IdiomsManagerInterface {

    static let shared: IdiomsManagerInterface = IdiomsManager()

    private let coreDataContainer = CoreDataContainer.shared

    private init() {
        print("DEBUG50 \(String(describing: self)) init")
    }

    deinit {
        print("DEBUG50 \(String(describing: self)) deinit")
    }

    func addNewIdiom(_ text: String, definition: String) {
        let newIdiom = Idiom(context: coreDataContainer.viewContext)
        newIdiom.id = UUID()
        newIdiom.idiomItself = text
        newIdiom.definition = definition
        newIdiom.timestamp = Date()
    }

    func deleteIdiom(_ idiom: Idiom) {
        coreDataContainer.viewContext.delete(idiom)
    }

    func saveContext() throws {
        try coreDataContainer.viewContext.save()
    }
}
