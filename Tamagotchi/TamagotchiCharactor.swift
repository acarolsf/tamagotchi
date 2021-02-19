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
    
    init(age: Int, stomachMeter: Int, socialMeter: Int) {
        self.age = age
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
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
}

class Tamagotchi: ObservableObject {
    let name: String
    let gender: Gender
    @Published var age: Int
    
    @Published var stomachMeter: Int
    @Published var socialMeter: Int
    
    let imageName: String
    
    init(name: String, gender: Gender, age: Int, stomachMeter: Int, socialMeter: Int, imageName: String) {
        self.name = name
        self.gender = gender
        self.age = age
        
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
        
        self.imageName = imageName
    }
    
    convenience init(name: String, gender: Gender, age: Int, imageName: String) {
        self.init(name: name, gender: gender, age: age, stomachMeter: BAROMETER_MAX, socialMeter: BAROMETER_MAX, imageName: imageName)
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
    
    func fullStomachMeter() {
        self.stomachMeter = BAROMETER_MAX
    }
    
    func fullSocialMeter() {
        self.socialMeter = BAROMETER_MAX
    }
}
