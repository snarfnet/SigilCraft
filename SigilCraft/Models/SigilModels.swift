import Foundation
import CoreGraphics

struct SigilPlanet: Identifiable {
    let id = UUID()
    let symbol: String
    let nameJa: String
    let nameEn: String
    let latin: String
    let dayJa: String
    let dayEn: String
    let metal: String
    let keywordsJa: String
    let keywordsEn: String
    let kamea: [[Int]]   // magic square
}

struct MethodStep: Identifiable {
    let id = UUID()
    let index: Int
    let titleJa: String
    let titleEn: String
    let bodyJa: String
    let bodyEn: String
}
