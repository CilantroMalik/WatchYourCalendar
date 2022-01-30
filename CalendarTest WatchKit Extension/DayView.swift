//
//  DayView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView: View {
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    Text("08:55 - 09:55:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 0){
                        Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![0]).foregroundColor(.red).fontWeight(.medium)}
                    }
                Spacer()
                Text("10:00 - 10:30:").fontWeight(.bold)
                if nowIsAfterBlock(block: 1){
                    Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                else {
                    Text(getMorningActivity()).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                }
                Group{
                Text("10:35 - 11:20:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 2){
                        Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("11:25 - 12:25:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 3){
                        Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("12:25 - 13:15:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 4){
                        Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text("Lunch").foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Spacer()
                }
                Group{
                Text("13:20 - 14:20:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 5){
                        Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium)}
                Spacer()
                Text("14:30 - 15:15:").fontWeight(.bold)
                    if nowIsAfterBlock(block: 6){
                        Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                    else {
                        Text(classes[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium)}
                    if (isSports()){
                        Text("15:20 - 16:10:").fontWeight(.bold)
                        if isAfter(hour1: 16,minute1: 10,hour2: getHour(),minute2: getMinute()){
                            Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
                        else {
                            Text("Fitness Center").foregroundColor(.red).fontWeight(.medium)}
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
