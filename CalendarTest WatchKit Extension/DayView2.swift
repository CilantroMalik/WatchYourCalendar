//
//  DayView1.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView2: View {
    var body: some View {
        ScrollView{
        VStack{
            Text("10:00 - 10:30:")
            Text("Class Meeting")
        
        Spacer()
                        
        NavigationLink(destination: DayView3()){
                Text("Next")
                    .fontWeight(.heavy)
                        }
        NavigationLink(destination: DayView1()){
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
}

struct DayView2_Previews: PreviewProvider {
    static var previews: some View {
        DayView1()
        
    }
}
