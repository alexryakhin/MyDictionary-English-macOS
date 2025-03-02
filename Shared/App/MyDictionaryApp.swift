import SwiftUI

@main
struct MyDictionaryApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, CoreDataContainer.shared.viewContext)
                .font(.system(.body, design: .rounded))
        }
        .windowStyle(TitleBarWindowStyle())
        .windowToolbarStyle(.unifiedCompact)

        Settings {
            DictionarySettings()
        }
    }
}
