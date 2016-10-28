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

struct StrengthMatches : OptionSet {
    let rawValue: Int
    
    static let length  = StrengthMatches(rawValue: 1 << 0)
    static let symbol = StrengthMatches(rawValue: 1 << 1)
    static let uppercase  = StrengthMatches(rawValue: 1 << 2)
    static let number  = StrengthMatches(rawValue: 1 << 3)
}

// Book: Swift 3 Funtional Programming



func checkPasswordWithBuilder(_ password:String) {
    
    let minimumLenght = 12
    let passwordAnalysis = PasswordCheckerBuilder(password, initialStrength: .Feeble, initialStrengthMatch: []).isPasswordLongEnough(limit: minimumLenght).containsSymbol().containsUppercase().containsNumber().build()
    
    print("The strenght of your password '\(password)' is: \(passwordAnalysis.strength)")
    
    if passwordAnalysis.strength == .Robust {
        print("CONGRATS!! 🎉🎉🎉")
    } else {
        print("To have a secure password please improve the following:")
        
        if !passwordAnalysis.matches.contains(.length) {
            print("   + Make your password \(minimumLenght) characters long.")
        }
        if !passwordAnalysis.matches.contains(.symbol) {
            print("   + Make your password contains at least 1 symbol.")
        }
        if !passwordAnalysis.matches.contains(.uppercase) {
            print("   + Make your password contains at least 1 uppercase letter.")
        }
        if !passwordAnalysis.matches.contains(.number) {
            print("   + Make your password contains at least 1 symbol.")
        }
    }
}

class PasswordCheckerBuilder
{
    let password: String
    
    var strength : Strength = .Feeble;
    var strengthMatch: StrengthMatches = []
    
    init(_ proposedPassword: String, initialStrength: Strength, initialStrengthMatch: StrengthMatches) {
        password = proposedPassword
        strength = initialStrength
        strengthMatch = initialStrengthMatch
    }
    
    func isPasswordLongEnough(limit: Int) -> PasswordCheckerBuilder {
        if password.characters.count >= limit {
            strengthMatch.insert(.length)
            strength = Strength(rawValue: strength.rawValue + 1)!
        }
        return self
    }
    
    func containsSymbol() -> PasswordCheckerBuilder {
        let alphanumerics = CharacterSet.alphanumerics
        
        if password.rangeOfCharacter(from: alphanumerics.inverted) != nil {
            strengthMatch.insert(.symbol)
            strength = Strength(rawValue: strength.rawValue + 1)!
        }
        return self
    }
    
    func containsUppercase() -> PasswordCheckerBuilder {
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
            strengthMatch.insert(.uppercase)
            strength = Strength(rawValue: strength.rawValue + 1)!
        }
        return self
    }
    
    func containsNumber() -> PasswordCheckerBuilder {
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            strengthMatch.insert(.number)
            strength = Strength(rawValue: strength.rawValue + 1)!
        }
        return self
    }
    
    func build() -> (strength : Strength, matches : StrengthMatches) {
        return(strength, strengthMatch)
    }
}


checkPasswordWithBuilder("test1")


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


let minimumLenght = 12;


func checkPassword(_ password:String) {
    let passwordAnalysis = checkPasswordStrengthAndMatches(proposed: password)
    
    print("The strenght of your password '\(password)' is: \(passwordAnalysis.strength)")
    
    if passwordAnalysis.strength == .Robust {
        print("CONGRATS!! 🎉🎉🎉")
    } else {
        print("To have a secure password please improve the following:")
        
        if !passwordAnalysis.matches.contains(.length) {
            print("   + Make your password \(minimumLenght) characters long.")
        }
        if !passwordAnalysis.matches.contains(.symbol) {
            print("   + Make your password contains at least 1 symbol.")
        }
        if !passwordAnalysis.matches.contains(.uppercase) {
            print("   + Make your password contains at least 1 uppercase letter.")
        }
        if !passwordAnalysis.matches.contains(.number) {
            print("   + Make your password contains at least 1 symbol.")
        }
    }
}

func checkPasswordStrengthAndMatches(proposed: String) -> (strength : Strength, matches : StrengthMatches) {
    
    var strength : Strength = .Feeble;
    var strengthMatch: StrengthMatches = []

    
    if isPasswordLongEnough(proposed, limit: minimumLenght) {
        strengthMatch.insert(.length)
        strength = Strength(rawValue: strength.rawValue + 1)! // Re-assigning as rawValue is unmutable
    }
    
    if containsSymbol(proposed) {
        strengthMatch.insert(.symbol)
        strength = Strength(rawValue: strength.rawValue + 1)!
    }
    
    if contains(CharacterSet.uppercaseLetters, password: proposed) {
        strengthMatch.insert(.uppercase)
        strength = Strength(rawValue: strength.rawValue + 1)!
    }
    
    if contains(CharacterSet.decimalDigits, password: proposed) {
        strengthMatch.insert(.number)
        strength = Strength(rawValue: strength.rawValue + 1)!
    }
    
    return (strength, strengthMatch)
}

