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
    func isBusy() -> Bool{
        return numEvents[day]![block] > 0 ? true : false
    }
    func maxEvents() -> Bool{ //has reached max events (3)
        return numEvents[day]![block] > 3 ? true : false
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
            Text("Events:").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            Text(getOffsetDate())
            Text("Day \(day), \(getPeriod(blockNum: block))")
            
            Divider().padding(.vertical, 5)
            if numEvents[day]![block] == 0 {
                Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            } else if numEvents[day]![block] > 0 {
                Text("Event 1: " + meetingOrAssessment())}
            if numEvents[day]![block] > 1 {
                Text("Event 2: " + meetingOrAssessment())}
            if numEvents[day]![block] > 2 {
                Text("Event 3" + meetingOrAssessment())}
            
            Divider().padding(.vertical, 5)
            if !maxEvents(){
            NavigationLink(destination: SchedulingView(day: cycleDay, block: block)){
                Text("Add Event").fontWeight(.heavy)
            }
            } else {
                Text("Max Events been reached for this block.").fontWeight(.heavy) //is this too wordy?
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
