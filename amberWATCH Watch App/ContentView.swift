
import SwiftUI

enum TabSelection: String, CaseIterable, Identifiable {
    case home = "Home"
    case importTab = "Import"
    case exportTab = "Export"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @State private var selectedTab: TabSelection = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(currentTab: $selectedTab)
                .tag(TabSelection.home)
            ImportView(currentTab: $selectedTab)
                .tag(TabSelection.importTab)
            ExportView(currentTab: $selectedTab)
                .tag(TabSelection.exportTab)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
