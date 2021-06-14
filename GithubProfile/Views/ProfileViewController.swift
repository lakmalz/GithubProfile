import UIKit
import SnapKit
import PKHUD

class ProfileViewController: UIViewController {
    
    let kTableCellIdentifier = "PinnedRepoTableViewCell"
    let tableViewItemHeight : CGFloat = 190
    private var presenter: ProfileViewPresenter?
    private lazy var profileDetailView = ProfileDetailView()
    private var starredHorizontalView: HorizontalRepocitoryTableViewCell?
    private var topHorizontalView: HorizontalRepocitoryTableViewCell?
    private lazy var refreshControl = UIRefreshControl()

    private let tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfileViewPresenterImplementation.init(dataService: DataManager.instance, view: self)
        setupUI()
        presenter?.viewDidLoad()
        
    }
    
    private func setupUI(){
        tableView.register(PinnedRepoTableViewCell.self, forCellReuseIdentifier: kTableCellIdentifier)
        tableView.register(HorizontalRepocitoryTableViewCell.self, forCellReuseIdentifier: kHorizontalRepocitoryCellIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshProfile(_:)), for: .valueChanged)
        
        let profileLabel = UILabel.init()
        profileLabel.text = "Profile"
        profileLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.view.addSubview(profileLabel)
        profileLabel.snp.makeConstraints { (constaint) in
            constaint.centerX.equalTo(self.view)
            constaint.height.equalTo(24)
            constaint.top.equalTo(self.view.snp.topMargin).offset(16)
        }
        
        self.view.addSubview(profileDetailView)
        profileDetailView.snp.makeConstraints { (constraint) in
            constraint.leading.equalTo(self.view.snp.leading).offset(16)
            constraint.trailing.equalTo(self.view.snp.trailing).offset(-16)
            constraint.top.equalTo(profileLabel.snp.bottom).offset(40)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor().colorFromHexString(background_color)
        
           tableView.addSubview(refreshControl)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.top.equalTo(profileDetailView.snp.bottom).offset(25)
            make.bottom.equalTo(self.view.snp.bottom).offset(10)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfTableSectoins ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: tableView.frame)
        let sectionHeader = RepoSectionHeader.init(frame: tableView.frame)
        view.addSubview(sectionHeader)
        sectionHeader.snp.makeConstraints { (constraint) in
            constraint.left.equalTo(view.snp.left)
            constraint.right.equalTo(view.snp.right)
        }
        presenter?.setupTableViewHeader(for: sectionHeader, forSection: section)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let repositoryType = presenter?.sectionRepositoryTypefor(section: indexPath.section)
        if(repositoryType == .pinnedRepositories){
            let cell = tableView.dequeueReusableCell(withIdentifier: kTableCellIdentifier, for: indexPath) as! PinnedRepoTableViewCell
            cell.selectionStyle = .none
            presenter?.configure(forCell: cell, forRow: indexPath.row, repositoryType: .pinnedRepositories)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: kHorizontalRepocitoryCellIdentifier, for: indexPath) as! HorizontalRepocitoryTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = repositoryType?.tag ?? 1
            cell.selectionStyle = .none
            cell.bringSubviewToFront(cell.collectionView)
            switch presenter?.sectionRepositoryTypefor(section: indexPath.section) {
            case .starreedRepositories:
                    starredHorizontalView = cell
            case .topRepositories:
                    topHorizontalView = cell
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewItemHeight
    }
    
    @objc func refreshProfile(_ sender: AnyObject){
        presenter?.refreshProfile()
    }
}


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == starredHorizontalView?.collectionView {
            return presenter?.numberOfRepositoriesForType(repositoryType: .topRepositories) ?? 0
        } else if collectionView == topHorizontalView?.collectionView {
            return presenter?.numberOfRepositoriesForType(repositoryType: .starreedRepositories) ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHorizontalRepositoryCollectionCellIdentifier,
                                                            for: indexPath) as? HorizontalRepositoryCollectionView else { return UICollectionViewCell() }
        if collectionView == topHorizontalView?.collectionView  {
            presenter?.configure(forCell: cell, forRow: indexPath.row, repositoryType: .topRepositories)
        } else if collectionView == starredHorizontalView?.collectionView  {
            presenter?.configure(forCell: cell, forRow: indexPath.row, repositoryType: .starreedRepositories)
        }
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        return CGSize(width: screenWidth*3/5, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

extension ProfileViewController: ProfileView{
    func endPullToRefresh() {
        refreshControl.endRefreshing()
    }
    
    func showLoading() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    func refreshProfileView() {
        presenter?.setupProfileView(view: profileDetailView)
    }
    
    func refreshRepositories() {
        self.tableView.reloadData()
        self.starredHorizontalView?.collectionView.reloadData()
        self.topHorizontalView?.collectionView.reloadData()
    }
    
    func onError(errorMessage: String) {
        print(errorMessage)
    }
}

struct TableSection {
    var repositoryType: eRepositoryType
    var repositories: [RepositoryItem]
}
