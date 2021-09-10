//
//  VoidResult.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import Foundation

@frozen enum VoidResult<Failure> where Failure: Error {
  case success
  case failure(Failure)
  
  func mapError<NewFailure>(_ transform: (Failure) -> NewFailure) -> VoidResult<NewFailure> where NewFailure: Error {
    switch self {
    case .success:
      return .success
    case .failure(let error):
      return .failure(transform(error))
    }
  }
}

extension VoidResult: Equatable where Failure: Equatable {
  static func == (lhs: VoidResult<Failure>, rhs: VoidResult<Failure>) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success):
      return true
    case (.failure(let lhError), .failure(let rhError)):
      return lhError == rhError
    default:
      return false
    }
  }
}

import Combine
import ComposableArchitecture

extension Publisher where Output == Void {
  func catchToVoidEffect() -> ComposableArchitecture.Effect<VoidResult<Failure>, Never> {
    return map { _ in VoidResult<Failure>.success }
      .catch { Just(.failure($0)) }
      .eraseToEffect()
  }
}

