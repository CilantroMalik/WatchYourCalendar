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
//        let hour = 11
        return hour
        
    }
    func getMinute() -> Int{
        let date = Date()
        let cal = Calendar.current
        let minute = cal.component(.minute, from: date)
        return minute
    }
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text("08:55 - 09:55:").fontWeight(.bold)
                    if (getHour() > 9){
                        Text("Comp. Sci. (C)").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Comp. Sci. (C)").foregroundColor(.red).fontWeight(.medium)}
                    }
                Spacer()
                Text("10:00 - 10:30:").fontWeight(.bold)
                if (getHour() > 11){
                    Text("Class Meeting").foregroundColor(.blue).fontWeight(.light)}
                else {
                    Text("Class Meeting").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                }
                Group{
                Text("10:35 - 11:20:").fontWeight(.bold)
                    if (getHour() > 12){
                        Text("Physics (D)").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Physics (D)").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("11:25 - 12:25:").fontWeight(.bold)
                    if (getHour() > 12){
                        Text("Latin (F)").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Latin (F)").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("12:25 - 13:15:").fontWeight(.bold)
                    if (getHour() > 12){
                        Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Lunch").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("13:20 - 14:20:").fontWeight(.bold)
                    if (getHour() > 13){
                        Text("English (E)").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("English (E)").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("14:30 - 15:15:").fontWeight(.bold)
                    if (getHour() > 14){
                        Text("Spanish (G)").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Spanish (G)").foregroundColor(.red).fontWeight(.medium)}
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
