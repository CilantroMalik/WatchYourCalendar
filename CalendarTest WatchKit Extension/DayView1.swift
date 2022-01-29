//
//  DayView1.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import SwiftUI

struct DayView1: View {
    var body: some View {
       
        ScrollView{
        VStack{
        Text("08:55 - 09:55:")
        Text("Comp. Sci. (C)")
        
        NavigationLink(destination: DayView2()){
                Text("Next")
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

struct DayView1_Previews: PreviewProvider {
    static var previews: some View {
        DayView1()
            

            
    }
}
