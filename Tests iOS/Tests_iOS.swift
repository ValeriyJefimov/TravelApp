//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import XCTest

class Tests_iOS: XCTestCase {
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
