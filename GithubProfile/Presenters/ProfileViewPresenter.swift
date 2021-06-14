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

protocol Service {
    func loadProfile(finish: @escaping (Profile?) -> Void)
}

class ProfileViewPresenterImplementation {
    private var dataService: Service?
    fileprivate weak var view: ProfileView?
    
    private var profile: Profile?
    private var tableViewSection: [TableSection] = []
    var pinnedRepositories: [RepositoryItem] = []
    var topRepositories: [RepositoryItem] = []
    var starredRepositories: [RepositoryItem] = []
    
    required init(dataService: Service, view: ProfileView) {
        self.dataService = dataService
        self.view = view
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
        _ = CacheManager.instance.removeAllObjects()
        self._loadProfile(isRefresh: true)
    }
    
    private func _loadProfile(isRefresh: Bool = false) {
        clearPreviousRecords()
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
            service.loadProfile(finish: { (profile) in
                if(!isRefresh){
                    self.view?.hideLoading()
                }else{
                    self.view?.endPullToRefresh()
                }
                if let profile = profile, let view = self.view {
                    self.profile = profile
                    view.refreshProfileView()
                    
                    self.pinnedRepositories = profile.pinnedRepositories ?? []
                    self.tableViewSection.append(TableSection(repositoryType: .pinnedRepositories, repositories: self.pinnedRepositories))
                    
                    self.topRepositories = profile.topRepositories ?? []
                    self.tableViewSection.append(TableSection(repositoryType: .topRepositories, repositories: self.topRepositories))
                    
                    self.starredRepositories = profile.starredRepositories ?? []
                    self.tableViewSection.append(TableSection(repositoryType: .starreedRepositories, repositories: self.starredRepositories))
                    
                    CacheManager.instance.setStoredProfile(value: profile)
                    view.refreshRepositories()
                }
                
            })
        }
    }
    
    func clearPreviousRecords(){
        self.pinnedRepositories = []
        self.topRepositories = []
        self.starredRepositories = []
        self.tableViewSection = []
        view?.refreshRepositories()
    }
}
