//
//  LoadableImageState.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import ComposableArchitecture
import SwiftUI

struct LoadableImageState: Equatable {
    var url: URL?
    var isLoading: Bool = false
    var result: Result<Image, GlobalError>?
}


