
import SwiftUI
import Charts

struct ExportView: View {
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

                        if !dataStore.exportForecast.isEmpty {
                            forecastAndChartSection
                        }
                    }
                    .id("topOfExportView") // Identifier for scrolling
                }
                .onChange(of: currentTab) { newTab in
                    if newTab == .exportTab {
                        withAnimation { proxy.scrollTo("topOfExportView", anchor: .top) }
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
            Text("Live FiT Price")
                .font(.headline)
            Text(dataStore.liveExportPrice)
                .font(.largeTitle)
                .padding()
                .foregroundColor(PriceColorHelper.exportPriceColor(for: Double(dataStore.liveExportPrice.replacingOccurrences(of: "¢", with: "")) ?? 0))
        }
    }

    private var forecastAndChartSection: some View {
        VStack {
            Text("Forecast")
                .font(.headline)
                .padding(.top)

            ForEach(dataStore.exportForecast) { forecast in
                HStack {
                    Text(forecast.time, style: .time)
                    Spacer()
                    Text(String(format: "%.0f¢", forecast.price))
                }
                .padding(.vertical, 2)
            }

            Chart(dataStore.exportForecast) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Price", Int($0.price.rounded()))
                )
                .foregroundStyle(Color.blue)
            }
            .chartYScale(domain: {
                let minPrice = dataStore.exportForecast.min(by: { $0.price < $1.price })?.price ?? 0
                let maxPrice = dataStore.exportForecast.max(by: { $0.price < $1.price })?.price ?? 0
                let range = maxPrice - minPrice
                let buffer = max(5.0, range * 0.1) // At least 5, or 10% of the range
                return (minPrice - buffer)...(maxPrice + buffer)
            }())
            .frame(height: 150)
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(currentTab: .constant(.exportTab)) // Provide a constant binding for preview
    }
}
