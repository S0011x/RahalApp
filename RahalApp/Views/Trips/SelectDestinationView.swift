//
//  SelectDestinationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI
import MapKit

struct SelectDestinationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var mapDataPickUp = MapViewModel()
    @StateObject var mapDataDestenation = MapViewModel()
    @State var pickupText = ""
    @State var destenationText = ""
    // Location Manager....
    @State var locationManager = CLLocationManager()

    
    @State var pickupLocation =  CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State var dropOffLocation  = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    

    var body: some View {
        ZStack{
            // MapView...
            if(mapDataPickUp.searchTxt == "" && mapDataDestenation.searchTxt == ""  ){
                MapViewForSearch()
                // using it as environment object so that it can be used ints subViews....
                    .environmentObject(mapDataPickUp)
                    .ignoresSafeArea(.all, edges: .all)
            }
            
            if(pickupLocation.latitude != 0 && dropOffLocation.latitude != 0 && pickupLocation.longitude != 0 && dropOffLocation.longitude != 0  ){
                MapView(pickupLocation: $pickupLocation , dropOffLocation: $dropOffLocation).edgesIgnoringSafeArea(.all)
                }
            
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
                        ZStack{
                            if(mapDataPickUp.searchTxt == "" && pickupText == ""){
                                Text( "موقع الانطلاق")
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 300 ,alignment: .trailing)
                                
                            }else if(mapDataPickUp.searchTxt == "" && pickupText != "" ){
                                Text(pickupText)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 300 ,alignment: .trailing)
                            }
                            TextField("" , text: $mapDataPickUp.searchTxt)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 300 ,alignment: .trailing)
                        }
                        Divider()
                        ZStack{
                            if(mapDataDestenation.searchTxt == "" && destenationText == "" ){
                                Text("موقع الوصول")
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 300 ,alignment: .trailing)
                            }else if(mapDataDestenation.searchTxt == "" && destenationText != "" ){
                                Text(destenationText)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 300 ,alignment: .trailing)
                            }
                            TextField("" , text: $mapDataDestenation.searchTxt)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 300 ,alignment: .trailing)
                        }
                    }
                }.frame(width: 340,height:80 ,alignment: .trailing)
                    .cornerRadius(8)
                
                // Displaying Results for pickup...
                
                if !mapDataPickUp.places.isEmpty && mapDataPickUp.searchTxt != ""{
                    
                    ScrollView{
                        
                        VStack(spacing: 15){
                            
                            ForEach(mapDataPickUp.places){place in
                                
                                Text(place.placemark.name ?? "")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .padding(.leading)
                                    .onTapGesture{
                                        pickupText = place.placemark.name ?? ""
                                        mapDataPickUp.selectPlace(place: place)
                                        
                                        pickupLocation =  CLLocationCoordinate2D(latitude: mapDataPickUp.mapView.region.center.latitude, longitude: mapDataPickUp.mapView.region.center.longitude)
                                        
                                        print(pickupLocation)

                                  
                                    }
                                
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                    .background(Color.white)
                }
                
                
                // Displaying Results for destenation...
                
                if !mapDataDestenation.places.isEmpty && mapDataDestenation.searchTxt != ""{
                    
                    ScrollView{
                        
                        VStack(spacing: 15){
                            
                            ForEach(mapDataDestenation.places){place in
                                
                                Text(place.placemark.name ?? "")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .padding(.leading)
                                    .onTapGesture{
                                        
                                        mapDataDestenation.selectPlace(place: place)
                                        destenationText = place.placemark.name ?? ""

                                        if let lat = place.placemark.location?.coordinate.latitude, let long = place.placemark.location?.coordinate.longitude {
                                            dropOffLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                        }
                                        
                                        print(dropOffLocation)
                                    }
                                
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                    .background(Color.white)
                }
                
                
                Spacer()
                NavigationLink(destination: SelectMeetSpotView(
         pickupLocation: pickupLocation, dropOffLocation: dropOffLocation)) {
                    ButtonWidget(text: "التالي")
                }
            }
        }
        .hideNavigationBar()
        .onAppear(perform: {
            // Setting Delegate...
            locationManager.delegate = mapDataPickUp
            locationManager.delegate = mapDataDestenation
            locationManager.requestWhenInUseAuthorization()
            
        })
        // Permission Denied Alert...
        .alert(isPresented: $mapDataPickUp.permissionDenied, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                
                // Redireting User To Settings...
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapDataPickUp.searchTxt, perform: { value in
            
            // Searching Places...
            
            // You can use your own delay time to avoid Continous Search Request...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if value == mapDataPickUp.searchTxt{
                    
                    // Search...
                    self.mapDataPickUp.searchQuery()
                }
            }
        })
        .onChange(of: mapDataDestenation.searchTxt, perform: { value in
        
        // Searching Places...
        
        // You can use your own delay time to avoid Continous Search Request...
        let delay = 0.3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            if value == mapDataDestenation.searchTxt{
                
                // Search...
                self.mapDataDestenation.searchQuery()
            }
        }
    })
}
}

#Preview {
    SelectDestinationView()
}
