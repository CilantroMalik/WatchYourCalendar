//
//  RichDayView.swift
//  whatever
//
//  Created by Rohan Malik on 8/29/22.
//

import SwiftUI

func cycleDayDay() -> Text {
    if cycleDay == 0 { return Text("No School!") }
    else { return Text("Day " + String(cycleDay)) }
    
}

func getNextClass() -> Text {
    if cycleDay == 0{
        return Text("None").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 0){
        return Text("First: House").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 1){
        return Text("Next: \(classes[cycleDay]![0])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 2){
        return Text("Next: \(classes[cycleDay]![1])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 3){
        return Text("Next: \(getMorningActivity())").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 4){
        return Text("Next: \(classes[cycleDay]![2])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 5){
        if getLunch(day: cycleDay, z: 1) == "Lunch"{
            return Text("Next: Lunch").foregroundColor(.green)
        } else {
            return Text("Next: \(classes[cycleDay]![3])").foregroundColor(.green)
        }
    } else if nowIsBeforeBlockBegins(block: 6){
        if getLunch(day: cycleDay, z: 2) == "Lunch"{
            return Text("Next: Lunch").foregroundColor(.green)
        } else {
            return Text("Next: \(classes[cycleDay]![3])").foregroundColor(.green)
        }
    } else if nowIsBeforeBlockBegins(block: 7){
        return Text("Next: \(classes[cycleDay]![4])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 8){
        return Text("Next: Office Hours").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 9){
        return Text("Next: " + sports[cycleDay]).foregroundColor(.green)
    } else {
        return Text("—").foregroundColor(.green)
    }
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
    
    if globalOffset != 0 {
        return "00:00:00"
    }
    
    return hr + ":" + mn + ":" + sc
}

func getTimeUntilNextClass(dc: DateComponents, now: Date = Date()) -> DateComponents {
    var date = now
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    let hr = dc.hour
    let mn = dc.minute
    let sc = dc.second
    let comp = DateComponents(calendar: cal, hour: hr, minute: mn, second:sc)
    let time = cal.nextDate(after: date, matching: comp, matchingPolicy: .nextTime)!
    let diff = cal.dateComponents([.hour, .minute, .second], from: date, to: time)
    return diff
}

func beginningTimeOfBlock() -> DateComponents {
    let cal = Calendar.current
    if nowIsBeforeBlockBegins(block: 0){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 30, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 1){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 40, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 2){
        let comp = DateComponents(calendar: cal, hour: 9, minute: 45, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 3){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 45, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 4){
        let comp = DateComponents(calendar: cal, hour: 11, minute: 20, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 5){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 25, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 6){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 50, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 7){
        let comp = DateComponents(calendar: cal, hour: 13, minute: 35, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 8){
        let comp = DateComponents(calendar: cal, hour: 14, minute: 40, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 9){
        let comp = DateComponents(calendar: cal, hour: 15, minute: 0, second:00)
        return comp
    } else {
        let comp = DateComponents(calendar: cal, hour: 0, minute: 00, second:00)
        return comp
    }
}

func getOrder() -> Text {
    return getColor(Blk: 0) + Text("-") + getColor(Blk: 1) + Text("-") + getColor(Blk: 2) + Text("-") + getColor(Blk: 3) + Text("-") + getColor(Blk: 4)
}

func getColor(Blk: Int) -> Text {
    if globalOffset == 0{
        if nowIsBeforeBlockBegins(block: Blk){
            return Text(blocks[cycleDay]![Blk]).foregroundColor(.red).fontWeight(.light)
        } else {
            return Text(blocks[cycleDay]![Blk]).foregroundColor(.blue).fontWeight(.light)
        }
    } else {
        return Text(blocks[cycleDay]![Blk]).foregroundColor(.black).fontWeight(.light)
    }
}

struct RichDayView: View {
    @State var timeUntil = "00:00:00"
    @Environment(\.scenePhase) private var scenePhase
    @State var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var opacity = 1.0
    @State var offset = 0
    @State var minOffset = 0.0
    
    func returnToCurrent() {
        var delay = 0.1
        var initialOffset = offset
        while initialOffset != 0 {
            if initialOffset < 0 {
                delayWithSeconds(delay) { offset += 1; globalOffset += 1 }
                initialOffset += 1
            } else {
                delayWithSeconds(delay) { offset -= 1; globalOffset -= 1}
                initialOffset -= 1
            }
            delay += 0.15
            delayWithSeconds(delay) { opacity = 1 }
        }
    }
    
    func getDate() -> String {
        var date = Date()
        let cal = Calendar.current
        if offset != 0 {
            date = cal.date(byAdding: .day, value: offset, to: date)!
        }
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        let year = cal.component(.year, from: date)
        let weekday = cal.component(.weekday, from: date)
        return "\(cal.shortWeekdaySymbols[weekday-1]), \(cal.shortMonthSymbols[month-1]) \(day), \(year)"
    }
    
    func classTimeComponents() -> some View {
        return Group {
            getNextClass().fontWeight(.heavy)
            Text(timeUntil).fontWeight(.light).foregroundColor(offset == 0 ? .white : .black).onReceive(timer, perform: {_ in timeUntil = getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))}).onChange(of: scenePhase, perform: { phase in
                if phase == .active {
                    timeUntil = getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))
                    timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                } else { timer.upstream.connect().cancel() }})
        }
    }
    
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
            if isNextBlock(bl: block) {  // next block
                return .green
            } else if isNextBlock(bl: block + 1) {  // now block
//                return .blue
                return .purple
            } else if nowIsBeforeBlockBegins(block: block) {  // future block
                return /*((eventsList[dtcp.month! - 1][dtcp.day!]!.isEmpty)) ? .orange : */.red
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
        let defaultEventPick = isMeetingOrAssessment(block, getNavDate()) == "Meeting" ? "Entirety" : "Test"
        return Group {
            NavigationLink(destination: {RichEventView(day: cycleDay, block: block, datecomp: getNavDate(), eventPick: defaultEventPick)}, label: {Text(time).fontWeight(getTimeWeight(block)).foregroundColor(getTimeColor(block))}).buttonStyle(PlainButtonStyle())
            Text(content).foregroundColor(getContentColor(block)).fontWeight(getContentWeight(block))
        }
    }
    
    func getNavDate() -> DateComponents {
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        return DateComponents(calendar: Calendar.current, month: cal.component(.month, from: date), day: cal.component(.day, from: date))
    }
    
    var body: some View {
        NavigationView { ScrollView {
            VStack {
                Group {
                    cycleDayDay().font(.title).fontWeight(.heavy).multilineTextAlignment(.center)
                    if globalOffset == 0 && !schoolDone() {
                        classTimeComponents()
                    } else if globalOffset != 0 {
                        Text(getRelativeDayText()).foregroundColor(.purple).fontWeight(abs(globalOffset) == 1 ? .heavy : .regular)
                    }
                    Text("\(getDate())")
                    if isSchoolDay() { getOrder() }
                    Divider()
                }
                if (isSchoolDay()) {
                    Group {
                        Text("08:30 - 08:35").fontWeight(getTimeWeight(0)).foregroundColor(getTimeColor(0))
                        Text("House").foregroundColor(getContentColor(0)).fontWeight(getContentWeight(0))
                        Spacer()
                        scheduleRow(time: "08:40 - 09:45:", block: 1, content: classes[cycleDay]![0])
                        Spacer()
                        scheduleRow(time: "09:45 - 10:45:", block: 2, content: classes[cycleDay]![1])
                        Spacer()
                    }
                    Group {
                        scheduleRow(time: "10:45 - 11:20:", block: 3, content: getMorningActivity())
                        Spacer()
                        scheduleRow(time: "11:25 - 12:25:", block: 4, content: classes[cycleDay]![2])
                        Spacer()
                    }
                    Group {
                        if ZLunch[cycleDay] == 3 {
    //                        scheduleRow(time: "12:25 - 13:30:", block: 5, content: "Lunch")
                            scheduleRow(time: "12:25 - 13:05:", block: 5, content: "Lunch (Z1)")
                            Spacer()
                            scheduleRow(time: "12:50 - 13:30:", block: 6, content: "Lunch (Z2)")
                            Spacer()
                        } else if getLunch(day: cycleDay, z: 1) == "Lunch" {
                            scheduleRow(time: "12:25 - 13:05:", block: 5, content: "Lunch (Z1)")
                            Spacer()
                            scheduleRow(time: "12:50 - 13:30:", block: 6, content: classes[cycleDay]![3])
                            Spacer()
                        } else {
                            scheduleRow(time: "12:25 - 13:05:", block: 5, content: classes[cycleDay]![3])
                            Spacer()
                            scheduleRow(time: "12:50 - 13:30:", block: 6, content: "Lunch (Z2)")
                            Spacer()
                        }
                    }
                    Group {
                        scheduleRow(time: "13:35 - 14:35:", block: 7, content: classes[cycleDay]![4])
                        Spacer()
                        scheduleRow(time: "14:45 - 15:00:", block: 8, content: "Office Hours")
                        Spacer()
                        Text("15:30 - 17:30").fontWeight(getTimeWeight(9)).foregroundColor(getTimeColor(9))
                        Text(sports[cycleDay]).foregroundColor(getContentColor(9)).fontWeight(getContentWeight(9))
                    }
                }
            }.animation(nil, value: opacity).gesture(DragGesture(minimumDistance: 25, coordinateSpace: .global).onEnded({ value in
                let horiz = value.translation.width as CGFloat
                if horiz > 0 {  // right swipe
                    opacity = 0
                    delayWithSeconds(0.3) { minOffset = 0; offset -= 1; globalOffset -= 1}
                } else {  // left swipe
                    opacity = 0
                    delayWithSeconds(0.3) { minOffset = 0; offset += 1; globalOffset += 1}
                }
                delayWithSeconds(0.35) { opacity = 1 }
            }).onChanged({value in opacity = max(0, 1.0 - abs(value.translation.width/65))}))
            .opacity(opacity).animation(.easeInOut, value: opacity)
            .gesture(TapGesture(count: 2).onEnded({ returnToCurrent() }))
        } }
    }
}

struct RichDayView_Previews: PreviewProvider {
    static var previews: some View {
        RichDayView()
    }
}
