class TeamDetailsPresenter {
    
    let teamDetailsNetworkService = TeamDetailsNetworkService()
    
    func getTeamDetails(teamDetailsProtocol: TeamDetailsProtocol, teamID: Int, sportName: String) {
        teamDetailsNetworkService.getTeamDetails(forTeamID: teamID, forSport: sportName) { results, error in
            guard let results = results else {
                if let error = error {
                    print("Error fetching data:", error.localizedDescription)
                } else {
                    print("No results found.")
                }
                return
            }
            teamDetailsProtocol.trenderTeamDetailsTableView(teamDetailsResult: results)
        }
    }
    
}
