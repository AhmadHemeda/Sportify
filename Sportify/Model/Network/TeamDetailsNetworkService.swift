import Foundation

protocol TeamDetailsNetworkServiceProtocol {
    
    func getTeamDetails(forTeamID teamID: Int, forSport sport: String, completion: @escaping ([TeamDetailsResult]?, Error?) -> Void)
    
}

class TeamDetailsNetworkService: TeamDetailsNetworkServiceProtocol {
    
    let baseUrl = "https://apiv2.allsportsapi.com/"
    let apiKey = "e52ecd181c43330ca2817d83ad2ca66f343324dd638d18e240bdc67666bd0cad"
    
    func getTeamDetails(forTeamID teamID: Int, forSport sport: String, completion: @escaping ([TeamDetailsResult]?, Error?) -> Void) {
        let urlString = "\(baseUrl)\(sport.lowercased())/?met=Teams&teamId=\(teamID)&APIkey=\(apiKey)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.example.networkservice", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"]))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let team = try decoder.decode(TeamsDetails.self, from: data)
                completion(team.result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
