//
//  RichEventView.swift
//  whatever
//
//  Created by Rohan Malik on 8/29/22.
//

import SwiftUI

struct RichEventView: View {
    var day : Int
    var block : Int
    var datecomp : DateComponents
    @State var eventPick: String
    @State var eventName: String = ""
    @State var refresh = " "
    
    @StateObject var eventsListObs = EventsListObs()
    
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
    
    func getEventLabel(_ lbl: String) -> String {
        var lbl2 = lbl
        if (lbl.contains(";")) {
            let target = lbl.split(separator: ";")
            if target.count == 1 { lbl2.removeLast(); return lbl2 }
            else { return String(target[1]) }
        } else {
            return lbl
        }
    }
    
    func findHighestID(_ arr: [blockEvent]) -> Int {
        var highest = 0
        for ev in arr {
            let n = Int(String(ev.id.last!))!
            if n > highest { highest = n }
        }
        return highest+1
    }
    
    func getClass(day: Int, block: Int) -> String {
        if ZLunch[cycleDay] == 3 && (block == 5 || block == 6) { return "Lunch" }
        else {
            switch block {
            case 0:
                return "House"
            case 1:
                return classes[day]![0]
            case 2:
                return classes[day]![1]
            case 3:
                return getMorningActivity()
            case 4:
                return classes[day]![2]
            case 5:
                if getLunch(day: cycleDay, z: 1) == "Lunch" { return "Lunch" }
                else { return "\(classes[cycleDay]![3])" }
            case 6:
                if getLunch(day: cycleDay, z: 2) == "Lunch" { return "Lunch" }
                else { return "\(classes[cycleDay]![3])" }
            case 7:
                return classes[day]![4]
            case 8:
                return "Office Hours"
            case 9:
                return sports[day]
            default:
                return "eeee"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(getPeriod(blockNum: block)), Day \(day)").font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                Text(getClass(day: day, block: block)).font(.system(size: 20)).fontWeight(.semibold).padding(.bottom, 0.5)
                Text(getBlockTime(block: block))
                Text(getOffsetDate())
                Divider().padding(.vertical, 5)
                if (eventsThisBlock()).count == 0 {
                    Text("No Events").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
                } else {
                    ForEach(eventsThisBlock(), id: \.id) { ev in
                        HStack {
                            VStack {
                                if ev.hasLabel {Text(getEventLabel(ev.label)).fontWeight(.heavy).foregroundColor(.orange)}
                                Text("Day \(ev.getDay()), \(ev.getPeriod())").multilineTextAlignment(.center)
                                Text(ev.getTime(label: ev.label)).multilineTextAlignment(.center)
                                if ev.getRoom() != "e" {Text(ev.getRoom()).italic().multilineTextAlignment(.center)}
                                Text(getOffsetDate()).italic().multilineTextAlignment(.center)
                                ev.hasNotification ?  Text("Notifications on").fontWeight(.heavy) : Text("Notifications off").italic().foregroundColor(Color(UIColor.lightGray))
                            }
                            Divider().padding(.horizontal)
                            VStack {
                                Text("Options:").font(.title3).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 5)
                                Button(action: {
                                    eventsListObs.delEvent(ev: ev)
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ev.toString()])
                                }, label: {Text("Delete Event").fontWeight(.heavy).multilineTextAlignment(.center)})
                                Spacer().frame(height: 15)
                                if !ev.hasNotification {
                                    Button(action: {
                                        for i in 1...EventsListObs.evList[ev.time.month!-1][ev.time.day!]!.count {
                                            if EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].isEqual(ev) { EventsListObs.evList[ev.time.month!-1][ev.time.day!]![i-1].hasNotification = true }
                                        }
                                        eventsListObs.saveList()
                                        // *** Schedule Meeting Notification ***
                                        let content = UNMutableNotificationContent()
                                        var detail = ev.label.contains(";") ? String(ev.label.split(separator: ";")[0]).split(separator: " ") : ev.label.split(separator: " ")
                                        detail.removeLast()
                                        detail.removeLast()
                                        if ev.meetingOrAssessment() == "Assessment" {
                                            if (ev.label.contains(";")) { content.title = ("Reminder: " + String(String(ev.label.split(separator: ";")[0]).split(separator: " ")[0]) + " (\(String(ev.label.split(separator: ";")[1])))") }
                                            else { content.title = "Reminder: " + String(ev.label.split(separator: " ")[0]) }
                                        } else { content.title = "Reminder: Meeting" }
                                        if ev.getRoom() != "e" {
                                            content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "; " + ev.getTime(label: getEventLabel(ev.label)) + "; " + ev.getRoom())
                                        } else {
                                            content.subtitle = ("Day " + String(ev.getDay()) + ", " + ev.getPeriod() + "; " + ev.getTime(label: getEventLabel(ev.label)))
                                        }
                                        content.sound = UNNotificationSound.default
                                        if #available(watchOSApplicationExtension 8.0, *) {
                                            content.interruptionLevel = .timeSensitive
                                        }
                                        
                                        if ev.meetingOrAssessment() == "Assessment" {
                                            content.body = "Reminder: You have a \(String(ev.label.split(separator: " ")[0]).lowercased()) this block. Good luck!"
                                        } else {
                                            content.body = "Reminder: You have a meeting during the \(String(ev.label.split(separator: "#")[0]).lowercased())of the block."
                                            if String(ev.label.split(separator: " ")[0]).lowercased() == "entire" { content.body = "Reminder: You have a meeting for the entire block." }
                                        }
                                        content.categoryIdentifier = "event"
                                        
                                        //let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(calendar: Calendar.current, month: ev.time.month!, day: ev.time.day!, hour: getBlockAlmostStartTimes(ev.block).hour, minute: getBlockAlmostStartTimes(ev.block).minute), repeats: false)
                                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                        
                                        let request = UNNotificationRequest(identifier: ev.toString(), content: content, trigger: trigger)
                                        
                                        // add our notification request
                                        UNUserNotificationCenter.current().add(request)
                                        
                                        // trigger view refresh
                                        refresh += " "
                                    }, label: { Text("Be notified!").fontWeight(.medium) })
                                }
                            }
                        }
                        Divider()
                    }
                }
                Divider().padding(.vertical, 1) //FIXME: PADDING
                if globalOffset < 0 || (globalOffset == 0 && nowIsAfterBlockEnds(block: (block)))/* || (nowIsBeforeQuarter(block: block, q: 4))*/{
                    Text("You cannot schedule events in the past.").fontWeight(.medium).multilineTextAlignment(.center)
                } else {
                    TextField("Name Event", text: $eventName, prompt: Text(isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Meeting name: " : "Assessment name: ")).padding()
                    Picker(isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Select Part of Block" : "Select Assessment Type", selection: $eventPick, content: {
                        if isMeetingOrAssessment(block, datecomp) == "Meeting" {
                            if isToday() {
                                if nowIsBeforeBlockBegins(block: (block)) {Text("Entire block").tag("Entire block #")}
                                if nowIsBeforeQuarter(block: block, q: 1) {Text("1st qtr").tag("1st quarter #")}
                                if nowIsBeforeQuarter(block: block, q: 2) {Text("2nd qtr").tag("2nd quarter #")}
                                if nowIsBeforeQuarter(block: block, q: 3) {Text("3rd qtr").tag("3rd quarter #")}
                                if nowIsBeforeQuarter(block: block, q: 4) {Text("4th qtr").tag("4th quarter #")}
                            } else {
                                Text("Entire block").tag("Entire block #")
                                Text("1st qtr").tag("1st quarter #")
                                Text("2nd qtr").tag("2nd quarter #")
                                Text("3rd qtr").tag("3rd quarter #")
                                Text("4th qtr").tag("4th quarter #")
                            }
                        } else {
                            Text("Test").tag("Test")
                            Text("Quiz").tag("Quiz")
                        }
                    }).pickerStyle(.segmented).frame(width: UIScreen.main.bounds.size.width / 1.05, alignment: .center)
                    Button(action: {
                        let n = EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!.filter({$0.label.contains(eventPick)}).count + 1
                        let cleanEventName = eventName.replacingOccurrences(of: "-", with: " ")
                        let temp = blockEvent(block, datecomp, makeId(block: block, time: datecomp, num: findHighestID(EventsListObs.evList[datecomp.month! - 1][datecomp.day!]!)), "\(eventPick)\(n);\(cleanEventName)", true, false)
                        
                        eventsListObs.addEvent(ev: temp, month: datecomp.month!-1, day: datecomp.day!)
                        eventPick = isMeetingOrAssessment(block, datecomp) == "Meeting" ? "Entire block #" : "Test"
                        eventName = ""
                    }, label: {
                        Text("Add Event").fontWeight(.heavy).multilineTextAlignment(.center)
                    })
                }
                Text(refresh)
            }
        }
    }
}

struct RichEventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("e")
    }
}
