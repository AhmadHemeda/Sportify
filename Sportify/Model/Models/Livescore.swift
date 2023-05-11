import Foundation

struct Livescore: Codable {
    let success: Int
    let result: [LivescoreResult]
}

struct LivescoreResult: Codable {
    let event_key: Int?
    let event_date: String?
    let event_time: String?
    let event_home_team: String?
    let home_team_key: Int?
    let event_away_team: String?
    let away_team_key: Int?
    let event_halftime_result: String?
    let event_final_result: String?
    let event_ft_result: String?
    let event_penalty_result: String?
    let event_status: String?
    let country_name: String?
    let league_name: String?
    let league_key: Int?
    let league_round: String?
    let league_season: String?
    let event_live: String?
    let event_stadium: String?
    let event_referee: String?
    let home_team_logo: String?
    let away_team_logo: String?
    let event_country_key: Int?
    let league_logo: String?
    let country_logo: String?
    let event_home_formation: String?
    let event_away_formation: String?
    let fk_stage_key: Int?
    let stage_name: String?
    let event_quarter: String?
    let event_home_team_logo: String?
    let event_away_team_logo: String?
    let event_first_player: String?
    let first_player_key: Int?
    let event_second_player: String?
    let second_player_key: Int?
    let event_game_result: String?
    let event_serve: String?
    let event_winner: String?
    let event_first_player_logo: String?
    let event_second_player_logo: String?
    let event_date_start: String?
    let event_date_stop: String?
    let event_service_home: String?
    let event_service_away: String?
    let event_home_final_result: String?
    let event_away_final_result: String?
    let event_home_rr: String?
    let event_away_rr: String?
    let event_status_info: String?
    let event_type: String?
    let event_toss: String?
    let event_man_of_match: String?
}
