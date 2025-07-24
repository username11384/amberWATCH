
import SwiftUI

struct HomeView: View {
    @StateObject private var dataStore = DataStore()
    @Binding var currentTab: TabSelection

    var body: some View {
        ScrollViewReader {
            proxy in
            VStack(spacing: 0) { // Use spacing: 0 to remove default spacing between elements
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 0.3)

                ScrollView {
                    VStack {
                        Text("Amber Prices")
                            .font(.headline)
                            .padding(.bottom, 20)

                        VStack(alignment: .leading) {
                            Text("Import Price:")
                                .font(.headline)
                            Text(dataStore.liveImportPrice)
                                .font(.title2)
                                .foregroundColor(PriceColorHelper.importPriceColor(for: Double(dataStore.liveImportPrice.replacingOccurrences(of: "¢", with: "")) ?? 0))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .onTapGesture {
                            currentTab = .importTab
                        }

                        VStack(alignment: .leading) {
                            Text("FiT Price:")
                                .font(.headline)
                            Text(dataStore.liveExportPrice)
                                .font(.title2)
                                .foregroundColor(PriceColorHelper.exportPriceColor(for: Double(dataStore.liveExportPrice.replacingOccurrences(of: "¢", with: "")) ?? 0))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .onTapGesture {
                            currentTab = .exportTab
                        }

                        Button(action: {
                            dataStore.fetchData()
                        }) {
                            Label("Refresh Data", systemImage: "arrow.clockwise.circle.fill")
                                .font(.headline)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .id("topOfHomeView") // Identifier for scrolling
                }
                .onChange(of: currentTab) { newTab in
                    if newTab == .home {
                        withAnimation { proxy.scrollTo("topOfHomeView", anchor: .top) }
                    }
                }
            }
        }
        .onAppear {
            dataStore.fetchData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentTab: .constant(.home))
    }
}
