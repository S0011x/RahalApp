//
//  NotificationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ZStack{
            Color(.background)
            ScrollView{

            VStack(alignment:.trailing){
                Spacer(minLength: 100)
                
                notifyWidget(time:"9:41 AM",name:"جمان",des: "احتاج ماء")
                Spacer(minLength: 15)
                notifyWidget(time:"9:41 AM",name:"جمان",des: "احتاج ماء")
                Spacer(minLength: 15)
                notifyWidget(time:"9:41 AM",name:"جمان",des: "احتاج ماء")
                
                
            }.frame(alignment:.top)
        }
    }.navigationTitle("الاشعارات").ignoresSafeArea()
    
    }
    
    func notifyWidget(time:String,name:String,des:String) -> some View{
        return ZStack{
            Color(.whiteA700)
            HStack{
                Text(time)
                Spacer()
                VStack(alignment:.trailing){
                    Text(name)
                    Text(des)
                }
            }.padding(.horizontal,20)
                .padding(.vertical, 10)
        }.frame(width:350, height: 50).cornerRadius(12)
    }
}

#Preview {
    NotificationView()
}
