import Foundation
import Cache

class CacheManager {
    
    final var _cacheDuration: Double = 60*60*24
    final var _storageKey = "profile"
    
    public static var instance = CacheManager()
    var _storage: Storage<String, Profile>?

    init() {
        let diskConfig = DiskConfig(name: "GithubProfile", expiry: .seconds(_cacheDuration))
        let memoryConfig = MemoryConfig(expiry: .seconds(_cacheDuration), countLimit: 10, totalCostLimit: 10)
        
        _storage = try? Storage<String, Profile>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: Profile.self)
        )
    }
    
    func setStoredProfile(value: Profile){
        do {
            try _storage?.setObject(value, forKey: _storageKey)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func getStoredProfile() -> Profile?{
        do {
            let object = try _storage?.object(forKey: _storageKey)
            return object
        } catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func clearExpiredObjects() -> Bool {
        do {
            try _storage?.removeExpiredObjects()
            return true
        } catch{
            print(error.localizedDescription)
            return false
        }        
    }
    
    func removeAllObjects() -> Bool {
        do {
            try _storage?.removeAll()
            return true
        } catch{
            print(error.localizedDescription)
            return false
        }
    }
}
