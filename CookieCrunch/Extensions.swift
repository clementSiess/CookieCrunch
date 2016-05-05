//
//  Extensions.swift
//  CookieCrunch
//
//  Created by Mac on 9/30/15.
//  Copyright © 2015 Siess, Clement. All rights reserved.
//

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            

            let data = try? NSData(contentsOfFile: path, options: NSDataReadingOptions())
            if let data = data {
                
                let dictionary: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions())
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return dictionary
                } else {
                    print("Level file '\(filename)' is not valid JSON: (This is not Valid JSON)")
                    return nil
                }
            } else {
                print("Could not load level file: \(filename), error: (This is not Valid JSON)")
                return nil
            }
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
}