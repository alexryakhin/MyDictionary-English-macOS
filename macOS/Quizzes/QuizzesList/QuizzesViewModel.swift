import SwiftUI
import Combine

final class QuizzesViewModel: ViewModel {
    @Published var selectedQuiz: Quiz?
    @Published var words: [Word] = []

    private let wordsProvider: WordsProviderInterface
    private var cancellables: Set<AnyCancellable> = []

    override init() {
        self.wordsProvider = WordsProvider.shared
        super.init()
        setupBindings()
    }

    /// Fetches latest data from Core Data
    private func setupBindings() {
        wordsProvider.wordsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.words, on: self)
            .store(in: &cancellables)
    }
}
