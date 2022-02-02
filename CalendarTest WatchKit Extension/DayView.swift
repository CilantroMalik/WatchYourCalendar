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
                         if globalOffset == 0 {
                         if isNextBlock(bl: 0){
                             Text(classes[cycleDay]![0]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 0){
                             Text(classes[cycleDay]![0]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text(classes[cycleDay]![0]).foregroundColor(.blue).fontWeight(.light)}
                         }
                         // TODO propagate logic
                     Spacer()
                     Text("10:00 - 10:30:").fontWeight(.bold)
                     if globalOffset == 0 {
                     if isNextBlock(bl: 1){
                         Text(getMorningActivity()).foregroundColor(.green).fontWeight(.medium)
                     } else if nowIsBeforeBlockBegins(block: 1) {
                         Text(getMorningActivity()).foregroundColor(.red).fontWeight(.medium)}
                     else {
                         Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                     } else {
                         Text(getMorningActivity()).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     }
                     Group{
                     Text("10:35 - 11:20:").fontWeight(.bold)
                         if globalOffset == 0 {
                         if isNextBlock(bl: 2){
                             Text(classes[cycleDay]![1]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 2){
                             Text(classes[cycleDay]![1]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text(classes[cycleDay]![1]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Text("11:25 - 12:25:").fontWeight(.bold)
                             if globalOffset == 0 {
                         if isNextBlock(bl: 3){
                             Text(classes[cycleDay]![2]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 3){
                             Text(classes[cycleDay]![2]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                             } else {
                                 Text(classes[cycleDay]![2]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Spacer()
                     }
                     Group{
                     Text("12:25 - 13:15:").fontWeight(.bold)
                         if globalOffset == 0 {
                         if isNextBlock(bl: 4){
                             Text("Lunch").foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 4){
                             Text("Lunch").foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                         } else {
                             Text("Lunch").foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Spacer()
                     }
                     Group{
                     Text("13:20 - 14:20:").fontWeight(.bold)
                         if globalOffset == 0 {
                         if isNextBlock(bl: 5){
                             Text(classes[cycleDay]![3]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 5){
                             Text(classes[cycleDay]![3]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                         }else {
                             Text(classes[cycleDay]![3]).foregroundColor(.blue).fontWeight(.light)}
                     Spacer()
                     Text("14:30 - 15:15:").fontWeight(.bold)
                             if globalOffset == 0 {
                         if isNextBlock(bl: 6){
                             Text(classes[cycleDay]![4]).foregroundColor(.green).fontWeight(.medium)
                         } else if nowIsBeforeBlockBegins(block: 6){
                             Text(classes[cycleDay]![4]).foregroundColor(.red).fontWeight(.medium)}
                         else {
                             Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                             }else {
                                 Text(classes[cycleDay]![4]).foregroundColor(.blue).fontWeight(.light)}
                         if (isSports()){
                             Text("15:20 - 16:10:").fontWeight(.bold)
                             if globalOffset == 0 {
                             if isNextBlock(bl: 7){
                                 Text("Fitness Center").foregroundColor(.green).fontWeight(.medium)
                             } else if nowIsBeforeBlockBegins(block: 7){
                                 Text("Fitness Center").foregroundColor(.red).fontWeight(.medium)}
                             else {
                                 Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
                             }else {
                                 Text("Fitness Center").foregroundColor(.blue).fontWeight(.light)}
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
