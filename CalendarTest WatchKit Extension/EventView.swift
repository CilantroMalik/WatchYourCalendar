//
//  EventView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/15/22.
//

import SwiftUI

struct EventView: View {
    func getPeriod(blockNum: Int) -> String {
        switch blockNum {
        case 0:
            return blocks[day]![0] + " Block"
        case 1:
            return "Break/Clubs"
        case 2:
            return blocks[day]![1] + " Block"
        case 3:
            return blocks[day]![2] + " Block"
        case 4:
            return "Lunch"
        case 5:
            return blocks[day]![3] + " Block"
        case 6:
            return blocks[day]![4] + " Block"
        default:
            return "e"
        }
    }
    var day : Int
    var block : Int
    var num : Int
    var body: some View {
        Text("Edit Event").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
        Text(getOffsetDate())
        Text("Day \(day), \(getPeriod(blockNum: block))")
        Divider().padding(.vertical, 5)
            
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(day: 4, block: 1,num: 2)
    }
}
