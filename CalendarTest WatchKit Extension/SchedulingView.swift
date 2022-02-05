//
//  SchedulingView.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 2/5/22.
//

import SwiftUI

//func hasAssessment(block: Int) -> Bool {
//    return false
//}
func meetingOrAssessment() -> String{
    return isClass() ? "Assessment" : "Meeting"
}
func getAssessmentBlock() -> Int{
    return 0//fix
}
func isClass() -> Bool{ //isClass or free
    true
}
@State var hasAs: [Int: [Bool]] = [
    0: [false, false, false, false, false, false, false],//5 blocks + clubs and lunch
    1: [false, false, false, false, false, false, false],
    2: [false, false, false, false, false, false, false],
    3: [false, false, false, false, false, false, false],
    4: [false, false, false, false, false, false, false],
    5: [false, false, false, false, false, false, false],
    6: [false, false, false, false, false, false, false],
    7: [false, false, false, false, false, false, false],
    8: [false, false, false, false, false, false, false]
]
struct SchedulingView: View {
    var body: some View {
        VStack{
            var block = 0 //the block number: how would we retrieve it?
        Text("Scheduler").font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
            Toggle(meetingOrAssessment(), isOn: $hasAs[cycleDay]![block])
            if hasAs() {
                hasAs[cycleDay]![block] = true
            } else {
                hasAs[cycleDay]![block] = false
            }
        }
    }
}

struct SchedulingView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulingView()
    }
}
