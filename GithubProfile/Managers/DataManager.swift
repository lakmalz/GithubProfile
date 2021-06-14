import Foundation


public class DataManager: Service {
    
    public static var instance = DataManager()
    
    func loadProfile(finish: @escaping (Profile?) -> Void) {
        let query = GitProfileQuery(gitName: GIT_USER_NAME)
        NetworkManager.instance.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                if let userProfile = graphQLResult.data?.user{
                    var profile = Profile(name: userProfile.name ?? "", email: userProfile.email, followers: userProfile.followers.totalCount, following: userProfile.following.totalCount, imageUrl: userProfile.avatarUrl, loginName: userProfile.login)
                    
                    var pinnedRepositories:[RepositoryItem] = []
                    userProfile.pinnedItems.nodes?.forEach { node in
                        let repo = node?.fragments.repositoryFragment
                        pinnedRepositories.append(self.processRepository(repo: repo))
                    }
                    profile.pinnedRepositories = pinnedRepositories
                    
                    var topRepositories:[RepositoryItem] = []
                    userProfile.topRepositories.nodes?.forEach { node in
                        let repo = node?.fragments.repositoryFragment
                        topRepositories.append(self.processRepository(repo: repo))
                    }
                    profile.topRepositories = topRepositories
                    
                    var starredRepositories:[RepositoryItem] = []
                    userProfile.starredRepositories.nodes?.forEach { node in
                        let repo = node?.fragments.repositoryFragment
                        starredRepositories.append(self.processRepository(repo: repo))
                    }
                    profile.starredRepositories = starredRepositories
                    finish(profile)
                }
                
            case .failure(let error):
                print(error)
                return finish(nil)
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
