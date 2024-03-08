//
//  Constants.swift
//  Pet adoption
//
//  Created by Srilakshmi on 3/8/24.
//

import UIKit


enum UserType:String {
  case Admin = "Admin"
  case User = "User"
  case Professor = "Professor"
}

let subjects: [String: String] = [
   "101": "Mathematics",
   "102": "Physics",
   "103": "Chemistry",
   "104": "Biology",
   "105": "Computer Science",
   "106": "Engineering",
   "107": "History",
   "108": "Literature",
   "109": "Art",
   "110": "Music",
   "111": "Psychology",
   "112": "Economics",
   "113": "Political Science",
   "114": "Philosophy",
   "115": "Sociology"
]



func getCourses()->[String: String] {
   return subjects
}


struct ColorsConfig {
   static let selectedText = UIColor.white
   static let text = UIColor.black
   static let textDisabled = UIColor.gray
   static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
   static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
   static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
   static let sundaySelectionBackground = sundayText
}



