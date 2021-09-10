//
//  NetworkRepository.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/19/21.
//

import Dispatch
import Combine
import ComposableArchitecture
import Alamofire

struct NetworkRepository {
    
    typealias RunRequest<Value: Decodable> = (Value) -> Effect<Value, NetworkError>

    //MARK: - Private
    fileprivate let baseUrl: String
    fileprivate let session: Session
    fileprivate let queue: DispatchQueue
    
    //MARK: - Public
    
    public init(session: Session = Session.default, baseUrl: String, queue: DispatchQueue) {
        self.session = session
        self.baseUrl = baseUrl
        self.queue = queue
    }
    
    func run<Value: Decodable>(_ request: NetworkRequest) -> Effect<Value, NetworkError> {
        return runRequest(request, queue: self.queue)
            .eraseToEffect()
    }
}

fileprivate extension NetworkRepository {
    func runRequest<Value: Decodable>(
        _ request: NetworkRequest,
        queue: DispatchQueue
    ) -> AnyPublisher<Value, NetworkError> {
        guard let urlRequest = try? request.urlRequest(relativeTo: baseUrl) else {
            return Fail(error: NetworkError.parsingError)
                .eraseToAnyPublisher()
        }
        return session
            .request(urlRequest)
            .cURLDescription(calling: { print("Called: \($0)")})
            .publishDecodable(type: Value.self, queue: queue)
            .tryCompactMap { (response) -> Value? in
                if let error = response.error { throw error }
                return response.value
            }
            .mapError { error in
                print(error)
                return NetworkError.parsingError }
            .eraseToAnyPublisher()
    }
}

extension NetworkRepository {
    public static let live = NetworkRepository(baseUrl: "https://api.foursquare.com/v2", queue: .main)
}

