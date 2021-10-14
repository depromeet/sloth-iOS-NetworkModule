//
//  ViewController.swift
//  SampleApp
//
//  Created by 임승혁 on 2021/09/21.
//

import UIKit
import Combine
import SlothNetworkModule

class ViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UseCase().retrieve()
            .sink { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .finished:
                    print("finished")
                }
            } receiveValue: { dummy in
                print(dummy)
            }.store(in: &cancellables)
    }
}


public enum UseCaseError: Error {
    
    case decodeError
    case networkError(error: NetworkError)
    case unknownError(error: Error)
}

public class UseCase {
    
    private let networkManager = NetworkManager(session: .shared)
    
    public init() {
        
    }
    
    public func retrieve() -> AnyPublisher<Dummy, UseCaseError> {
        return networkManager.dataTaskPublisher(for: "http://13.124.140.7/api/health", httpMethod: .get, httpHeaders: nil)
            .decode(type: Dummy.self, decoder: JSONDecoder())
            .mapError { error -> UseCaseError in
                if error is DecodingError {
                    return .decodeError
                } else if let error = error as? NetworkError {
                    return .networkError(error: error)
                } else {
                    return .unknownError(error: error)
                }
            }.eraseToAnyPublisher()
    }
}

public struct Dummy: Codable {
    
    let health: String
    let status: Bool
}
