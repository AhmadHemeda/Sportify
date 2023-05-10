import UIKit
import CoreData

class CoreDataManager {
    var context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext? = nil) {
        self.context = context
    }
    
    func insertTeam(teamKey: Int, teamName: String, teamLogo: Data) {
        if let existingTeam = fetchTeam(teamKey: teamKey) {
            existingTeam.setValue(teamName, forKey: "teamName")
            existingTeam.setValue(teamLogo, forKey: "teamLogo")
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Team", in: context!)
            let teamEntity = NSManagedObject(entity: entity!, insertInto: context)
            teamEntity.setValue(teamKey, forKey: "teamKey")
            teamEntity.setValue(teamName, forKey: "teamName")
            teamEntity.setValue(teamLogo, forKey: "teamLogo")
        }
        
        do {
            try context!.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func fetchTeam(teamKey: Int) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Team")
        let predicate = NSPredicate(format: "teamKey == %d", teamKey)
        fetchRequest.predicate = predicate
        do {
            let teams = try context?.fetch(fetchRequest)
            return teams?.first
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getAllTeams() -> [FavoriteTeam] {
        var teamArray : [FavoriteTeam] = []
        var teamObj : FavoriteTeam!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Team")
        
        do {
            let teams = try context?.fetch(fetchRequest)
            for team in teams!{
                teamObj = FavoriteTeam(teamKey: team.value(forKey: "teamKey") as? Int ,teamLogo: team.value(forKey: "teamLogo") as? Data ,teamName: team.value(forKey: "teamName") as? String  )
                
                teamArray.append(teamObj)
            }
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        return teamArray
    }
    
    func deleteTeam(teamName: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Team")
        let predicate = NSPredicate(format: "teamName == %@", teamName)
        
        fetchRequest.predicate = predicate
        
        do {
            let teamObject = try context?.fetch(fetchRequest)
            
            context?.delete(teamObject![0])
            try context?.save()
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
