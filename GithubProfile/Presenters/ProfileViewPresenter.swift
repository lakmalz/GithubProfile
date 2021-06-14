import Foundation


protocol ProfileInfoView {
    func display(name: String)
    func display(loginName: String)
    func display(email: String)
    func display(followersCount: String)
    func display(followingCount: String)
    func display(profileUrl: String)
}

protocol TableSctionHeaderView {
    func setHeder(header: String)
    func setAction(forViewAll action:@escaping  () ->())
}

protocol RepositoryView {
    
    func display(userName: String)
    func display(repositoryName: String)
    func display(repositoryDescription: String)
    func display(starCount: String)
    func display(language: String)
    func display(languageColor: String)
    func display(profileUrl: String)
}

protocol ProfileView: class {
    func refreshProfileView()
    func refreshRepositories()
    func onError(errorMessage: String)
    func showLoading()
    func hideLoading()
    func endPullToRefresh()
    
}

protocol ProfileViewPresenter {
    func viewDidLoad()
    var numberOfTableSectoins: Int { get }
    func numberOfRowsInSection(section: Int) -> Int
    func sectionRepositoryTypefor(section: Int) -> eRepositoryType
    func setupProfileView(view: ProfileInfoView)
    func setupTableViewHeader(for view: TableSctionHeaderView, forSection section: Int)
    func configure(forCell cell: RepositoryView, forRow row: Int, repositoryType type: eRepositoryType)
    func numberOfRepositoriesForType(repositoryType type: eRepositoryType) -> Int
    func refreshProfile()
}

class ProfileViewPresenterImplementation {
    weak var dataService: NetworkManager?
    fileprivate weak var view: ProfileView?
    
    private var profile: Profile?
    private var tableViewSection: [TableSection] = []
    var pinnedRepositories: [RepositoryItem] = []
    var topRepositories: [RepositoryItem] = []
    var starredRepositories: [RepositoryItem] = []
    
