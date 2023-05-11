import XCTest
@testable import Sportify

class LeagueDetailsNetworkServiceTests: XCTestCase {

    var service: LeagueDetailsNetworkService!

    override func setUp() {
        super.setUp()
        service = LeagueDetailsNetworkService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testGetData() {
        let expectation = expectation(description: "Fetching fixture data")
        var error: Error?
        var result: [Result]?
        let calendar = Calendar(identifier: .gregorian)
        let fromDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        let toDate = calendar.date(byAdding: .day, value: 7, to: Date())!

        service.getData(forLeagueID: 123, forSport: "Football", fromDate: fromDate, toDate: toDate) { (results, err) in
            error = err
            result = results
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(result)
        XCTAssertNil(error)
    }
    
    func testGetLivescore() {
        let expectation = expectation(description: "Fetching livescore data")
        var error: Error?
        var livescore: [LivescoreResult]?
        
        service.getLivescore(forSport: "Football") { (result, err) in
            error = err
            livescore = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        XCTAssertNil(error)
        XCTAssertNotNil(livescore)
    }
}
