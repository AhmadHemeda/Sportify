import XCTest
@testable import Sportify

class LeaguesNetworkServiceTests: XCTestCase {

    var service: LeaguesNetworkService!

    override func setUpWithError() throws {
        super.setUp()
        service = LeaguesNetworkService()
    }

    override func tearDownWithError() throws {
        service = nil
        super.tearDown()
    }

    func testGetAllLeagues() throws {
        let expectation = self.expectation(description: "Fetching all leagues data")
        var error: Error?
        var leagues: [ResultFootball]?

        service.getAllLeagues(forSport: "football") { (result, err) in
            error = err
            leagues = result
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(error)
        XCTAssertNotNil(leagues)
    }

}
