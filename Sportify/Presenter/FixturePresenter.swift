import Foundation

class FixturePresenter {
    
    let dateFormatter = DateFormatter()
    let leagueDetailsNetworkService = LeagueDetailsNetworkService()
    
    func getFixtures(leagueDetailsProtocol: LeagueDetailsProtocol, leagueID: Int, sport: String) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 15, to: today)!
        
        leagueDetailsNetworkService.getData(forLeagueID: leagueID, forSport: sport, fromDate: today, toDate: nextWeek) { (results, error) in
            if let error = error {
                print("Error fetching data:", error.localizedDescription)
                return
            }
            guard let results = results else {
                print("No results found.")
                return
            }
            leagueDetailsProtocol.renderFixtureCollectionView(result: results)
        }
    }
    
}
