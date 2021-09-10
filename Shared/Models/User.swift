//
//  User.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import Foundation
import UIKit.UIImage

struct User: Equatable {
    let name: String
    let pass: String
    let email: String
    var profileImage: UIImage?
}
