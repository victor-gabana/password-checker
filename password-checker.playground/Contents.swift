//: Lets check the strength of passwords
// open to any set of rules (that is part of the fun)
// but i looked at this http://www.passwordmeter.com/
// helpful too -> http://passwordsgenerator.net/

import Cocoa
import XCTest

enum Strength: Int {
    case Feeble = 0
    case Weak
    case Average
    case Strong
    case Robust
}

func checkPassword(proposed: String) -> Strength {
    
    return PasswordStrengthBuilder(proposed).isLongEnough(limit: 12).build()
}

class PasswordStrengthBuilder{
    
    let strength: Strength
    let password: String

    init(_ _password:String, strength _strength: Strength = Strength.Feeble) {
        password = _password
        strength = _strength
    }
    
    func isLongEnough(limit: Int) -> PasswordStrengthBuilder {
        
        if password.characters.count >= limit {
            return PasswordStrengthBuilder(password, strength: Strength(rawValue: strength.rawValue + 1)!) //hate!!
        } else {
            return PasswordStrengthBuilder(password, strength: strength)
        }
    }
    
    func build() -> Strength {
       return strength
    }
}

// initial state of builder should be feeble
let psb = PasswordStrengthBuilder("")
XCTAssertEqual(Strength.Feeble, psb.build())

// can set my builder up
let robustPSB = PasswordStrengthBuilder("", strength: .Robust)
XCTAssertEqual(Strength.Robust, robustPSB.build())

XCTAssertGreaterThan(checkPassword(proposed: "1q2w3"), Strength.Feeble)
//XCTAssertEqual(Strength.Feeble, checkPassword(proposed: "password"))
//XCTAssertEqual(Strength.Robust, checkPassword(proposed: "Vf(rB!K&Kh^9sU{U"))
