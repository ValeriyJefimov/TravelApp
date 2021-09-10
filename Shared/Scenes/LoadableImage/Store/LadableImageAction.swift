//
//  LoadableImageAction.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import ComposableArchitecture
import SwiftUI

enum LoadableImageAction: Equatable {
    case startLoading
    case loading
    case loaded(Result<Image, GlobalError>)
}


