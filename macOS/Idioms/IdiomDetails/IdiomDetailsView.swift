import SwiftUI

struct IdiomDetailsView: View {
    @StateObject private var viewModel: IdiomDetailsViewModel
    @State private var isEditing = false

    init(selectedIdiom: Binding<Idiom?>) {
        _viewModel = StateObject(wrappedValue: IdiomDetailsViewModel(idiom: selectedIdiom))
    }

    var body: some View {
        VStack {
            title
            content
        }
        .padding()
        .navigationTitle(viewModel.idiom?.idiomItself ?? "")
        .toolbar {
            Button(role: .destructive) {
                viewModel.deleteCurrentIdiom()
            } label: {
                Image(systemName: "trash")
            }

            Button {
                viewModel.toggleFavorite()
            } label: {
                Image(systemName: "\(viewModel.idiom?.isFavorite == true ? "heart.fill" : "heart")")
                    .foregroundColor(.accentColor)
            }

            Button(isEditing ? "Save" : "Edit") {
                isEditing.toggle()
            }
        }
    }

    // MARK: - Title

    private var title: some View {
        HStack {
            Text(viewModel.idiom?.idiomItself ?? "")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                viewModel.speak(viewModel.idiom?.idiomItself)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
            }
        }
    }

    // MARK: - Primary Content

    private var content: some View {
        ScrollView {
            HStack {
                if isEditing {
                    Text("Definition: ").bold()
                    TextEditor(text: $viewModel.definitionTextFieldStr)
                        .padding(1)
                        .background(Color.secondary.opacity(0.4))
                } else {
                    Text("Definition: ").bold()
                    + Text(viewModel.idiom?.definition ?? "")
                }
                Spacer()
                Button {
                    viewModel.speak(viewModel.idiom?.definition)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                }
            }

            Divider()

            VStack(alignment: .leading) {
                let examples = viewModel.idiom?.examplesDecoded ?? []
                HStack {
                    Text("Examples:").bold()
                    Spacer()
                    if !examples.isEmpty {
                        Button {
                            withAnimation {
                                viewModel.isShowAddExample = true
                            }
                        } label: {
                            Text("Add example")
                        }
                    }
                }

                if !examples.isEmpty {
                    ForEach(Array(examples.enumerated()), id: \.offset) { offset, element in
                        if !isEditing {
                            Text("\(offset + 1). \(examples[offset])")
                        } else {
                            HStack {
                                Button {
                                    viewModel.removeExample(element)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                Text("\(offset + 1). \(examples[offset])")
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("No examples yet..")
                        Button {
                            withAnimation {
                                viewModel.isShowAddExample = true
                            }
                        } label: {
                            Text("Add example")
                        }
                    }
                }

                if viewModel.isShowAddExample {
                    TextField("Type an example here", text: $viewModel.exampleTextFieldStr, onCommit: {
                        viewModel.addExample()
                    })
                    .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}
