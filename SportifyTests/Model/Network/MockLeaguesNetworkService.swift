import XCTest
@testable import Sportify

class MockLeaguesNetworkService: LeaguesNetworkServiceProtocol {
    
    let mockLeaguesResponse = LeaguesJsonToString.leaguesString

    func getAllLeagues(forSport sport: String, completion: @escaping ([Sportify.ResultFootball]?, Error?) -> Void) {
        let data = Data(mockLeaguesResponse.utf8)
        do {
            let response = try JSONDecoder().decode(ResponseFootball.self, from: data)
            completion(response.result, nil)
        } catch {
            completion(nil, error)
        }
    }
        
}
