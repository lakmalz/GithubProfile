import Foundation
@testable import GithubProfile


class PinnedRepoCellSpy: RepositoryView{
    
    var userNameLable = ""
    var repositoryNameLable = ""
    var repositoryDescriptionLable = ""
    var starCountLabel = ""
    var languageLabel = ""
    var languageColorCode = ""
    var imageUrl = ""
    
    
    func display(userName: String) {
        userNameLable = userName
    }
    
    func display(repositoryName: String) {
        repositoryNameLable = repositoryName
    }
    
    func display(repositoryDescription: String) {
        repositoryDescriptionLable = repositoryDescription
    }
    
    func display(starCount: String) {
        starCountLabel = starCount
    }
    
    func display(language: String) {
        languageLabel = language
    }
    
    func display(languageColor: String) {
        languageColorCode = languageColor
    }
    
    func display(profileUrl: String) {
        imageUrl = profileUrl
    }
}
