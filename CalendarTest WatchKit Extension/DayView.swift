//  DayView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView: View {
    
    func scheduleRow(time: String, block: Int, content: String) -> some View {
        return Group {
            if globalOffset == 0 {
                if isNextBlock(bl: block){
                    NavigationLink(destination: {SchedulingView(day: cycleDay, block: block)}, label: {Text(time).fontWeight(.bold).foregroundColor(.red)}).buttonStyle(PlainButtonStyle())
                    Text(content).foregroundColor(.green).fontWeight(.medium)
                } else if nowIsBeforeBlockBegins(block: block){
                    NavigationLink(destination: {SchedulingView(day: cycleDay, block: block)}, label: {Text(time).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
                    Text(content).foregroundColor(.red).fontWeight(.medium)
                } else {
                    NavigationLink(destination: {SchedulingView(day: cycleDay, block: block)}, label: {Text(time).fontWeight(.medium).foregroundColor(.gray)}).buttonStyle(PlainButtonStyle())
                    Text(content).foregroundColor(.blue).fontWeight(.light)
                }
            } else {
                NavigationLink(destination: {SchedulingView(day: cycleDay, block: block)}, label: {Text(time).fontWeight(.bold)}).buttonStyle(PlainButtonStyle())
                Text(content).foregroundColor(.blue).fontWeight(.light)
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text(getCycleDayDay()).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                    scheduleRow(time: "08:55 - 09:55:", block: 0, content: classes[cycleDay]![0])
                }
                Spacer()
                scheduleRow(time: "10:00 - 10:30:", block: 1, content: getMorningActivity())
                Spacer()
                Group{
                    scheduleRow(time: "10:35 - 11:25:", block: 2, content: classes[cycleDay]![1])
                    Spacer()
                    scheduleRow(time: "11:25 - 12:25:", block: 3, content: classes[cycleDay]![2])
                    Spacer()
                    Spacer()
                }
                Group{
                    scheduleRow(time: "12:25 - 13:15:", block: 4, content: "Lunch")
                    Spacer()
                    Spacer()
                }
                Group{
                    scheduleRow(time: "13:20 - 14:20:", block: 5, content: classes[cycleDay]![3])
                    Spacer()
                    scheduleRow(time: "14:30 - 15:15:", block: 6, content: classes[cycleDay]![4])
                    if isSports() {
                        scheduleRow(time: "15:20 - 16:10:", block: 7, content: "Fitness Center")
                    }
                }
            }
        }
    }
}
struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}
