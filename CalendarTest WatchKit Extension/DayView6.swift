//
//  DayView6.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView6: View {
    var body: some View {
        ScrollView{
        Text("13:20 - 14:20:")
        Text("English (E)")
        
        Spacer()
                        
        NavigationLink(destination: DayView7()){
                Text("Next")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView5()){
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

struct DayView6_Previews: PreviewProvider {
    static var previews: some View {
        DayView6()
    }
}
