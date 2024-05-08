//
//  SavedTripsView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI

struct SavedTripsView: View {
    var body: some View {
        ZStack{
            Color(.background)
            ScrollView{

            VStack(alignment:.trailing){
                Spacer(minLength: 100)
                tripWidget(time:"11/03/2024",name:"رحلة الاردن")
                Spacer(minLength: 15)
                tripWidget(time:"11/03/2024",name:"رحلة الاردن")
                Spacer(minLength: 15)
                tripWidget(time:"11/03/2024",name:"رحلة الاردن")
                
                
            }.frame(alignment:.top)
        }
    }.navigationTitle("الرحلات المحفوظة").ignoresSafeArea()
    
}
    
    func tripWidget(time:String,name:String) -> some View{
        return ZStack{
            Color(.white)
            HStack{
                HStack{
                    Image(systemName: "chevron.backward").foregroundColor(.gray)
                    Text("اعادة انشاء")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment:.trailing){
                    Text(name)
                    Text(time)
                        .foregroundColor(.gray)
                }
            }.padding(.horizontal,20)
                .padding(.vertical, 10)
        }.frame(width:350, height: 50).cornerRadius(12)
    }
}

#Preview {
    SavedTripsView()
}
