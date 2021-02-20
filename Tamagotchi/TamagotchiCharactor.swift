//
//  TamagotchiCharactor.swift
//  Tamagotchi
//
//  Created by Ana Carolina on 19/02/21.
//

import Foundation

// Gender
enum Gender: String {
    case male = "♂"
    case female = "♀"
}

// Barometer
public let BAROMETER_MAX = 5

struct TamagotchiBarometer: Codable {
    
    var age: Int
    var stomachMeter: Int
    var socialMeter: Int
    var happyMeter: Int
    
    init(age: Int, stomachMeter: Int, socialMeter: Int, happyMeter: Int) {
        self.age = age
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
        self.happyMeter = happyMeter
    }
    
    // increasing age
    
    mutating func increaseAge() -> Int {
        self.age += 1
        return self.age
    }

    
    // reducing stomach
    
    mutating func reduceStomachMeter() -> Int {
        if self.stomachMeter - 1 != 0 {
            self.stomachMeter -= 1
        }
        
        return self.stomachMeter
    }
    
    // reducing social
    
    mutating func reduceSocialMeter() -> Int {
        if self.socialMeter - 1 != 0 {
            self.socialMeter -= 1
        }
        
        return self.socialMeter
    }
    
    // reducing happiness
    
    mutating func reduceHappyMeter() -> Int {
        if self.happyMeter - 1 != 0 {
            self.happyMeter -= 1
        }
        
        return self.happyMeter
    }
    
    // full stomach
    
    mutating func fullStomachMeter() -> Int {
        self.stomachMeter = BAROMETER_MAX
        
        return self.stomachMeter
    }
    
    // full social
    
    mutating func fullSocialMeter() -> Int {
        self.socialMeter = BAROMETER_MAX
        
        return self.socialMeter
    }
    
    // full happy
    
    mutating func fullHappyMeter() -> Int {
        self.happyMeter = BAROMETER_MAX
        
        return self.happyMeter
    }
}

class Tamagotchi: ObservableObject {
    let name: String
    let gender: Gender
    @Published var age: Int
    
    @Published var stomachMeter: Int
    @Published var socialMeter: Int
    @Published var happyMeter: Int
    
    let imageName: String
    
    init(name: String, gender: Gender, age: Int, stomachMeter: Int, socialMeter: Int, happyMeter: Int, imageName: String) {
        self.name = name
        self.gender = gender
        self.age = age
        
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
        self.happyMeter = happyMeter
        
        self.imageName = imageName
    }
    
    convenience init(name: String, gender: Gender, age: Int, imageName: String) {
        self.init(name: name, gender: gender, age: age, stomachMeter: BAROMETER_MAX, socialMeter: BAROMETER_MAX, happyMeter: BAROMETER_MAX, imageName: imageName)
    }
    
    func increaseAge() {
        self.age += 1
    }
    
    func reduceStomachMeter() {
        if self.stomachMeter - 1 != 0 {
            self.stomachMeter -= 1
        }
    }
    
    func reduceSocialMeter() {
        if self.socialMeter - 1 != 0 {
            self.socialMeter -= 1
        }
    }
    
    func reduceHappyMeter() {
        if self.happyMeter - 1 != 0 {
            self.happyMeter -= 1
        }
    }
    
    func fullStomachMeter() {
        self.stomachMeter = BAROMETER_MAX
    }
    
    func fullSocialMeter() {
        self.socialMeter = BAROMETER_MAX
    }
    
    func fullHappyMeter() {
        self.happyMeter = BAROMETER_MAX
    }
    
    func checkAge () -> String {
        switch self.age {
        case 0:
            return "Bebê"
        case 1:
            return "Criança"
        case 2:
            return "Adolescente"
        case 3:
            return "Adulto"
        case 4:
            return "Idoso"
        default:
            return ""
        }
    }
}
