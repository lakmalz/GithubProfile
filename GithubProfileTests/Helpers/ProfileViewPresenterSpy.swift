import XCTest
@testable import GithubProfile
class ProfileViewPresenterSpy: ProfileView {
    
    var refreshProfileViewCalled = false
    var refreshRepositoriesCalled = false
    
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var endPullToRefreshCalled = false
    
    var displayOnErrorMessage: String?
    var deletedRow: Int?
    var endEditingCalled = false
    
    func refreshProfileView() {
        refreshProfileViewCalled = true
    }
    
    func refreshRepositories() {
        refreshRepositoriesCalled = true
    }
    
    func onError(errorMessage: String) {
        displayOnErrorMessage = errorMessage
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func endPullToRefresh() {
        endPullToRefreshCalled = true
    }
    
    

}
