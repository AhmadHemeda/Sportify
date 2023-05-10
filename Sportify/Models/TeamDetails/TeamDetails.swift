import Foundation

struct TeamsDetails: Codable {
    let success: Int?
    let result: [TeamDetailsResult]
}

struct TeamDetailsResult: Codable {
    let team_key: Int?
    let team_name: String?
    let team_logo: String?
    let players: [Player]
}

struct Player: Codable {
    let player_key: Int?
    let player_name: String?
    let player_number: String?
    let player_country: String?
    let player_type: String?
    let player_age: String?
    let player_match_played: String?
    let player_goals: String?
    let player_yellow_cards: String?
    let player_red_cards: String?
    let player_image: String?
}
