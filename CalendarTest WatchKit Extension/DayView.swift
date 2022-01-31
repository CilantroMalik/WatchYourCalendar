//
//  ContentView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//
 
import SwiftUI
func getDate() -> String {
    let date = Date()
    let cal = Calendar.current
    let month = cal.component(.month, from: date)
    let day = cal.component(.day, from: date)
    let year = cal.component(.year, from: date)
    let weekday = cal.component(.weekday, from: date)
    return "\(cal.shortWeekdaySymbols[weekday-1]), \(cal.shortMonthSymbols[month-1]) \(day), \(year)"
}
 
func getOrder() -> Text {
    return getColor(Blk: 0) + Text("-") + getColor(Blk: 2) + Text("-") + getColor(Blk: 3) + Text("-") + getColor(Blk: 5) + Text("-") + getColor(Blk: 6)
}
func getColor(Blk: Int) -> Text {
    if nowIsBeforeBlockBegins(block: Blk){
        return Text(order[cycleDay]![blockToBlock(bb: Blk)]).foregroundColor(.red).fontWeight(.light)
    } else {
        return Text(order[cycleDay]![blockToBlock(bb: Blk)]).foregroundColor(.blue).fontWeight(.light)
    }
}
func blockToBlock(bb: Int) -> Int {
    if bb == 0{
        return 0
    } else if bb == 1 {
        return 0
    } else if bb == 2 {
        return 1
    } else if bb == 3 {
        return 2
    } else if bb == 4 {
        return 2
    } else if bb == 5 {
        return 3
    } else if bb == 6 {
        return 4
    } else if bb == 7 {
        return 4
    } else {
        return 99
    }
}
func getNextClass() -> String {
    if cycleDay == 0{
        return ""
    } else if nowIsBeforeBlockBegins(block: 0){
        return ("First Class: " + classes[cycleDay]![0])
    } else if nowIsBeforeBlockBegins(block: 1){
        return ("Next: " + getMorningActivity())
    } else if (nowIsBeforeBlockBegins(block: 2)){
        return ("Next: " + classes[cycleDay]![1])
    } else if nowIsBeforeBlockBegins(block: 3){
        return ("Next: " + classes[cycleDay]![2])
    } else if nowIsBeforeBlockBegins(block: 4){
        return ("Next: Lunch")
    } else if nowIsBeforeBlockBegins(block: 5){
        return ("Next: " + classes[cycleDay]![3])
    } else if nowIsBeforeBlockBegins(block: 6){
        return ("Next: " + classes[cycleDay]![4])
    } else if nowIsBeforeBlockBegins(block: 7){
        return ("Next: " + classes[cycleDay]![5])
    } else {
        return "Next: Go home!"
    }
}
func getClasses() -> String {
    if let classList = classes[cycleDay]?.joined(separator: "\n") {
        return classList
    } else { return "e" }
}
 
var order: [Int: [String]] = [
    0:["----No school!","","","",""],
    1:["C","E","D","A","B"], 2:["F","G","H","A","B"], 3:["C","D","F","E","G"], 4:["H","A","B","C","D"], 5:["G","A","H","E","F"], 6:["B","C","D","E","F"], 7:["A","H","G","B","C"], 8:["D","E","F","G","H"]
]
 
 
struct ContentView: View {
     
    var body: some View {
 
        VStack{
            Spacer()
        Text("Day \(cycleDay)")
            .font(.title)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
            .padding()
            
            Text (getNextClass()).fontWeight(.heavy)
            Text("\(getDate())")
            
            
            getOrder()
            
            Spacer()
            Spacer()
            Spacer()
            if isSchool() {
            NavigationLink(destination: DayView()){
                Text("Today")
                    .fontWeight(.heavy)
                        }
            }
        }
 
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
