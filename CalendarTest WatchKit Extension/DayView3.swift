//
//  DayView3.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView3: View {
    var body: some View {
        ScrollView{
        Text("10:35 - 11:20:")
        Text("Physics (D)")
        
            Text("Quiz!")
        Spacer()
                        
        NavigationLink(destination: DayView4()){
                Text("Next")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView2()){
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

struct DayView3_Previews: PreviewProvider {
    static var previews: some View {
        DayView3()
        
    }
}
