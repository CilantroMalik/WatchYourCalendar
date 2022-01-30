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
if nowIsAfterBlock(block: 0){
return (Text(order[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium))
} else if nowIsAfterBlock(block: 2) {
return (Text(order[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium))
    } else if nowIsAfterBlock(block: 3){
return (Text(order[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium))
} else if nowIsAfterBlock(block: 5){
return (Text(order[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium))
} else if nowIsAfterBlock(block: 5){
return (Text(order[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light))
} else if isAfter(hour1: getHour(), minute1: getMinute(), hour2: 8, minute2: 55){
return (Text(order[cycleDay]![0]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium) + Text("-") + Text(order[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium))
} else {
    return Text("")
}
}
func getNextClass() -> String {
    if cycleDay == 0{
        return ""
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 8,minute2: 55){
        return ("Next: " + classes[cycleDay]![0])
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 00){
        return ("Next: " + getMorningActivity())
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 10,minute2: 35){
        return ("Next: " + classes[cycleDay]![1])
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 11,minute2: 25){
        return ("Next: " + classes[cycleDay]![2])
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 13,minute2: 20){
        return ("Next: " + classes[cycleDay]![3])
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 14,minute2: 30){
        return ("Next: " + classes[cycleDay]![4])
    } else if isAfter(hour1: getHour(),minute1: getMinute(),hour2: 15,minute2: 15){
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

