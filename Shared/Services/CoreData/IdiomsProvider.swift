import SwiftUI
import Combine
import CoreData

protocol IdiomsProviderInterface {
    var idiomsPublisher: AnyPublisher<[Idiom], Never> { get }
    var idiomsErrorPublisher: AnyPublisher<AppError, Never> { get }

    /// Fetches latest data from Core Data
    func fetchIdioms()
}

final class IdiomsProvider: IdiomsProviderInterface {

    static let shared: IdiomsProviderInterface = IdiomsProvider()

    var idiomsPublisher: AnyPublisher<[Idiom], Never> {
        _idiomsPublisher.eraseToAnyPublisher()
    }

    var idiomsErrorPublisher: AnyPublisher<AppError, Never> {
        _idiomsErrorPublisher.eraseToAnyPublisher()
    }

    private let _idiomsPublisher = CurrentValueSubject<[Idiom], Never>([])
    private let _idiomsErrorPublisher = PassthroughSubject<AppError, Never>()
    private let coreDataContainer = CoreDataContainer.shared
    private var cancellable = Set<AnyCancellable>()

    private init() {
        print("DEBUG50 \(String(describing: self)) init")
        setupBindings()
        fetchIdioms()
    }

    deinit {
        print("DEBUG50 \(String(describing: self)) deinit")
    }

    /// Fetches latest data from Core Data
    func fetchIdioms() {
        let request = NSFetchRequest<Idiom>(entityName: "Idiom")
        do {
            let idioms = try coreDataContainer.viewContext.fetch(request)
            _idiomsPublisher.send(idioms)
        } catch {
            _idiomsErrorPublisher.send(.coreDataError(.fetchError))
        }
    }

    private func setupBindings() {
        // every time core data gets updated, call fetchIdioms()
        NotificationCenter.default.mergeChangesObjectIDsPublisher
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                print("DEBUG50 fetchIdioms")
                self?.fetchIdioms()
            }
            .store(in: &cancellable)
    }
}
