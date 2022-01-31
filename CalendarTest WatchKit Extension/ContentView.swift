//
//  ContentView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//
 
import SwiftUI
func beginningTimeOfBlock() -> DateComponents {
    let cal = Calendar.current
    if nowIsBeforeBlockBegins(block: 0){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 1){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 00, second:00)
        return comp
    } else if (nowIsBeforeBlockBegins(block: 2)){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 35, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 3){
        let comp = DateComponents(calendar: cal, hour: 11, minute: 25, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 4){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 30, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 5){
        let comp = DateComponents(calendar: cal, hour: 13, minute: 20, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 6){
        let comp = DateComponents(calendar: cal, hour: 14, minute: 30, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 7){
        let comp = DateComponents(calendar: cal, hour: 15, minute: 20, second:00)
        return comp
    } else {
        let comp = DateComponents(calendar: cal, hour: 8, minute: 55, second:00)
        return comp
    }
}
func getTimeUntilNextClass(dc: DateComponents) -> DateComponents {
    let date = Date()
    let cal = Calendar.current
    let hr = dc.hour
    let mn = dc.minute
    let sc = dc.second
    let comp = DateComponents(calendar: cal, hour: hr, minute: mn, second:sc)
    let time = cal.nextDate(after: date, matching: comp, matchingPolicy: .nextTime)!
    let diff = cal.dateComponents([.hour, .minute, .second], from: date, to: time)
    return diff
}
func getTime(dc: DateComponents) -> String {
    var hr = String(dc.hour!)
    if hr.count == 1 {
        hr = "0" + hr
    }
    var mn = String(dc.minute!)
    if mn.count == 1 {
        mn = "0" + mn
    }
    var sc = String(dc.second!)
    if sc.count == 1 {
        sc = "0" + sc
    }
    
    return hr + ":" + mn + ":" + sc
}

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
    } else if bb == 2 {
        return 1
    } else if bb == 3 {
        return 2
    } else if bb == 5 {
        return 3
    } else if bb == 6 {
        return 4
    } else {
        return 99
    }
}
func getNextClass() -> Text {
    if cycleDay == 0{
        return Text("")
    } else if nowIsBeforeBlockBegins(block: 0){
        return Text("First Class: ") + Text(classes[cycleDay]![0]).foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 1){
        return Text("Next: ") + Text(getMorningActivity()).foregroundColor(.red)
    } else if (nowIsBeforeBlockBegins(block: 2)){
        return Text("Next: ") + Text(classes[cycleDay]![1]).foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 3){
        return Text("Next: ") + Text(classes[cycleDay]![2]).foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 4){
        return Text("Next: ") + Text("Lunch").foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 5){
        return Text("Next: ") + Text(classes[cycleDay]![3]).foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 6){
        return Text("Next: ") + Text(classes[cycleDay]![4]).foregroundColor(.red)
    } else if nowIsBeforeBlockBegins(block: 7){
        return Text("Next: ") + Text(classes[cycleDay]![5]).foregroundColor(.red)
    } else {
        return Text("Next: Go home!")
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
    @State var updation = Text("error")
    var body: some View {
        VStack{
            Spacer()
        Text("Day \(cycleDay)")
            .font(.title)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
        }
        VStack{
            getNextClass().fontWeight(.heavy)
//            while isSchool(){
//            self.updation = Text(getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))).fontWeight(.light)
//            }
            if isSchool() {
                Text("In: ") + Text(getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))).fontWeight(.light)}
            Text("\(getDate())")
            
        }
        VStack{
            getOrder()
            

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
 

