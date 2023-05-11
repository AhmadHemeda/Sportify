import XCTest
import CoreData
@testable import Sportify

class CoreDataManagerTests: XCTestCase {
    var context: NSManagedObjectContext!
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()

        // In-memory persistent store coordinator for testing
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel.mergedModel(from: [Bundle.main])!)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

        // Setup Core Data stack
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        context = managedObjectContext

        // Initialize CoreDataManager with the context
        coreDataManager = CoreDataManager(context: context)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInsertTeam() {
        // When
        coreDataManager.insertTeam(teamKey: 1, teamName: "Team A", teamLogo: Data())

        // Then
        let team = fetchTeam(teamKey: 1)
        XCTAssertNotNil(team)
        XCTAssertEqual(team?.value(forKey: "teamName") as? String, "Team A")
    }

    func testFetchTeam() {
        // Givin
        insertTestData()

        // When
        let team = coreDataManager.fetchTeam(teamKey: 2)

        // Then
        XCTAssertNotNil(team)
        XCTAssertEqual(team?.value(forKey: "teamName") as? String, "Team B")
    }

    func testGetAllTeams() {
        // Givin
        insertTestData()

        // When
        let teams = coreDataManager.getAllTeams()

        // Then
        XCTAssertEqual(teams.count, 2)
    }

    func testDeleteTeam() {
        // Givin
        insertTestData()

        // When
        coreDataManager.deleteTeam(teamName: "Team B")

        // Then
        let team = fetchTeam(teamKey: 2)
        XCTAssertNil(team)
    }

    // MARK: - Helper Methods

    private func insertTestData() {
        coreDataManager.insertTeam(teamKey: 1, teamName: "Team A", teamLogo: Data())
        coreDataManager.insertTeam(teamKey: 2, teamName: "Team B", teamLogo: Data())
    }

    private func fetchTeam(teamKey: Int) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Team")
        let predicate = NSPredicate(format: "teamKey == %d", teamKey)
        fetchRequest.predicate = predicate
        do {
            let teams = try context.fetch(fetchRequest)
            return teams.first
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}
