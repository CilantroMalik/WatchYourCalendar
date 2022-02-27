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
    var datecomp : DateComponents
//    var even : blockEvent
    
//    func maxEvents() -> Bool{ //has reached max events (3)
//        return numEvents[block][datecomp]! > 2 ? true : false
//    }
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
            if (eventsList[datecomp.month! - 1][datecomp.day!])?.count == 0 {
                Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
            }else {
                ForEach(eventsList[datecomp.month! - 1][datecomp.day!]!, id: \.id) { item in
                    NavigationLink(destination: {EventView(ev: item)}, label: {Text(item.hasLabel ? item.label : item.label + item.meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
                }
//                for i in eventsList[datecomp.month - 1][datecomp.day]{
//                    NavigationLink(destination: {EventView(ev: i)}, label: {Text(i.hasLabel ? i.label : i.label + i.meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
//                }
//                //FOR TESTING
//                    NavigationLink(destination: {EventView(ev: (eventsList[datecomp.month - 1][datecomp.day])[0])}, label: {Text((eventsList[datecomp.month - 1][datecomp.day])[0].hasLabel ? (eventsList[datecomp.month - 1][datecomp.day])[0].label : (eventsList[datecomp.month - 1][datecomp.day])[0].label + (eventsList[datecomp.month - 1][datecomp.day])[0].meetingOrAssessment()).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
            }
            Divider().padding(.vertical, 5)
//            if maxEvents(){
//                Text("Max Events been reached for this block.").fontWeight(.heavy).multilineTextAlignment(.center) //is this too wordy?
//            } else
            if globalOffset < 0 || (globalOffset == 0 && nowIsAfterBlockEnds(block: (block))){
                Text("You cannot schedule events in the past.").fontWeight(.medium).multilineTextAlignment(.center)
            } else {
                    Button(action: {
                        let temp = blockEvent(block, datecomp, makeId(block: block, time: datecomp, num: eventsList[datecomp.month! - 1][datecomp.day!]!.count + 1), "New Event", true, false)
                        (eventsList[datecomp.month! - 1][datecomp.day!])!.append(temp)
                    }, label: {Text("Add Event").fontWeight(.heavy).multilineTextAlignment(.center)})
            }
        }
    }
}
    }

struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        //MidView(day: 4, block: 1, datecomp: DateComponents(calendar: Calendar.current), even: blockEvent(0, DateComponents(calendar: Calendar.current), "000000", "Nall", true, false))
        Text("e")
    }
}

