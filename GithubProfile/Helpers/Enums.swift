import Foundation

enum eRepositoryType {
    case pinnedRepositories
    case topRepositories
    case starreedRepositories
    
    var description: String {
        switch self {
        case .pinnedRepositories: return "Pinned"
        case .topRepositories: return "Top repositories"
        case .starreedRepositories: return "Starred repositories"
        }
    }
    
    var tag: Int {
        switch self {
        case .pinnedRepositories: return 0
        case .topRepositories: return 1
        case .starreedRepositories: return 2
        }
    }
}
