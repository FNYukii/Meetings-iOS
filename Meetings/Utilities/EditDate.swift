//
//  EditDate.swift
//  Meetings
//
//  Created by Yu on 2022/07/24.
//

import Foundation
import SwiftUI

class EditDate {
    
    static func howManyAgoText(from: Date) -> Text {
        let inputDate = from
        
        let secondDiff: Int = (Calendar.current.dateComponents([.second], from: inputDate, to: Date())).second!
        if secondDiff < 1 {
            return Text("now")
        }
        if secondDiff < 60 {
            return Text("\(secondDiff)s")
        }
        
        let minuteDiff = (Calendar.current.dateComponents([.minute], from: inputDate, to: Date())).minute!
        if minuteDiff < 60 {
            return Text("\(minuteDiff)m")
        }
        
        let hourDiff = (Calendar.current.dateComponents([.hour], from: inputDate, to: Date())).hour!
        if hourDiff < 24 {
            return Text("\(hourDiff)h")
        }
        
        let dayDiff = (Calendar.current.dateComponents([.day], from: inputDate, to: Date())).day!
        if dayDiff < 31 {
            return Text("\(dayDiff)d")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY MMMM d")
        return Text(dateFormatter.string(from: from))
    }
    
    static func toString(from: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: from)
    }
    
}
