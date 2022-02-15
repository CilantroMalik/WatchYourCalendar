//
//  MidView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/6/22.
//

import SwiftUI


struct MidView: View {
    var day : Int
    var block : Int
    func isBusy(bl: Int) -> Bool{
//        return numEvents[day]![block] > 0 ? true : false
        return false
    }
    func maxEvents() -> Bool{ //has reached max events (3)
        return numEvents[day]![block] > 2 ? true : false
    }
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
    func meetingOrAssessment() -> String{
        let date = Date()
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date)
        switch block {
        case 0:
            return classes[day]![0].starts(with: "Free") ? "Meeting" : "Assessment"
        case 1:
            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
        case 2:
            return classes[day]![1].starts(with: "Free") ? "Meeting" : "Assessment"
        case 3:
            return classes[day]![2].starts(with: "Free") ? "Meeting" : "Assessment"
        case 4:
            return "Meeting"
        case 5:
            return classes[day]![3].starts(with: "Free") ? "Meeting" : "Assessment"
        case 6:
            return classes[day]![4].starts(with: "Free") ? "Meeting" : "Assessment"
        default:
            return "e"
        }
    }
    var body: some View {
        ScrollView{
        VStack {
//            Text("Events").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Text(getOffsetDate())
            Text("Day \(day), \(getPeriod(blockNum: block))")
            
            Divider().padding(.vertical, 5)
            if numEvents[day]![block] == 0 {
                Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            } else if numEvents[day]![block] > 0 {
                NavigationLink(destination: {EventView(day: cycleDay, block: block, num: 1)}, label: {Text("Event 1: " + meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())}
            if numEvents[day]![block] > 1 {
                NavigationLink(destination: {EventView(day: cycleDay, block: block, num: 2)}, label: {Text("Event 2: " + meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())}
            if numEvents[day]![block] > 2 {
                NavigationLink(destination: {EventView(day: cycleDay, block: block, num: 3)}, label: {Text("Event 3: " + meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())}
            
            Divider().padding(.vertical, 5)
            if maxEvents(){
                Text("Max Events been reached for this block.").fontWeight(.heavy).multilineTextAlignment(.center) //is this too wordy?
            } else if globalOffset < 0 || (globalOffset == 0 && nowIsAfterBlockEnds(block: (block))){
                Text("You cannot schedule events in the past.").fontWeight(.medium).multilineTextAlignment(.center)
            } else {
                NavigationLink(destination: SchedulingView(day: cycleDay, block: block)){
                    Text("Add Event").fontWeight(.heavy).multilineTextAlignment(.center)
            }
        }
    }
}
    }

struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        MidView(day: 4, block: 1)
    }
}
}
