import Foundation

struct Fixture: Codable {
    let success: Int?
    let result: [Result]
}

struct Result: Codable {
    var event_date:String?
    var event_time:String?
    var event_first_player:String?
    var event_second_player:String?
    var event_home_team:String?
    var home_team_key:Int?
    var event_away_team:String?
    var away_team_key:Int?
    var event_final_result:String?
    var home_team_logo:String?
    var away_team_logo:String?
    var event_home_team_logo:String?
    var event_away_team_logo:String?
    var event_second_player_logo:String?
    var event_date_stop:String?
    var event_home_final_result:String?
    var event_first_player_logo:String?
    var first_player_key: Int?
    var second_player_key: Int?
}
