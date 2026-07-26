import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CreateView()
                .tabItem { Label("作成", systemImage: "wand.and.stars") }
                .tag(0)

            MethodView()
                .tabItem { Label("技法", systemImage: "list.number") }
                .tag(1)

            PlanetsView()
                .tabItem { Label("惑星", systemImage: "circle.grid.cross") }
                .tag(2)

            AboutView()
                .tabItem { Label("解説", systemImage: "book.closed") }
                .tag(3)
        }
        .tint(Arcane.gold)
        .preferredColorScheme(.dark)
    }
}

#Preview { ContentView() }