// MARK: Password property checkers

func isPasswordLongEnough(_ password: String, limit: Int) -> Bool {
    return password.characters.count >= limit
}

func containsSymbol(_ password: String) -> Bool {
    let alphanumerics = CharacterSet.alphanumerics
    
    return password.rangeOfCharacter(from: alphanumerics.inverted) != nil
}

func contains(_  characterSet: CharacterSet, password: String) -> Bool {
    return password.rangeOfCharacter(from: characterSet) != nil
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// TESTING /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// MARK: Test isPasswordLongEnough
XCTAssertTrue(isPasswordLongEnough("1234", limit: 2))
XCTAssertFalse(isPasswordLongEnough("1234", limit: 5))
XCTAssertFalse(isPasswordLongEnough("", limit: 5))
XCTAssertTrue(isPasswordLongEnough("1234", limit: 4))
XCTAssertTrue(isPasswordLongEnough("😬😬", limit: 1))
XCTAssertFalse(isPasswordLongEnough("😬😬", limit: 3))

// MARK: Test containsSymbol
XCTAssertFalse(containsSymbol("hola"))
XCTAssertFalse(containsSymbol("123"))
XCTAssertTrue(containsSymbol("£"))
XCTAssertTrue(containsSymbol("@"))
XCTAssertTrue(containsSymbol(" "))
XCTAssertTrue(containsSymbol("hola@hotmail.com"))
XCTAssertTrue(containsSymbol("hola🖐🙃"))

// MARK: Test contains
//Uppercase
XCTAssertFalse(contains(CharacterSet.uppercaseLetters, password: "hola"))
XCTAssertFalse(contains(CharacterSet.uppercaseLetters, password: "123"))
XCTAssertFalse(contains(CharacterSet.uppercaseLetters, password: "™️"))
XCTAssertFalse(contains(CharacterSet.uppercaseLetters, password: " "))
XCTAssertFalse(contains(CharacterSet.uppercaseLetters, password: "$"))
XCTAssertTrue(contains(CharacterSet.uppercaseLetters, password: "H"))
XCTAssertTrue(contains(CharacterSet.uppercaseLetters, password: "wooooOoooo"))
// Numbers
XCTAssertFalse(contains(CharacterSet.decimalDigits, password: "hola"))
XCTAssertFalse(contains(CharacterSet.decimalDigits, password: "™️"))
XCTAssertFalse(contains(CharacterSet.decimalDigits, password: " "))
XCTAssertFalse(contains(CharacterSet.decimalDigits, password: "$"))
XCTAssertTrue(contains(CharacterSet.decimalDigits, password: "123"))
XCTAssertTrue(contains(CharacterSet.decimalDigits, password: "0.1"))
XCTAssertTrue(contains(CharacterSet.decimalDigits, password: "woooo2oooo"))


XCTAssertEqual(Strength.Feeble, checkPasswordStrengthAndMatches(proposed: "password").strength)
XCTAssertEqual(Strength.Weak, checkPasswordStrengthAndMatches(proposed: "Password").strength)
XCTAssertEqual(Strength.Average, checkPasswordStrengthAndMatches(proposed: "1q2w3!").strength)
XCTAssertEqual(Strength.Strong, checkPasswordStrengthAndMatches(proposed: "Password1#").strength)
XCTAssertEqual(Strength.Robust, checkPasswordStrengthAndMatches(proposed: "Vf(rB!K&Kh^9sU{U").strength)

XCTAssertEqual(StrengthMatches.uppercase, checkPasswordStrengthAndMatches(proposed: "Password").matches)
XCTAssertEqual(StrengthMatches.number.union(StrengthMatches.symbol), checkPasswordStrengthAndMatches(proposed: "1q2w3!").matches)
XCTAssertEqual(StrengthMatches.uppercase.union(StrengthMatches.symbol.union(StrengthMatches.number)), checkPasswordStrengthAndMatches(proposed: "Password1#").matches)
XCTAssertNotEqual(StrengthMatches.length, checkPasswordStrengthAndMatches(proposed: "Vf(rB!K&Kh^9sU{U").matches)


///
//checkPassword("test1")
///
