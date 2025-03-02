import SwiftUI

struct WordsListView: View {

    @ObservedObject var viewModel: WordsViewModel
    @State private var isShowingAddView = false

    var body: some View {
        List(selection: $viewModel.selectedWord) {
            ForEach(viewModel.wordsFiltered) { word in
                NavigationLink(value: word) {
                    WordsListCellView(
                        model: .init(
                            word: word.wordItself ?? "word",
                            partOfSpeech: word.partOfSpeech ?? "",
                            isFavorite: word.isFavorite,
                            isSelected: viewModel.selectedWord?.id == word.id
                        )
                    )
                }
                .tag(word)
            }
            .onDelete { offsets in
                viewModel.deleteWord(offsets: offsets)
            }

            if viewModel.filterState == .search && viewModel.wordsFiltered.count < 10 {
                Button {
                    isShowingAddView = true
                } label: {
                    Text("Add '\(viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines))'")
                }
            }
        }
        .onDisappear {
            viewModel.selectedWord = nil
        }
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .top) {
            toolbar
                .background(.regularMaterial)
        }
        .safeAreaInset(edge: .bottom) {
            if !viewModel.wordsFiltered.isEmpty {
                Text(viewModel.wordsCount)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(.regularMaterial)
            }
        }
        .navigationTitle("Words")
        .sheet(isPresented: $isShowingAddView) {
            viewModel.searchText = ""
        } content: {
            AddWordView(inputWord: viewModel.searchText)
        }
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                sortMenu
                Button {
                    isShowingAddView = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.accentColor)
                }
            }
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.separator)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    // MARK: - Sort Menu

    private var sortMenu: some View {
        Menu {
            Section {
                Button {
                    viewModel.selectSortingState(.def)
                } label: {
                    if viewModel.sortingState == .def {
                        Image(systemName: "checkmark")
                    }
                    Text("Default")
                }
                Button {
                    viewModel.selectSortingState(.name)
                } label: {
                    if viewModel.sortingState == .name {
                        Image(systemName: "checkmark")
                    }
                    Text("Name")
                }
                Button {
                    viewModel.selectSortingState(.partOfSpeech)
                } label: {
                    if viewModel.sortingState == .partOfSpeech {
                        Image(systemName: "checkmark")
                    }
                    Text("Part of speech")
                }
            } header: {
                Text("Sort by")
            }

            Section {
                Button {
                    viewModel.selectFilterState(.none)
                } label: {
                    if viewModel.filterState == .none {
                        Image(systemName: "checkmark")
                    }
                    Text("None")
                }
                Button {
                    viewModel.selectFilterState(.favorite)
                } label: {
                    if viewModel.filterState == .favorite {
                        Image(systemName: "checkmark")
                    }
                    Text("Favorites")
                }
            } header: {
                Text("Filter by")
            }

        } label: {
            Image(systemName: "arrow.up.arrow.down")
            Text(viewModel.sortingState.rawValue)
        }
    }
}
