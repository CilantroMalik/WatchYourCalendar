//
//  MidView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/6/22.
//

import SwiftUI

class EventEditorManager: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var eventToEdit: blockEvent? = nil
}

struct MidView: View {
    var day : Int
    var block : Int
    var datecomp : DateComponents
    
    @StateObject var evEditManager = EventEditorManager()
    
    @State var eventPick: String
    
    @StateObject var eventsListObs = EventsListObs()
    //    var even : blockEvent
    
    //    func maxEvents() -> Bool{ //has reached max events (3)
    //        return numEvents[block][datecomp]! > 2 ? true : false
    //    }
    
    func getPeriod(blockNum: Int) -> String {
        
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        let weekday = cal.component(.weekday, from: date)
        switch blockNum {
        case 0:
            return blocks[day]![0] + " Block"
        case 1:
            switch weekday {
            case 1:
                return "None"
            case 2:
                return "\n aCommunity Meeting"
            case 3:
                return "Clubs"
            case 4:
                return "Advisory"
            case 5:
                return "Clubs"
            case 6:
                return "Class Meeting"
            case 7:
                return "None"
            default:
                return "error... lul"
            }
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
        case 9:
            return "Break"
        default:
            return "e"
        }
    }
    func meetingOrAssessment() -> String {
        switch block {
        case 0:
            return classes[day]![0].starts(with: "Free") ? "Meeting" : "Assessment"
        case 1:
//            return weekday == 3 || weekday == 5 ? "Meeting" : "Event"
            return "Meeting"
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
        case 9:
            return "Meeting"
        default:
            return "e"
        }
    }
    func getBlockTime(block: Int) -> String{
        switch block {
        case 0:
            return "08:55 - 09:55"
        case 1:
            return "10:00 - 10:30"
        case 2:
            return "10:35 - 11:25"
        case 3:
            return "11:25 - 12:25"
        case 4:
            return "12:25 - 13:15"
        case 5:
            return "13:20 - 14:20"
        case 6:
            return "14:30 - 15:15"
        case 9:
            return "14:20 - 14:30"
        default:
            return "e"
        }
    }
    
    func eventsThisBlock() -> [blockEvent] {
        let dayEvents = EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!
        var blockEvents: [blockEvent] = []
        for event in dayEvents {
            if event.block == block { blockEvents.append(event) }
        }
        return blockEvents
    }
    
    func isToday() -> Bool {
        let now = Date.init(timeIntervalSinceNow: 0)
        let month = Calendar.current.component(.month, from: now)
        let day = Calendar.current.component(.day, from: now)
        
        return datecomp.month! == month && datecomp.day! == day
    }
    
    var body: some View {
        ScrollView{
            VStack {
                //            Text("Events").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
                Text(getOffsetDate())
                Text("Day \(day), \(getPeriod(blockNum: block))")
                Text(getBlockTime(block: block))
                
                Divider().padding(.vertical, 5)
                if (eventsThisBlock()).count == 0 {
                    Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
                } else {
                    ForEach(eventsThisBlock(), id: \.id) { item in
                        //NavigationLink(destination: {EventView(ev: item)}, label: {Text(item.label).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
                        Button(action: { evEditManager.eventToEdit = item; evEditManager.isEditing.toggle() }, label: { Text(item.label) })
                    }
                }
                Divider().padding(.vertical, 5)
                if globalOffset < 0 || (globalOffset == 0 && nowIsAfterBlockEnds(block: (block))) || (nowIsBeforeThird(block: block, third: 4)){
                    Text("You cannot schedule events in the past.").fontWeight(.medium).multilineTextAlignment(.center)
                } else {
                    Button(action: {
                        let n = EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!.filter({$0.label.contains(eventPick)}).count + 1
                        let temp = blockEvent(block, datecomp, makeId(block: block, time: datecomp, num: EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!.count+1), isMeetingOrAssessment(block, datecomp) == "Meeting" ? "\(eventPick) of block \(n)" : "\(eventPick) \(n)", true, false)
                        eventsListObs.addEvent(ev: temp, month: datecomp.month!-1, day: datecomp.day!)
                        eventPick = isMeetingOrAssessment(block, datecomp) == "Meeting" ? "entirety" : "Test"
                    }, label: {
                        Text("Add Event").fontWeight(.heavy).multilineTextAlignment(.center)
                    })
                    Picker(isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Select Part of Block" : "Select Assessment Type", selection: $eventPick, content: {
                        if isMeetingOrAssessment(block, datecomp) == "Meeting" {
                            if isToday() {
                                if nowIsBeforeBlockBegins(block: (block)) {Text("entirety").tag("entirety")}
                                if nowIsBeforeThird(block: block, third: 1) {Text("1st third").tag("1st third")}
                                if nowIsBeforeThird(block: block, third: 2) {Text("2nd third").tag("2nd third")}
                                if nowIsBeforeThird(block: block, third: 3) {Text("3rd third").tag("3rd third")}
                            } else {
                                Text("entirety").tag("entirety")
                                Text("1st third").tag("1st third")
                                Text("2nd third").tag("2nd third")
                                Text("3rd third").tag("3rd third")
                            }
                        } else {
                            Text("Test").tag("Test")
                            Text("Quiz").tag("Quiz")
                        }
                    }).pickerStyle(.wheel).frame(width: WKInterfaceDevice.current().screenBounds.width, height: 50, alignment: .center)
                }
            }
        }
        .sheet(isPresented: $evEditManager.isEditing, onDismiss: {eventsListObs.objectWillChange.send()}, content: { EventView(ev: evEditManager.eventToEdit!) })
        
    }
}

struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        Text("e")
    }
}

