import SwiftUI

struct MainTabView: View {

    @State private var selectedSidebarItem: SidebarItem = .words
    @StateObject private var wordsViewModel = WordsViewModel()
    @StateObject private var idiomsViewModel = IdiomsViewModel()
    @StateObject private var quizzesViewModel = QuizzesViewModel()

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSidebarItem) {
                Section {
                    ForEach(SidebarItem.allCases, id: \.self) { item in
                        NavigationLink(value: item) {
                            Label {
                                Text(item.title)
                            } icon: {
                                item.image
                            }
                            .padding(.vertical, 8)
                            .font(.title3)
                        }
                    }
                } header: {
                    Text("My Dictionary").font(.title2).bold().padding(.vertical, 16)
                }
            }
        } content: {
            switch selectedSidebarItem {
            case .words:
                WordsListView(viewModel: wordsViewModel)
            case .idioms:
                IdiomsListView(viewModel: idiomsViewModel)
            case .quizzes:
                QuizzesView(viewModel: quizzesViewModel)
            }
        } detail: {
            switch selectedSidebarItem {
            case .words:
                if wordsViewModel.selectedWord == nil {
                    Text("Select an item")
                } else {
                    WordDetailsView(viewModel: wordsViewModel)
                }
            case .idioms:
                Text("Select an item")
            case .quizzes:
                Text("Select an item")
            }
        }
        .fontDesign(.rounded)
    }
}
