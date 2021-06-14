import Foundation
@testable import GithubProfile

class MockDataManager: Service {
    private(set) var getHasBeenCalled: Bool = false
    
    func loadProfile(finish: @escaping (Profile?) -> Void) {
        getHasBeenCalled = true
        let profile = Profile(name: "FlammerSL", email: "ranasinghe.i.u@gmail.com", followers: 10, following: 10, imageUrl: "imgUrl.png", loginName: "Isuru", pinnedRepositories: [RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7"),RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7")], topRepositories: [RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7"),RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7")], starredRepositories: [RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7"),RepositoryItem(ownerName: "Isuru", ownerImage: "owner.png", repoName: "pinnedRepo1", reposDesc: "pinnedRep1Des", starCount: "7", language: "Swift", languageColor: "#f7f7f7")])
        finish(profile)
    }
    
    
}
