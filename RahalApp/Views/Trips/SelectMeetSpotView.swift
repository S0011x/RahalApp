//
//  SelectMeetSpotView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI
import MapKit

struct SelectMeetSpotView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var pickupLocation: CLLocationCoordinate2D
    
    @State var dropOffLocation: CLLocationCoordinate2D
    
    
    
                                                      
    
    var body: some View {
        ZStack{
            
            MyMapView(requestLocation: $pickupLocation, destinationLocation: $dropOffLocation).edgesIgnoringSafeArea(.all)
            
            
            VStack{
                
                VStack{
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(systemName: "chevron.backward").padding()
                            .frame(width: 350,height: 40 ,alignment: .leading)
                    }
                    
                    
                    ZStack{
                        Color(.whiteA700)
                        VStack{
                            Text("نقاط الالتقاء").frame(width: 300 ,alignment: .trailing)
                        }
                    }.frame(width: 340,height:40 ,alignment: .trailing)
                        .cornerRadius(8)
                    
                    Spacer()
                    NavigationLink(destination: PrepardLocationView( pickupLocation: pickupLocation, dropOffLocation: dropOffLocation )) {
                        ButtonWidget(text: "التالي")
                    }
                }
            }
        }.hideNavigationBar()
    }
}
#Preview {
    SelectMeetSpotView(pickupLocation:  CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501), dropOffLocation: CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701))
}
