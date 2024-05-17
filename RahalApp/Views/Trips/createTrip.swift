//
//  createTrip.swift
//  RahalApp
//
//  Created by Juman Dhaher on 23/10/1445 AH.
//

import SwiftUI


struct CreateTrip: View {
    @State private var name = ""
    @State private var details = ""
    @State private var number = ""
    @State private var easy = false
    @State private var medium = true
    @State private var hard = false
    
    @State private var startDate = Date.now
    @State private var endDate = Date.now

//test
    var body: some View {
        ScrollView{
            VStack(alignment:.trailing ){
                TripNameView
                Spacer(minLength: 20)
                detailsView
                Spacer(minLength: 20)
                tripLevelView
                Spacer(minLength: 30)
                startTrip
                Spacer(minLength: 20)
                endTrip
                Spacer(minLength: 20)
                NumberView
                Spacer(minLength: 30)
                NavigationLink(destination: SelectDestinationView()) {
                    ButtonWidget(text: "التالي")
                }
            }
        }
        .frame(width: 1000)
        .background(Color("background"))
        .navigationTitle("معلومات الرحلة")
    }
}

#Preview {
    CreateTrip()
}


extension CreateTrip {
    
    private var TripNameView: some View{
        
        VStack(alignment: .trailing){
            Text("اسم الرحلة")
            TextField("", text: $name)
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                             Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
    private var detailsView: some View {
        VStack(alignment: .trailing){
            Text("شرح تفاصيل الرحلة")
            ZStack {
                TextEditor(text: $details)
                    .textEditorStyle(.plain)
                    .padding()
            }.overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("WhiteA700"))
            ).frame(width: 300, height: 150)
                .background(Color("WhiteA700"))
        }
    }
    
    private var tripLevelView: some View {
        VStack(alignment: .trailing){
            Text("مستوى صعوبة الرحلة")
            HStack(spacing: 50){
                if(easy){
                    Button {
                        easy = !easy
                        medium = false
                        hard = false
                    } label: {
                        Text("سهل").frame(
                            width:80
                        ).background(.white)
                    }.foregroundColor(.black)
              
                }else{
                    Button {
                        easy = !easy
                        medium = false
                        hard = false
                    } label: {
                        Text("سهل")
                    }.foregroundColor(.black)
                }
              
                if(medium){
                    Button {
                        easy = false
                        medium = !medium
                        hard = false
                    } label: {
                        Text("متوسط").frame(
                            width:80
                            ).background(.white)
                    }.foregroundColor(.black)
                      
                }else{
                    Button {
                        easy = false
                        medium = !medium
                        hard = false
                    } label: {
                        Text("متوسط")
                    }.foregroundColor(.black)
                }
                
                if(hard){
                    Button {
                        easy = false
                        medium = false
                        hard = !hard
                    } label: {
                        Text("صعب")
                            .frame(
                            width:80
                            ).background(.white)
                    }.foregroundColor(.black)
                }else{
                    Button {
                        easy = false
                        medium = false
                        hard = !hard
                    } label: {
                        Text("صعب")
                    }.foregroundColor(.black)
                }
            }
            .frame(width: 300, height: 30)
            .background(.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                         .gray.opacity(0.3), lineWidth: 1))
            
        }
    }
    
    private var startTrip: some View {
        VStack(alignment: .trailing){
            Text("بداية الرحلة")
            HStack{
                DatePicker("", selection: $startDate, in: Date.now...)    .labelsHidden().frame(
                    width: 300,
                    alignment:.center)
            }
        }
    }
    
    private var endTrip: some View {
        VStack(alignment: .trailing){
            Text("نهاية الرحلة")
            HStack{
                DatePicker("", selection: $endDate, in: Date.now...)    .labelsHidden().frame(
                    width: 300,
                    alignment:.center)
            }
        }
    }
    
    private var NumberView: some View{
        
        VStack(alignment: .trailing){
            Text("رقم الهاتف للتواصل")
            TextField("", text: $number)
                .keyboardType(.numberPad)
                .frame(width: 300, height: 35)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35)
            )
        }
    }
    
}
