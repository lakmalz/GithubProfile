import Foundation

protocol GithubProfileViewDelegate : AnyObject {
    func onProfileDetail(profile: Profile)
    func onRetrive(repositories: [RepositoryItem], ofType type: eRepositoryType)
    func onError(errorMessage: String)
}

class ProfileViewPresenter {
    weak var delegate:GithubProfileViewDelegate?
    weak var dataService: NetworkManager?
    
    required init(dataService: NetworkManager, delegate: GithubProfileViewDelegate) {
        self.delegate = delegate
        self.dataService = dataService
    }
    
    func retrieveGitProfileInfo() {
        let query = GitProfileQuery(gitName: "cnoon")
        guard let service = dataService else {
            fatalError("Service need to be initialized")
        }
        service.client.fetch(query: query) { result in
          switch result {
          case .success(let graphQLResult):
            if let userProfile = graphQLResult.data?.user, let delegate = self.delegate {
                let profile = Profile(name: userProfile.name ?? "", email: userProfile.email, followers: userProfile.followers.totalCount, following: userProfile.following.totalCount, imageUrl: userProfile.avatarUrl, loginName: userProfile.login)
                delegate.onProfileDetail(profile: profile)
                
                var pinnedRepositories = [RepositoryItem]()
                userProfile.pinnedItems.nodes?.forEach { node in
                    let repo = node?.fragments.repositoryFragment
                    pinnedRepositories.append(self.processRepository(repo: repo))
                }
                delegate.onRetrive(repositories:pinnedRepositories, ofType: eRepositoryType.pinnedRepositories)
                
                var topRepositories = [RepositoryItem]()
                userProfile.topRepositories.nodes?.forEach { node in
                    let repo = node?.fragments.repositoryFragment
                    topRepositories.append(self.processRepository(repo: repo))
                }
                delegate.onRetrive(repositories:topRepositories, ofType: eRepositoryType.topRepositories)
                
                var starredRepositories = [RepositoryItem]()
                userProfile.starredRepositories.nodes?.forEach { node in
                    let repo = node?.fragments.repositoryFragment
                    starredRepositories.append(self.processRepository(repo: repo))
                }
                delegate.onRetrive(repositories:starredRepositories, ofType: eRepositoryType.starreedRepositories)
                
            }
                
          case .failure(let error):
            if let delegaet = self.delegate{
                delegaet.onError(errorMessage: error.localizedDescription)
            }
          }
        }
    }
    
    private func processRepository(repo: RepositoryFragment?) -> RepositoryItem {
        var ownerName = "", ownerImageUrl = ""
        if let user = repo?.owner.asUser {
            ownerName = user.login
            ownerImageUrl = user.avatarUrl
        } else if let org = repo?.owner.asOrganization {
            ownerName = org.name ?? "N/A"
            ownerImageUrl = org.avatarUrl
        }
        
        return RepositoryItem(ownerName: ownerName, ownerImage: ownerImageUrl, repoName: repo?.name ?? "N/A",
                                  reposDesc: repo?.description ?? "N/A",
                                  starCount: "\(repo?.stargazerCount ?? 0)",
                                  language: repo?.primaryLanguage?.name ?? "N/A",
                                  languageColor: repo?.primaryLanguage?.color ?? "#FFFF")
    }
}
