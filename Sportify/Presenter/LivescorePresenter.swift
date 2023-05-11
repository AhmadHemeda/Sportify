class LivescorePresenter {
    
    let leagueDetailsNetworkService = LeagueDetailsNetworkService()
    
    func getLivescore(leagueDetailsProtocol: LeagueDetailsProtocol, sport: String) {
        leagueDetailsNetworkService.getLivescore(forSport: sport) { (results, error) in
            if let error = error {
                print("Error fetching data:", error.localizedDescription)
                return
            }
            guard let results = results else {
                print("No results found.")
                return
            }
            leagueDetailsProtocol.renderLivescoreCollectionView(livescores: results)
            
        }
    }
    
}
