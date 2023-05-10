import XCTest
@testable import Sportify

final class TeamDetailsNetworkServiceTest: XCTestCase {
    
    var networkService: TeamDetailsProtocol!
    
    override func setUp() {
        super.setUp()
        networkService = TeamDetailsNetworkService()
    }
    
    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    func testGetTeamDetails() {
        let expectation = expectation(description: "Expecting team details")
        
        let teamID = 88
        let sport = "Football"
        
        networkService.getTeamDetails(forTeamID: teamID, forSport: sport) { (results, error) in
            XCTAssertNotNil(results, "Expecting team details")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetTeamDetailsWithInvalidTeamID() {
        let expectation = expectation(description: "Expecting error")

        let teamID = -1
        let sport = "Football"

        networkService.getTeamDetails(forTeamID: teamID, forSport: sport) { (results, error) in
            XCTAssertNil(results, "Not expecting team details")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetTeamDetailsWithInvalidSport() {
        let expectation = expectation(description: "Expecting error")

        let teamID = 88
        let sport = "InvalidSport"

        networkService.getTeamDetails(forTeamID: teamID, forSport: sport) { (results, error) in
            XCTAssertNil(results, "Not expecting team details")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetTeamDetailsWithEmptyResult() {
        let expectation = expectation(description: "Expecting empty result")

        let teamID = 999
        let sport = "Football"

        networkService.getTeamDetails(forTeamID: teamID, forSport: sport) { (results, error) in
            XCTAssertTrue(!results!.isEmpty , "Expecting empty result")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
