import SwiftUI
import Combine
import CoreData

protocol WordsProviderInterface {
    var wordsPublisher: AnyPublisher<[Word], Never> { get }
    var wordsErrorPublisher: AnyPublisher<AppError, Never> { get }

    /// Fetches latest data from Core Data
    func fetchWords()
}

final class WordsProvider: WordsProviderInterface {

    static let shared: WordsProviderInterface = WordsProvider()

    var wordsPublisher: AnyPublisher<[Word], Never> {
        _wordsPublisher.eraseToAnyPublisher()
    }

    var wordsErrorPublisher: AnyPublisher<AppError, Never> {
        _wordsErrorPublisher.eraseToAnyPublisher()
    }

    private let _wordsPublisher = CurrentValueSubject<[Word], Never>([])
    private let _wordsErrorPublisher = PassthroughSubject<AppError, Never>()
    private let coreDataContainer = CoreDataContainer.shared
    private var cancellable = Set<AnyCancellable>()

    private init() {
        setupBindings()
        fetchWords()
        print("DEBUG50 \(String(describing: self)) init")
    }

    deinit {
        print("DEBUG50 \(String(describing: self)) deinit")
    }

    /// Fetches latest data from Core Data
    func fetchWords() {
        let request = NSFetchRequest<Word>(entityName: "Word")
        do {
            let words = try coreDataContainer.viewContext.fetch(request)
            _wordsPublisher.send(words)
        } catch {
            _wordsErrorPublisher.send(.coreDataError(.fetchError))
        }
    }

    private func setupBindings() {
        // every time core data gets updated, call fetchWords()
        NotificationCenter.default.mergeChangesObjectIDsPublisher
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                print("DEBUG50 fetchWords")
                self?.fetchWords()
            }
            .store(in: &cancellable)
    }
}
