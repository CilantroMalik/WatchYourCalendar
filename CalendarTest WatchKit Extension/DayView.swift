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
                         Text(getCycleDayDay()).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                         
                         if globalOffset == 0 {
                         if isNextBlock(bl: 0){
                             Text("08:55 - 09:55:").fontWeight(.bold).foregroundColor(.mint)
                             Text(classes[cycleDay]![0]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 0){
                             Text("08:55 - 09:55:").fontWeight(.bold)
                             Text(classes[cycleDay]![0]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("08:55 - 09:55:").fontWeight(.medium).foregroundColor(.gray)
                             Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text("08:55 - 09:55:").fontWeight(.bold)
                             Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                         }
                     Spacer()
                     if globalOffset == 0 {
                     if isNextBlock(bl: 1){
                         Text("10:00 - 10:30:").fontWeight(.bold).foregroundColor(.mint)
                         Text(getMorningActivity()).foregroundColor(.green).fontWeight(.medium)
                     } else if nowIsBeforeBlockBegins(block: 1) {
                         Text("10:00 - 10:30:").fontWeight(.bold)
                         Text(getMorningActivity()).foregroundColor(.red).fontWeight(.medium)}
                     else {
                         Text("10:00 - 10:30:").fontWeight(.medium).foregroundColor(.gray)
                         Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                     } else {
                         Text("10:00 - 10:30:").fontWeight(.bold)
                         Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Group{
                   
                         if globalOffset == 0 {
                         if isNextBlock(bl: 2){
                             Text("10:35 - 11:20:").fontWeight(.bold).foregroundColor(.mint)
                             Text(classes[cycleDay]![1]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 2){
                             Text("10:35 - 11:20:").fontWeight(.bold)
                             Text(classes[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("10:35 - 11:20:").fontWeight(.medium).foregroundColor(.gray)
                             Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text("10:35 - 11:20:").fontWeight(.bold)
                             Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                             if globalOffset == 0 {
                         if isNextBlock(bl: 3){
                             Text("11:25 - 12:25:").fontWeight(.bold).foregroundColor(.mint)
                             Text(classes[cycleDay]![2]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 3){
                             Text("11:25 - 12:25:").fontWeight(.bold)
                             Text(classes[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("11:25 - 12:25:").fontWeight(.medium).foregroundColor(.gray)
                             Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                             } else {
                            Text("11:25 - 12:25:").fontWeight(.bold)
                            Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Spacer()
                     }
                     Group{
                     
                         if globalOffset == 0 {
                         if isNextBlock(bl: 4){
                             Text("12:25 - 13:15:").fontWeight(.bold).foregroundColor(.mint)
                             Text("Lunch").foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 4){
                             Text("12:25 - 13:15:").fontWeight(.bold)
                             Text("Lunch").foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("12:25 - 13:15:").fontWeight(.medium).foregroundColor(.gray)
                             Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text("12:25 - 13:15:").fontWeight(.bold)
                             Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Spacer()
                     }
                     Group{
                     
                         if globalOffset == 0 {
                         if isNextBlock(bl: 5){
                             Text("13:20 - 14:20:").fontWeight(.bold).foregroundColor(.mint)
                             Text(classes[cycleDay]![3]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 5){
                             Text("13:20 - 14:20:").fontWeight(.bold)
                             Text(classes[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("13:20 - 14:20:").fontWeight(.medium).foregroundColor(.gray)
                             Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                         }else {
                             Text("13:20 - 14:20:").fontWeight(.bold)
                             Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     
                             if globalOffset == 0 {
                         if isNextBlock(bl: 6){
                             Text("14:30 - 15:15:").fontWeight(.bold).foregroundColor(.mint)
                             Text(classes[cycleDay]![4]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 6){
                             Text("14:30 - 15:15:").fontWeight(.bold)
                             Text(classes[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("14:30 - 15:15:").fontWeight(.medium).foregroundColor(.gray)
                             Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                             }else {
                                 Text("14:30 - 15:15:").fontWeight(.bold)
                                 Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                         if (isSports()){
                             if globalOffset == 0 {
                             if isNextBlock(bl: 7){
                                 Text("15:20 - 16:10:").fontWeight(.bold).foregroundColor(.mint)
                                 Text("Fitness Center").foregroundColor(.green).fontWeight(.medium)
                             } else if nowIsBeforeBlockBegins(block: 7){
                                 Text("15:20 - 16:10:").fontWeight(.bold)
                                 Text("Fitness Center").foregroundColor(.red).fontWeight(.medium)}
                             else {
                                 Text("15:20 - 16:10:").fontWeight(.medium).foregroundColor(.gray)
                                 Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
                             }else {
                                 Text("15:20 - 16:10:").fontWeight(.bold)
                                 Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
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
