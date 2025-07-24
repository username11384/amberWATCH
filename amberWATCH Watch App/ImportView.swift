
import SwiftUI
import Charts

struct ImportView: View {
    @StateObject private var dataStore = DataStore()
    @Binding var currentTab: TabSelection

    var body: some View {
        ScrollViewReader {
            proxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 0.3)

                ScrollView {
                    VStack {
                        livePriceSection

                        if !dataStore.importForecast.isEmpty {
                            forecastAndChartSection
                        }
                    }
                    .id("topOfImportView") // Identifier for scrolling
                }
                .onChange(of: currentTab) { newTab in
                    if newTab == .importTab {
                        withAnimation { proxy.scrollTo("topOfImportView", anchor: .top) }
                    }
                }
            }
        }
        .onAppear {
            dataStore.fetchData()
        }
    }

    private var livePriceSection: some View {
        VStack {
            Text("Live Import Price")
                .font(.headline)
            Text(dataStore.liveImportPrice)
                .font(.largeTitle)
                .padding()
                .foregroundColor(PriceColorHelper.importPriceColor(for: Double(dataStore.liveImportPrice.replacingOccurrences(of: "¢", with: "")) ?? 0))
        }
    }

    private var forecastAndChartSection: some View {
        VStack {
            Text("Forecast")
                .font(.headline)
                .padding(.top)

            ForEach(dataStore.importForecast) { forecast in
                HStack {
                    Text(forecast.time, style: .time)
                    Spacer()
                    Text(String(format: "%.0f¢", forecast.price))
                }
                .padding(.vertical, 2)
            }

            Chart(dataStore.importForecast) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Price", Int($0.price.rounded()))
                )
                .foregroundStyle(Color.blue)
            }
            .chartYScale(domain: {
                let minPrice = dataStore.importForecast.min(by: { $0.price < $1.price })?.price ?? 0
                let maxPrice = dataStore.importForecast.max(by: { $0.price < $1.price })?.price ?? 0
                let range = maxPrice - minPrice
                let buffer = max(5.0, range * 0.1) // At least 5, or 10% of the range
                return (minPrice - buffer)...(maxPrice + buffer)
            }())
            .frame(height: 150)
        }
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(currentTab: .constant(.importTab)) // Provide a constant binding for preview
    }
}