    required init(dataService: NetworkManager, view: ProfileView) {
        self.dataService = dataService
        self.view = view
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

extension ProfileViewPresenterImplementation: ProfileViewPresenter{
    func numberOfRowsInSection(section: Int) -> Int {
        let section = tableViewSection[section]
        if(section.repositoryType == .pinnedRepositories){
            return (section.repositories.count > 3) ? 3 : section.repositories.count
        }else {
            return 1
        }
    }
    
    func numberOfRepositoriesForType(repositoryType type: eRepositoryType) -> Int {
        switch type {
        case .pinnedRepositories:
            return self.pinnedRepositories.count
        case .starreedRepositories:
            return self.starredRepositories.count
        case .topRepositories:
            return self.topRepositories.count
        }
    }
    
    func sectionRepositoryTypefor(section: Int) -> eRepositoryType {
        return self.tableViewSection[section].repositoryType
    }
    
    var numberOfTableSectoins: Int {
        return self.tableViewSection.count
    }
    
    func configure(forCell cell: RepositoryView, forRow row: Int, repositoryType type: eRepositoryType) {
        let repository: RepositoryItem?
        switch type {
        case .pinnedRepositories:
            repository = self.pinnedRepositories[row]
        case .starreedRepositories:
            repository = self.starredRepositories[row]
        case .topRepositories:
            repository = self.topRepositories[row]
        }
        
        if let repository = repository{
            cell.display(userName: repository.ownerName)
            cell.display(repositoryName: repository.repoName)
            cell.display(repositoryDescription: repository.reposDesc)
            cell.display(starCount: repository.starCount)
            cell.display(language: repository.language)
            cell.display(languageColor: repository.languageColor)
            cell.display(profileUrl: repository.ownerImage)
        }
    }
    
    func setupTableViewHeader(for view: TableSctionHeaderView, forSection section: Int) {
        let section = tableViewSection[section]
        view.setAction {
            print(section.repositoryType.description + " pressed")
        }
        view.setHeder(header: section.repositoryType.description)
    }
    
    func setupProfileView(view: ProfileInfoView) {
        if let profile = profile {
            view.display(email: profile.email)
            view.display(name: profile.name)
            view.display(loginName: profile.loginName)
            view.display(profileUrl: profile.imageUrl)
            view.display(followersCount: "\(profile.followers)")
            view.display(followingCount: "\(profile.following)")
        }
    }
    
    func viewDidLoad() {
        _loadProfile()
    }
    
    func refreshProfile() {
        _ = CacheManager.instance.clearExpiredObjects()
        _loadProfile(isRefresh: true)
    }
    
    private func _loadProfile(isRefresh: Bool = false) {

        self.pinnedRepositories.removeAll()
        self.topRepositories.removeAll()
        self.starredRepositories.removeAll()
        self.tableViewSection.removeAll()
        let query = GitProfileQuery(gitName: "cnoon")
        guard let service = dataService else {
            fatalError("Service need to be initialized")
        }
        if(!isRefresh){
            view?.showLoading()
        }
        if let profile = CacheManager.instance.getStoredProfile(){
            self.profile = profile
            self.topRepositories = profile.topRepositories ?? []
            self.pinnedRepositories = profile.pinnedRepositories ?? []
            self.starredRepositories = profile.starredRepositories ?? []
            
            self.tableViewSection.append(TableSection(repositoryType: .pinnedRepositories, repositories: self.pinnedRepositories))
            self.tableViewSection.append(TableSection(repositoryType: .topRepositories, repositories: self.topRepositories))
            self.tableViewSection.append(TableSection(repositoryType: .starreedRepositories, repositories: self.starredRepositories))
            
            view?.refreshProfileView()
            view?.refreshRepositories()
            
            if(!isRefresh){
                view?.hideLoading()
            }else{
                view?.endPullToRefresh()
            }
        }else{
            service.client.fetch(query: query) { result in
                if(!isRefresh){
                    self.view?.hideLoading()
                }else{
                    self.view?.endPullToRefresh()
                }
                switch result {
                case .success(let graphQLResult):
                    if let userProfile = graphQLResult.data?.user, let view = self.view {
                        
                        var profile = Profile(name: userProfile.name ?? "", email: userProfile.email, followers: userProfile.followers.totalCount, following: userProfile.following.totalCount, imageUrl: userProfile.avatarUrl, loginName: userProfile.login)
                        
                        self.profile = profile
                        view.refreshProfileView()
                        
                        var pinnedRepositories:[RepositoryItem] = []
                        userProfile.pinnedItems.nodes?.forEach { node in
                            let repo = node?.fragments.repositoryFragment
                            pinnedRepositories.append(self.processRepository(repo: repo))
                        }
                        self.pinnedRepositories = pinnedRepositories
                        profile.pinnedRepositories = pinnedRepositories
                        self.tableViewSection.append(TableSection(repositoryType: .pinnedRepositories, repositories: self.pinnedRepositories))
                        
                        var topRepositories:[RepositoryItem] = []
                        userProfile.topRepositories.nodes?.forEach { node in
                            let repo = node?.fragments.repositoryFragment
                            topRepositories.append(self.processRepository(repo: repo))
                        }
                        self.topRepositories = topRepositories
                        profile.topRepositories = topRepositories
                        self.tableViewSection.append(TableSection(repositoryType: .topRepositories, repositories: self.topRepositories))
                        
                        var starredRepositories:[RepositoryItem] = []
                        userProfile.starredRepositories.nodes?.forEach { node in
                            let repo = node?.fragments.repositoryFragment
                            starredRepositories.append(self.processRepository(repo: repo))
                        }
                        self.starredRepositories = starredRepositories
                        profile.starredRepositories = starredRepositories
                        self.tableViewSection.append(TableSection(repositoryType: .starreedRepositories, repositories: self.starredRepositories))
                        
                        CacheManager.instance.setStoredProfile(value: profile)
                        view.refreshRepositories()
                        
                    }
                    
                case .failure(let error):
                    self.view?.onError(errorMessage: error.localizedDescription)
                }
            }
        }
    }
}
