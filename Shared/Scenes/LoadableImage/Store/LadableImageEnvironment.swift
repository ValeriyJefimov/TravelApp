//
//  LoadableImageEnvironment.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import SwiftUI
import Combine

struct LoadableImageEnvironment {
    let loader: (URL?) -> AnyPublisher<Image, GlobalError>
}

extension LoadableImageEnvironment {
    static var live = LoadableImageEnvironment { url in
        guard let url = url else {
            return Fail(error: GlobalError.parsingError)
                .eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .compactMap { UIImage(data: $0.data) }
            .map { Image(uiImage: $0)  }
            .mapError { _ in GlobalError.parsingError }
            .eraseToAnyPublisher()
    }
}
