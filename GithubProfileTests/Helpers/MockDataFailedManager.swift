import Foundation
@testable import GithubProfile

class MockDataFailedManager: Service {
    private(set) var getHasBeenCalled: Bool = false
    
    func loadProfile(finish: @escaping (Profile?) -> Void) {
        getHasBeenCalled = true
        finish(nil)
    }
    
    
}
