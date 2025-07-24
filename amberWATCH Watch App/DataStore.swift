import Foundation

// MARK: - Data Structures to match the actual Amber API Response
struct AmberPrice: Decodable, Identifiable {
    // Using nemTime as the ID since it should be unique per interval.
    var id: String { nemTime }

    let channelType: String // "general" (import) or "feedIn" (export)
    let perKwh: Double
    let startTime: Date
    let type: String // "ActualInterval", "CurrentInterval", "ForecastInterval"
    let nemTime: String

    // We need to tell the decoder how to map the JSON keys to our struct properties.
    enum CodingKeys: String, CodingKey {
        case channelType
        case perKwh
        case startTime
        case type
        case nemTime
    }
}

// This is the data structure our charts will use.
struct PriceData: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}

// MARK: - DataStore
class DataStore: ObservableObject {
    @Published var liveImportPrice: String = "--"
    @Published var liveExportPrice: String = "--"
    @Published var importForecast: [PriceData] = []
    @Published var exportForecast: [PriceData] = []

    // IMPORTANT: Make sure you have replaced these with your actual credentials.
    private let apiKey = "YOUR_APIKEY"
    private let siteId = "YOUR_SITEID"

    func fetchData() {
        guard !apiKey.contains("YOUR_") else {
            
            return
        }
        guard let url = URL(string: "https://api.amber.com.au/v1/sites/\(siteId)/prices?resolution=30") else {
            
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    
                    
                }
                return
            }
            guard let data = data else {
                
                return
            }

            // Configure the JSON decoder for the ISO8601 date format Amber uses.
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let allPrices = try decoder.decode([AmberPrice].self, from: data)
                
                DispatchQueue.main.async {
                    

                    // --- Process General (Import) Prices ---
                    let generalPrices = allPrices.filter { $0.channelType == "general" }
                    let currentGeneralPrice = generalPrices
                        .filter { $0.type == "ActualInterval" || $0.type == "CurrentInterval" }
                        .sorted { $0.startTime > $1.startTime }
                        .first
                    
                    if let price = currentGeneralPrice {
                        self.liveImportPrice = String(format: "%.0f¢", price.perKwh)
                    } else {
                        self.liveImportPrice = "N/A"
                    }

                    self.importForecast = generalPrices
                        .filter { $0.type == "ForecastInterval" }
                        .map { PriceData(time: $0.startTime, price: $0.perKwh) }
                        .sorted { $0.time < $1.time }

                    // --- Process Feed-In (Export) Prices ---
                    let feedInPrices = allPrices.filter { $0.channelType == "feedIn" }
                    let currentFeedInPrice = feedInPrices
                        .filter { $0.type == "ActualInterval" || $0.type == "CurrentInterval" }
                        .sorted { $0.startTime > $1.startTime }
                        .first

                    if let price = currentFeedInPrice {
                        // FiT is now positive and rounded.
                        self.liveExportPrice = String(format: "%.0f¢", abs(price.perKwh))
                    } else {
                        self.liveExportPrice = "N/A"
                    }

                    self.exportForecast = feedInPrices
                        .filter { $0.type == "ForecastInterval" }
                        .map { PriceData(time: $0.startTime, price: abs($0.perKwh)) } // FiT is now positive
                        .sorted { $0.time < $1.time }
                    
                    
                }
            } catch {
                DispatchQueue.main.async {
                    
                    
                }
            }
        }.resume()
    }
}
