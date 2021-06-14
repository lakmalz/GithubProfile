import Foundation

public struct Profile: Codable{
    var name: String
    var email: String
    var followers: Int
    var following: Int
    var imageUrl: String
    var loginName: String
    
    var pinnedRepositories: [RepositoryItem]?
    var topRepositories: [RepositoryItem]?
    var starredRepositories: [RepositoryItem]?
}
