import UIKit
import Reachability
import Kingfisher

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fixtureCollectionView {
            return fixtures.isEmpty == true ? 1 : fixtures.count
        } else if collectionView == livescoreCollectionView {
            return livescores.isEmpty == true ? 1 : livescores.count
        } else if collectionView == teamsCollectionView {
            return teams.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fixtureCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fixtureCell", for: indexPath) as! FixturesCollectionViewCell
            if fixtures.isEmpty == true {
                configureCellAppearance(cell: cell)
                configureEmptyFixtureCell(cell: cell)
            } else {
                configureCellAppearance(cell: cell)
                configureFixtureCell(cell: cell, fixture: fixtures[indexPath.row])
            }
            return cell
        } else if collectionView == livescoreCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livescoreCell", for: indexPath) as! LivescoreCollectionViewCell
            if livescores.isEmpty == true {
                configureCellAppearance(cell: cell)
                configureEmptyLivescoreCell(cell: cell)
            } else {
                configureCellAppearance(cell: cell)
                configureLivescoreCell(cell: cell, livescore: livescores[indexPath.row])
            }
            return cell
        } else if collectionView == teamsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath) as! TeamsCollectionViewCell
            configureTeamCell(cell: cell, team: teams[indexPath.row])
            return cell
        } else {
            fatalError()
        }
    }
    
    func configureEmptyFixtureCell(cell: FixturesCollectionViewCell) {
        cell.vsLabel.text = "Sorry"
        cell.timeLabel.text = "No fixtures"
        cell.dateLabel.text = "Try later"
        cell.awayTeamLabel.text = ""
        cell.homeTeamLabel.text = ""
    }
    
    func configureEmptyLivescoreCell(cell: LivescoreCollectionViewCell) {
        cell.scoreLabel.text = "Sorry"
        cell.timeLabel.text = "No livescore"
        cell.dateLabel.text = "Try later"
        cell.awayTeamNameLabel.text = ""
        cell.homeTeamNameLabel.text = ""
    }
    
    func configureCellAppearance(cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 10.0
    }
    
    func configureFixtureCell(cell: FixturesCollectionViewCell, fixture: Result) {
        cell.timeLabel.text = fixture.event_time
        cell.dateLabel.text = fixture.event_date
        cell.vsLabel.text = "VS"
        
        if sport == "Tennis" {
            cell.homeTeamLabel.text = fixture.event_first_player
            cell.awayTeamLabel.text = fixture.event_second_player
            if let homeTeamLogoUrl = fixture.event_first_player_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = fixture.event_second_player_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        } else if sport == "Basketball" || sport == "Cricket" {
            cell.homeTeamLabel.text = fixture.event_home_team
            cell.awayTeamLabel.text = fixture.event_away_team
            if let homeTeamLogoUrl = fixture.event_home_team_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = fixture.event_away_team_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        } else {
            cell.homeTeamLabel.text = fixture.event_home_team
            cell.awayTeamLabel.text = fixture.event_away_team
            if let homeTeamLogoUrl = fixture.home_team_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = fixture.away_team_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        }
    }
    
    func configureLivescoreCell(cell: LivescoreCollectionViewCell, livescore: LivescoreResult) {
        cell.timeLabel.text = livescore.event_time
        
        if sport == "Tennis" {
            cell.homeTeamNameLabel.text = livescore.event_first_player
            cell.awayTeamNameLabel.text = livescore.event_second_player
            if let homeTeamLogoUrl = livescore.event_first_player_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = livescore.event_second_player_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        } else if sport == "Basketball" || sport == "Cricket" {
            cell.homeTeamNameLabel.text = livescore.event_home_team
            cell.awayTeamNameLabel.text = livescore.event_away_team
            if let homeTeamLogoUrl = livescore.event_home_team_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = livescore.event_away_team_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        } else {
            cell.homeTeamNameLabel.text = livescore.event_home_team
            cell.awayTeamNameLabel.text = livescore.event_away_team
            if let homeTeamLogoUrl = livescore.home_team_logo, let url = URL(string: homeTeamLogoUrl) {
                cell.homeTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.homeTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
            if let awayTeamLogoUrl = livescore.away_team_logo, let url = URL(string: awayTeamLogoUrl) {
                cell.awayTeamLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_" + sport.lowercased()))
            } else {
                cell.awayTeamLogo.image = UIImage(named: "placeholder_" + sport.lowercased())
            }
        }
        
        if sport == "Cricket" {
            cell.dateLabel.text = livescore.event_date_start
            
            if let homeScore = livescore.event_home_final_result, let awayScore = livescore.event_away_final_result {
                cell.scoreLabel.text = "\(homeScore) - \(awayScore)"
            }
        } else {
            cell.dateLabel.text = livescore.event_date
            cell.scoreLabel.text = livescore.event_final_result
        }
    }
    
    func configureTeamCell(cell: TeamsCollectionViewCell, team: Teams) {
        if let teamLogo = team.teamLogo, let url = URL(string: teamLogo) {
            cell.teamLogoImageView.kf.setImage(with: url)
        } else {
            cell.teamLogoImageView.image = UIImage(named: "placeholder_" + sport.lowercased())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView == teamsCollectionView ? collectionView.bounds.width / 3 : collectionView.bounds.width
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reachability = try? Reachability()
        manager = ReachabilityNetworkManager(reachability: reachability)
        
        if manager!.isReachableViaWiFi() {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController {
                
                guard collectionView == teamsCollectionView else {
                    return
                }
                
                if self.sport == "Basketball" || self.sport == "Cricket" {
                    let alert = UIAlertController(title: "No Players Details", message: "There are no player details available for \(self.sport)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    viewController.sportName = self.sport
                    viewController.teamID = self.teams[indexPath.row].teamKey!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            
            return
        }
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
