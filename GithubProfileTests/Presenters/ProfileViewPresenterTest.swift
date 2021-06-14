import XCTest
@testable import GithubProfile

class ProfileViewPresenterTest: XCTestCase {
    private var mockDataManager =  MockDataManager()
    var profilePresenter: ProfileViewPresenterImplementation!
    var profileView = ProfileViewPresenterSpy()
    
    override func setUp() {
        super.setUp()
        _ = CacheManager.instance.removeAllObjects()
        profilePresenter = ProfileViewPresenterImplementation(dataService: mockDataManager, view: profileView)
    }
    
    func test_viewDidLoad_success_profile() {
        // When
        profilePresenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(profileView.refreshProfileViewCalled, "refreshProfile was not called")
    }
    
    func test_number_of_table_sections() {
        // When
        profilePresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(3, profilePresenter.numberOfTableSectoins, "Number of books mismatch")
    }
    
    func test_configureCell_pinned_repors() {
        // Given
        let repoOwner = "Isuru"
        let repoName = "pinnedRepo1"
        let repoDescription = "pinnedRep1Des"
        
        let pinnedRepoCell = PinnedRepoCellSpy()
        profilePresenter.viewDidLoad()
        mockDataManager.loadProfile { (profile) in
            // When
            self.profilePresenter.configure(forCell: pinnedRepoCell, forRow: 1, repositoryType: .pinnedRepositories)

            // Then
            XCTAssertEqual(repoOwner, pinnedRepoCell.userNameLable, "The owner name mismatch")
            XCTAssertEqual(repoName, pinnedRepoCell.repositoryNameLable, "The repository name mismatch")
            XCTAssertEqual(repoDescription, pinnedRepoCell.repositoryDescriptionLable, "The repository description mismatch")
        }
    }
    
    func test_number_of_rows_in_cellectoin() {
        let section = 0
        // When
        profilePresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(2, profilePresenter.numberOfRowsInSection(section: section), "Number of repositories in section mismatch")
    }
    
    func test_repository_type_for_section() {
        let section = 0
        // When
        profilePresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(.pinnedRepositories, profilePresenter.sectionRepositoryTypefor(section: section), "Number of repositories in section mismatch")
    }
    
    func test_number_of_repositories_for_type() {
        let type = eRepositoryType.starreedRepositories
        // When
        profilePresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(2, profilePresenter.numberOfRepositoriesForType(repositoryType: type), "Number of repositories for section mismatch")
    }
}
