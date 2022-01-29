//
//  DayView4.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView4: View {
    var body: some View {
        ScrollView{
        Text("11:25 - 12:25:")
        Text("Latin (F)")
        
        Spacer()
                        
        NavigationLink(destination: DayView5()){
                Text("Next")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView3()){
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

struct DayView4_Previews: PreviewProvider {
    static var previews: some View {
        DayView4()
            .padding(.top, 3.0)
    }
}
