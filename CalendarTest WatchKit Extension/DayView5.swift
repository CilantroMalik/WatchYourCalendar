//
//  DayView5.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView5: View {
    var body: some View {
        ScrollView{
        Text("12:25 - 13:15:")
        Text("Lunch")
        Text("12:25 - 13:15:")
        Text("Meeting with Dr. Levey")
        
        Spacer()
                        
        NavigationLink(destination: DayView6()){
                Text("Next")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView4()){
                Text("Previous")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView()){
                Text("Day View")
                    .fontWeight(.heavy)
                        }
    }
    }
}

struct DayView5_Previews: PreviewProvider {
    static var previews: some View {
        DayView5()
    }
}
