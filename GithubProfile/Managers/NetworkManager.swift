import Foundation
import Apollo


class NetworkManager {
    let GIT_URL = "https://api.github.com/graphql"
    let ACCESS_TOKEN = "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"
    
    static let instance = NetworkManager()
    
    private(set) lazy var client: ApolloClient = {
          let cache = InMemoryNormalizedCache()
          let store = ApolloStore(cache: cache)
          let client = URLSessionClient()
          let provider = NetworkInterceptorProvider(store: store, client: client)
          let url = URL(string: GIT_URL)!
          let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,endpointURL: url, additionalHeaders: ["Authorization": "Bearer \(ACCESS_TOKEN)"])
          return ApolloClient(networkTransport: requestChainTransport,
                              store: store)
      }()
    }

struct NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: self.store),
            RequestLoggingInterceptor(),
            NetworkFetchInterceptor(client: self.client),
            ResponseLoggingInterceptor(),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: self.store)
        ]
    }
}
