//
//  Cookie.swift
//  CookieCrunch
//
//  Created by Siess, Clement on 9/24/15.
//  Copyright © 2015 Siess, Clement. All rights reserved.
//

import SpriteKit

enum CookieType: Int, CustomStringConvertible {
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie
    
    var spriteName: String {
        let spriteNames = ["Croissant", "Cupcake", "Danish", "Donut", "Macaroon", "SugarCookie"]
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> CookieType {
        return CookieType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}

class Cookie: NSObject{
    var column: Int
    var row: Int
    let cookieType: CookieType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: CookieType) {
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    
    override var description: String {
        return "type: \(cookieType) square: (\(column), \(row))"
    }
    
    override var hashValue: Int {
        return row * 10 + column
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let lhs = object as? Cookie{
            return column == lhs.column && row == lhs.row
        }
        return false
    }
}
