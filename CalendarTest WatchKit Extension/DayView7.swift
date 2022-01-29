//
//  DayView7.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView7: View {
    var body: some View {
        ScrollView{
        Text("14:30 - 15:15:")
        Text("Spanish (G)")
        
                        
        NavigationLink(destination: DayView6()){
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

struct DayView7_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayView7()
        }
    }
}
