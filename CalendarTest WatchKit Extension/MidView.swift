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
            return "Advisory"
        case 1:
            return blocks[day]![0] + " Block"
        case 2:
            return blocks[day]![1] + " Block"
        case 3:
            switch weekday {
            case 1:
                return "None"
            case 2:
                return "/nCommunity Meeting"
            case 3:
                return "Clubs"
            case 4:
                return "Class Meeting"
            case 5:
                return "Advisory"
            case 6:
                return "Clubs"
            case 7:
                return "None"
            default:
                return "error"
            }
        case 4:
            return blocks[day]![2] + " Block"
        case 5:
            if getLunch(day: cycleDay, z: 1) == "Lunch"{
                return "Lunch (Z1)"
            } else {
                return "Z1"
            }
        case 6:
            if getLunch(day: cycleDay, z: 2) == "Lunch"{
                return "Lunch (Z2)"
            } else {
                return "Z2"
            }
        case 7:
            return blocks[day]![4] + " Block"
        case 8:
            return "Office Hours"
        case 9:
            return sports[day]
        default:
            return "e"
        }
    }
    func meetingOrAssessment() -> String {
        if ZLunch[cycleDay] == 3 && (block == 5 || block == 6){
            return "Meeting"
        } else {
            switch block {
            case 0:
                return "Meeting"
            case 1:
                return (classes[day]![0].starts(with: "Free") || classes[day]![0].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 2:
                return (classes[day]![1].starts(with: "Free") || classes[day]![1].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 3:
                return "Meeting"
            case 4:
                return (classes[day]![2].starts(with: "Free") || classes[day]![2].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 5:
                if getLunch(day: cycleDay, z: 1) == "Lunch"{
                    return "Meeting"
                } else {
                    return (classes[day]![3].starts(with: "Free") || classes[day]![3].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
                }
            case 6:
                if getLunch(day: cycleDay, z: 2) == "Lunch"{
                    return "Meeting"
                } else {
                    return (classes[day]![3].starts(with: "Free") || classes[day]![3].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
                }
            case 7:
                return (classes[day]![4].starts(with: "Free") || classes[day]![4].starts(with: "Study Hall")) ? "Meeting" : "Assessment"
            case 8:
                return "Meeting"
            default:
                return "e"
            }
        }
    }
    func getBlockTime(block: Int) -> String{
//        if ZLunch[cycleDay] == 3 && (block == 5 || block == 6){
//            return "12:25 - 13:30"
//        } else {
            switch block {
            case 0:
                return "08:30 - 08:35"
            case 1:
                return "08:40 - 09:40"
            case 2:
                return "09:45 - 10:45"
            case 3:
                return "10:45 - 11:20"
            case 4:
                return "11:20 - 12:20"
            case 5:
                return "12:25 - 13:05"
            case 6:
                return "12:50 - 13:30"
            case 7:
                return "13:35 - 14:35"
            case 8:
                return "14:40 - 15:00"
            case 9:
                return "15:30 - 17:00"
            default:
                return "e"
            }
//        }
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
                Text("\(getPeriod(blockNum: block)), Day \(day)").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 0.5)
//                Text("Day \(day), \(getPeriod(blockNum: block))")
                Text(getBlockTime(block: block))
                Text(getOffsetDate())
                Divider().padding(.vertical, 5)
                if (eventsThisBlock()).count == 0 {
                    Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
                } else {
                    ForEach(eventsThisBlock(), id: \.id) { item in
                        Button(action: { evEditManager.eventToEdit = item; evEditManager.isEditing.toggle() }, label: { Text(item.label) })
                    }
                }
                Divider().padding(.vertical, 1) //FIXME: PADDING
                if globalOffset < 0 || (globalOffset == 0 && nowIsAfterBlockEnds(block: (block)))/* || (nowIsBeforeQuarter(block: block, q: 4))*/{
                    Text("You cannot schedule events in the past.").fontWeight(.medium).multilineTextAlignment(.center)
                } else {
                    Picker(isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Select Part of Block" : "Select Assessment Type", selection: $eventPick, content: {
                        if isMeetingOrAssessment(block, datecomp) == "Meeting" {
                            if isToday() {
                                if nowIsBeforeBlockBegins(block: (block)) {Text("Entirety of Block").tag("Entirety of Block-")}
                                if nowIsBeforeQuarter(block: block, q: 1) {Text("First Quarter").tag("Q1-")}
                                if nowIsBeforeQuarter(block: block, q: 2) {Text("Second Quarter").tag("Q2-")}
                                if nowIsBeforeQuarter(block: block, q: 3) {Text("Third Quarter").tag("Q3-")}
                                if nowIsBeforeQuarter(block: block, q: 4) {Text("Fourth Quarter").tag("Q4-")}
                            } else {
                                Text("Entirety of Block").tag("Entirety of Block -")
                                Text("First Quarter").tag("Q1-")
                                Text("Second Quarter").tag("Q2-")
                                Text("Third Quarter").tag("Q3-")
                                Text("Fourth Quarter").tag("Q4-")
                            }
                        } else {
                            Text("Test").tag("Test")
                            Text("Quiz").tag("Quiz")
                        }
                    }).pickerStyle(.wheel).frame(width: WKInterfaceDevice.current().screenBounds.width, height: 50, alignment: .center)
                    Button(action: {
                        let n = EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!.filter({$0.label.contains(eventPick)}).count + 1
                        let temp = blockEvent(block, datecomp, makeId(block: block, time: datecomp, num: EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!.count+1), isMeetingOrAssessment(block, datecomp) == "Meeting" ? "\(eventPick) \(n)" : "\(eventPick) \(n)", true, false)
                        
                        eventsListObs.addEvent(ev: temp, month: datecomp.month!-1, day: datecomp.day!)
                        eventPick = isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Entirety of Block" : "Test"
                        print (temp.block)
                    }, label: {
                        Text("Add Event").fontWeight(.heavy).multilineTextAlignment(.center)
                    })
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

