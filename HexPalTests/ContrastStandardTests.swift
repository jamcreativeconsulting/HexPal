//
//  ContrastStandardTests.swift
//  HexPalTests
//
//  Tests ContrastStandard preferred persistence.
//

import XCTest
@testable import HexPal

final class ContrastStandardTests: XCTestCase {

    func test_preferred_unset_returnsWcag22() {
        let key = ContrastStandard.preferredKey
        let original = UserDefaults.standard.string(forKey: key)

        defer {
            if let orig = original {
                UserDefaults.standard.set(orig, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }

        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(ContrastStandard.preferred, .wcag22)
    }

    func test_preferred_roundTripsCorrectly() {
        let key = ContrastStandard.preferredKey
        let original = UserDefaults.standard.string(forKey: key)

        defer {
            if let orig = original {
                UserDefaults.standard.set(orig, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }

        ContrastStandard.preferred = .apca
        XCTAssertEqual(ContrastStandard.preferred, .apca)

        ContrastStandard.preferred = .wcag22
        XCTAssertEqual(ContrastStandard.preferred, .wcag22)
    }
}
