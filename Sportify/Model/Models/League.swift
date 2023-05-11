import Foundation

struct ResponseFootball: Decodable {
    let success: Int
    let result: [ResultFootball]
}

struct ResultFootball: Decodable {
    let league_key: Int?
    let league_name: String?
    let country_key: Int?
    let country_name: String?
    let league_logo: String?
    let country_logo: String?
}
