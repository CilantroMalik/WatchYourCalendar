//
//  DayView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView: View {
//    @ObservedObject var dayManager = DayFetcher()
    func getHour() -> Int{
        let date = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        return hour
        
    }
    func getMinute() -> Int{
        let date = Date()
        let cal = Calendar.current
        let minute = cal.component(.minute, from: date)
        return minute
    }
    func getMorningActivity() -> String {
        // TODO
        let date = Date()
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date)
        switch weekday {
        case 1:
            return "None"
        case 2:
            return "Community Meeting"
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
            return "error..."
        }
    }
    func isAfter(hour1:Int,minute1: Int,hour2:Int ,minute2:Int) -> Bool{
        if hour2>hour1{
            return true
        } else if hour1>hour2{
            return false
        } else {
            return (minute2>minute1)
        }
        
    }
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text("08:55 - 09:55:").fontWeight(.bold)
                    if isAfter(hour1: 9,minute1: 55,hour2: getHour(),minute2: getMinute()){
                        Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![0]).foregroundColor(.red).fontWeight(.medium)}
                    }
                Spacer()
                Text("10:00 - 10:30:").fontWeight(.bold)
                if isAfter(hour1: 10,minute1: 30,hour2: getHour(),minute2: getMinute()){
                    Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                else {
                    Text(getMorningActivity()).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                }
                Group{
                Text("10:35 - 11:20:").fontWeight(.bold)
                    if isAfter(hour1: 11,minute1: 20,hour2: getHour(),minute2: getMinute()){
                        Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("11:25 - 12:25:").fontWeight(.bold)
                    if isAfter(hour1: 12,minute1: 25,hour2: getHour(),minute2: getMinute()){
                        Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("12:25 - 13:15:").fontWeight(.bold)
                    if isAfter(hour1: 13,minute1: 15,hour2: getHour(),minute2: getMinute()){
                        Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Lunch").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("13:20 - 14:20:").fontWeight(.bold)
                    if isAfter(hour1: 14,minute1: 20,hour2: getHour(),minute2: getMinute()){
                        Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("14:30 - 15:15:").fontWeight(.bold)
                    if isAfter(hour1: 15,minute1: 15,hour2: getHour(),minute2: getMinute()){
                        Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![5]).foregroundColor(.red).fontWeight(.medium)}
                }
            }
//        VStack{
//            NavigationLink(destination: DayView1()){
//                Text("Comp Sci")
//                        }
//            NavigationLink(destination: DayView2()){
//                Text("Class Meeting")
//                        }
//            NavigationLink(destination: DayView3()){
//                Text("Physics")
//                        }
//            NavigationLink(destination: DayView4()){
//                Text("Latin")
//                        }
//            NavigationLink(destination: DayView5()){
//                Text("Lunch")
//                        }
//            NavigationLink(destination: DayView6()){
//                Text("English")
//                        }
//            NavigationLink(destination: DayView7()){
//                Text("Spanish")
//                        }
//
//
//
//        }
        }
    }


struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}
