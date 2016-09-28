//: Lets check the strength of passwords
// open to any set of rules (that is part of the fun)
// but i looked at this http://www.passwordmeter.com/
// helpful too -> http://passwordsgenerator.net/

import Cocoa
import XCTest

enum Strength: String {
    case Feeble
    case Weak
    case Average
    case Strong
    case Robust
}

func checkPassword(proposed: String) -> Strength {
    return Strength.Average
}

XCTAssertEqual(Strength.Average, checkPassword(proposed: "1q2w3"))
//XCTAssertEqual(Strength.Feeble, checkPassword(proposed: "password"))
//XCTAssertEqual(Strength.Robust, checkPassword(proposed: "Vf(rB!K&Kh^9sU{U"))