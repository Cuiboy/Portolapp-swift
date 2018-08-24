//
//  my_unquotedJSONFormatter.swift
//  PHS App
//
//  Created by Patrick Cui on 7/28/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func my_unquotedJSONFormatter(string: String, rows: Int) -> String {
        
        var finalString = ""
        var isComma = false
        let firstArray = string.components(separatedBy: ", ")
    
      
            if firstArray.count != rows {
                print("error: \(firstArray)")
                return "error"
                
            }
      
       
        var secondArray = [String]()
        for item in firstArray {
            let individual = item.components(separatedBy: ": ")
            for key in individual {
                secondArray.append(key)
            }
        }
        
        if secondArray.count != rows * 2 {
            print("error: \(secondArray)")
            return "error"
        } else {
            finalString += "{ "
            for i in 0...secondArray.count - 2 {
                if isComma {
                    finalString += "\"\(secondArray[i])\", "
                } else {
                    finalString += "\"\(secondArray[i])\": "
                }
                isComma = !isComma
            }
            
            finalString += "\"\(secondArray[secondArray.count - 1])\" }"
        }
        
        
//         finalString = "{ \"\(secondArray[0])\": \"\(secondArray[1])\", \"\(secondArray[2])\": \"\(secondArray[3])\", \"\(secondArray[4])\": \"\(secondArray[5])\", \"\(secondArray[6])\": \"\(secondArray[7])\" }"
        
     

        return finalString
        
    }
    
    
    static func createFormattedJSON() -> String? {
        let string = String()
        let rows = Int()
        let finalString = string.my_unquotedJSONFormatter(string: string, rows: rows)
        return finalString
        
    }

}

