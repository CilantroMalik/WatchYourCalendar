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
        return Group {
            NavigationLink(destination: {MidView(cycleDay, block, dtcp)}, label: {Text(time).fontWeight(getTimeWeight(block)).foregroundColor(getTimeColor(block))}).buttonStyle(PlainButtonStyle())
            Text(content).foregroundColor(getContentColor(block)).fontWeight(getContentWeight(block))
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{//TODO: fix spacing
                Group{
                    Text(getCycleDayDay()).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                    Text(getOffsetDate()).font(.title3).fontWeight(.bold).multilineTextAlignment(.center)
                }
                Spacer()
                scheduleRow(time: "08:55 - 09:55:", block: 0, content: classes[cycleDay]![0])
                scheduleRow(time: "10:00 - 10:30:", block: 1, content: getMorningActivity())
                Spacer()
                Group{
                    scheduleRow(time: "10:35 - 11:25:", block: 2, content: classes[cycleDay]![1])
                    Spacer()
                    (lunchBlockFirst[cycleDay]! == [true]) ? scheduleRow(time: "11:25 - 12:25:", block: 4, content: "Lunch") : scheduleRow(time: "11:25 - 12:25:", block: 3, content: classes[cycleDay]![2])
                    Spacer()
                    Spacer()
                }
                Group{
                    (lunchBlockFirst[cycleDay]! == [true]) ? (scheduleRow(time: "12:25 - 13:15:", block: 4, content: classes[cycleDay]![3])) : (scheduleRow(time: "12:25 - 13:15:", block: 4, content: "Lunch"))
                    Spacer()
                    Spacer()
                }
                Group{
                    scheduleRow(time: "13:20 - 14:20:", block: 5, content: classes[cycleDay]![3])
                    Spacer()
                    scheduleRow(time: "14:20 - 14:30:", block: 9, content: "Break") //BLOCK 9 IS THE 10 MINUTE BREAK
                    Spacer()
                    scheduleRow(time: "14:30 - 15:15:", block: 6, content: classes[cycleDay]![4])
                    if (isSports()){
                        if globalOffset == 0 {
                            if isNextBlock(bl: 7){
                                Text("15:20 - 16:10:").fontWeight(.bold).foregroundColor(.red)
                                Text("Fitness Center").foregroundColor(.green).fontWeight(.medium)
                            } else if nowIsBeforeBlockBegins(block: 7){
                                Text("15:20 - 16:10:").fontWeight(.bold)
                                Text("Fitness Center").foregroundColor(.red).fontWeight(.medium)}
                            else {
                                Text("15:20 - 16:10:").fontWeight(.medium).foregroundColor(Color(UIColor.lightGray))
                                Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
                        } else if globalOffset < 0 {
                            Text("15:20 - 16:10:").fontWeight(.bold)
                            Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
                        else {
                            Text("15:20 - 16:10:").fontWeight(.bold)
                            Text("Fitness Center").foregroundColor(.red).fontWeight(.medium)
                        }
                    }
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
