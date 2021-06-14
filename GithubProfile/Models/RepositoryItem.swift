import Foundation

struct RepositoryItem: Comparable, Codable {
    static func < (lhs: RepositoryItem, rhs: RepositoryItem) -> Bool {
        return true
    }
    
    let ownerName: String
    let ownerImage: String
    let repoName: String
    let reposDesc: String
    let starCount: String
    let language: String
    let languageColor: String
}
