import Foundation

protocol LeaguesProtocol {
    
    func getAllLeagues(forSport sport: String, completion: @escaping ([ResultFootball]?, Error?) -> Void)
    
}

class LeaguesNetworkService: LeaguesProtocol {
    
    let baseUrl = "https://apiv2.allsportsapi.com/"
    let apiKey = "e52ecd181c43330ca2817d83ad2ca66f343324dd638d18e240bdc67666bd0cad"
    
    func getAllLeagues(forSport sport: String, completion: @escaping ([ResultFootball]?, Error?) -> Void) {
        let urlString = "\(baseUrl)\(sport.lowercased())/?met=Leagues&APIkey=\(apiKey)"
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
                let leagues = try decoder.decode(ResponseFootball.self, from: data)
                completion(leagues.result, nil)
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
}
