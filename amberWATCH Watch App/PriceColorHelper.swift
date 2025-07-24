
import SwiftUI

struct PriceColorHelper {
    static func importPriceColor(for price: Double) -> Color {
        if price < 15 {
            return .blue // Below 15c
        } else if price < 30 {
            return .green // Below 30c
        } else if price < 50 {
            return .yellow // Below 50c
        } else {
            return .red // Above 50c
        }
    }

    static func exportPriceColor(for price: Double) -> Color {
        if price < 10 {
            return .red // Below 10c
        } else if price < 30 {
            return .yellow // Below 30c
        } else if price < 50 {
            return .green // Below 50c
        } else {
            return .blue // Above 50c
        }
    }
}
