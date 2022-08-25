//  DayView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView: View {
    var dtcp: DateComponents
    var events = [blockEvent]()
    
    func getTimeWeight(_ block: Int) -> Font.Weight {
        if globalOffset == 0 {
            if isNextBlock(bl: block) {  // next block
                return .bold
            } else if isNextBlock(bl: block + 1) {  // now block
                return .bold
            } else if nowIsBeforeBlockBegins(block: block) {  // future block
                return .bold
            } else {  // past block
                return .medium
            }
        } else if globalOffset > 0 {
            return .bold
        } else {
            return .bold
        }
    }
    
    func getContentWeight(_ block: Int) -> Font.Weight {
        if globalOffset == 0 {
            if isNextBlock(bl: block) {  // next block
                return .medium
            } else if isNextBlock(bl: block + 1) {  // now block
                return .medium
            } else if nowIsBeforeBlockBegins(block: block) {  // future block
                return .medium
            } else {  // past block
                return .light
            }
        } else if globalOffset > 0 {
            return .medium
        } else {
            return .light
        }
    }
    
    func getTimeColor(_ block: Int) -> Color {
        if globalOffset == 0 {
            if isNextBlock(bl: block) {  // next block
                return .green
            } else if isNextBlock(bl: block + 1) {  // now block
                return Color(UIColor.lightGray)
            } else if nowIsBeforeBlockBegins(block: block) {  // future block
                return .white // ?
            } else {  // past block
                return Color(UIColor.lightGray)
            }
        } else if globalOffset > 0 {
            return .white // ?
        } else {
            return Color(UIColor.lightGray)
        }
    }
    
    func getContentColor(_ block: Int) -> Color {
        if globalOffset == 0 {
//            if !(eventsList[dtcp.month! - 1][dtcp.day!]!.isEmpty) { //FIXME: doth this worketh?
//                return .orange
//            } else
            if isNextBlock(bl: block) {  // next block
                return .green
            } else if isNextBlock(bl: block + 1) {  // now block
                return .blue
                //return .purple
            } else if nowIsBeforeBlockBegins(block: block) {  // future block
                return .red
            } else {  // past block;
                return .blue
            }
        } else if globalOffset > 0 {
            return .red
        } else {
            return .blue
        }
    }
    
    func scheduleRow(time: String, block: Int, content: String) -> some View {
        let defaultEventPick =  isMeetingOrAssessment(block, dtcp) == "Meeting" ? "Entirety" : "Test"
        return Group {
            NavigationLink(destination: {MidView(day: cycleDay, block: block, datecomp: dtcp, eventPick: defaultEventPick)}, label: {Text(time).fontWeight(getTimeWeight(block)).foregroundColor(getTimeColor(block))}).buttonStyle(PlainButtonStyle())
            Text(content).foregroundColor(getContentColor(block)).fontWeight(getContentWeight(block))
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{//TODO: fix spacing
                Group{
                    Text(getCycleDayDay()).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                    Text(getOffsetDate()).font(.caption2).fontWeight(.heavy).multilineTextAlignment(.center)
                    if getRelativeDayText() != "" {Text(getRelativeDayText()).font(.caption2).foregroundColor(.purple).fontWeight(abs(globalOffset) == 1 ? .heavy : .regular)}
                    Spacer()
                    Spacer()
                    Divider().padding(.vertical, 0)
                }
                Group{
                scheduleRow(time: "08:30 - 08:35:", block: 0, content: "House")
                    Spacer()
                scheduleRow(time: "08:40 - 09:45:", block: 1, content: classes[cycleDay]![0])
                    Spacer()
                scheduleRow(time: "09:45 - 10:45:", block: 2, content: classes[cycleDay]![1])
                    Spacer()
                }
                Group{
                scheduleRow(time: "10:45 - 11:20:", block: 3, content: getMorningActivity())
                    Spacer()
                scheduleRow(time: "11:25 - 12:25:", block: 4, content: classes[cycleDay]![2])
                    Spacer()
                }
                Group{
                    if ZLunch[cycleDay] == 3{
                        scheduleRow(time: "12:25 - 13:30:", block: 5, content: "Lunch")
                    } else if getLunch(day: cycleDay, z: 1) == "Lunch"{
                        scheduleRow(time: "12:25 - 13:05:", block: 5, content: "Lunch")
                        Spacer()
                        scheduleRow(time: "12:50 - 13:30:", block: 6, content: classes[cycleDay]![3])
                        Spacer()
                    } else {
                        scheduleRow(time: "12:25 - 13:05:", block: 5, content: classes[cycleDay]![3])
                        Spacer()
                        scheduleRow(time: "12:50 - 13:30:", block: 6, content: "Lunch")
                        Spacer()
                    }
                }
                Group{
                    scheduleRow(time: "13:35 - 14:35:", block: 7, content: classes[cycleDay]![4])
                    Spacer()
                    scheduleRow(time: "14:45 - 15:00:", block: 8, content: "Office Hours")
                    Spacer()
                    scheduleRow(time: "15:30 - 17:00:", block: 9, content: sports[cycleDay])
                    Spacer()
                }
            }
        }
    }
}
struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(dtcp: DateComponents(calendar: Calendar.current))
    }
}
