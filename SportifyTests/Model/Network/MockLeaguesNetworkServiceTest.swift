import XCTest
@testable import Sportify

final class MockLeaguesNetworkServiceTest: XCTestCase {
    
    let mockLeaguesNetworkService = MockLeaguesNetworkService()
    
    func testGetResults() {
        let expectation = expectation(description: "Leagues data should not be nil")
        
        mockLeaguesNetworkService.getAllLeagues(forSport: "football") { leagues, error in
            guard let leagues = leagues else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertNotNil(leagues, "Leagues data should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
}
