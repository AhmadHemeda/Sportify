import Foundation

class LeagueDetailsNetworkService {
    
    let baseUrl = "https://apiv2.allsportsapi.com/"
    let apiKey = "e52ecd181c43330ca2817d83ad2ca66f343324dd638d18e240bdc67666bd0cad"
    let dateFormatter = DateFormatter()
    
    func getData(forLeagueID leagueID: Int, forSport sport: String, fromDate: Date, toDate: Date, completion: @escaping ([Result]?, Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDateString = dateFormatter.string(from: fromDate)
        let toDateString = dateFormatter.string(from: toDate)
        let urlString = "\(baseUrl)\(sport.lowercased())/?met=Fixtures&APIkey=\(apiKey)&leagueId=\(leagueID)&from=\(fromDateString)&to=\(toDateString)"
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
                let fixture = try decoder.decode(Fixture.self, from: data)
                completion(fixture.result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getLivescore(forSport sport: String, completion: @escaping ([LivescoreResult]?, Error?) -> Void) {
        let urlString = "\(baseUrl)\(sport.lowercased())/?met=Livescore&APIkey=\(apiKey)"
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
                let livescore = try decoder.decode(Livescore.self, from: data)
                completion(livescore.result, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
