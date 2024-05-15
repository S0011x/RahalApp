import SwiftUI
import MapKit

struct HomeViews: View {
    //Home
    @StateObject var viewModel = HomeViewsModel()
    @State private var showingAlert = false
      @State private var code = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack{
                    
                    Map(coordinateRegion: viewModel.binding,showsUserLocation: true,userTrackingMode: .constant(.follow))
                                    .edgesIgnoringSafeArea(.all)
                                    .onAppear(perform: {
                                        viewModel.checkIfLocationIsEnabled()
                     })

                    
                    VStack(alignment: .trailing, spacing: 0) {
                        VStack {
                            NavigationLink(destination: RegisterView(), label: {
                                Image("img_person_circle_1")
                                    .resizable()
                                    .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                           alignment: .center)
                                    .scaledToFit()
                                    .clipped()
                                    .padding(.top, getRelativeHeight(4.0))
                            })
                            
                            NavigationLink(destination: NotificationView() , label: {
                                Image("img_group_22")
                            })
                            
                        }.padding(.top, 80)
                        
                        
                        
                        VStack {
                            Spacer(minLength: 0)
                            NavigationLink(destination: {
                                if( viewModel.checkLocationAuthorizationBool()){
                                    CreateTrip()
                                }else{
                                    VStack(alignment: .center){
                                        Text("يجب السماح للوصول إلى موقعك")
                                    }
                                }
                            }, label: {
                                ButtonWidget(text:StringConstants.kLbl )
                            } )
                            
                            NavigationLink(destination: CreateTrip(), label: {
                                Button(action: {
                                    showingAlert.toggle()
                                }, label: {
                                    ButtonWidget(text: "انضم إلى رحلة" )
                                })
                                        .alert("ادخل الكود المرسل", isPresented: $showingAlert) {
                                            TextField("", text: $code)
                                            Button("اغلاق", action: submit)
                                            if(code == ""){
                                                Button("حسنا", action: submit)
                                            }else{
                                                NavigationLink(destination: PrepardLocationView(pickupLocation: CLLocationCoordinate2D(latitude: 24.8613, longitude: 46.7255), dropOffLocation: CLLocationCoordinate2D(latitude: 24.8414, longitude: 46.7333),meetSpots: [] )) {
                                                    Text("حسنا").foregroundColor(.blue)
                                                }
                                            }
                                           
                                           
                                        } message: {
                                            Text("")
                                        }
                            })
                            
                        }.padding(.bottom, 50)
                        
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(ColorConstants.Gray100)
                .hideNavigationBar()
            }
        }
    }
    
    func submit() {
            print("You entered \(code)")
    }
}

struct HomeViews_Previews: PreviewProvider {
    static var previews: some View {
        HomeViews()
    }
}


final class HomeViewsModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var binding: Binding<MKCoordinateRegion> {
        Binding {
            self.mapRegion
        } set: { newRegion in
            self.mapRegion = newRegion
        }
    }
    
    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know this is off")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let previousAuthorizationStatus = manager.authorizationStatus
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus != previousAuthorizationStatus {
            checkLocationAuthorization()
        }
    }
    
    private func checkLocationAuthorization() {
        guard let location = locationManager else {
            return
        }
        
        switch location.authorizationStatus {
        case .notDetermined:
            print("Location authorization is not determined.")
        case .restricted:
            print("Location is restricted.")
        case .denied:
            print("Location permission denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = location.location {
                mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }
            
        default:
            break
        }
    }
    
    func checkLocationAuthorizationBool() -> Bool {
        guard let location = locationManager else {
            return false
        }
        
        switch location.authorizationStatus {
        case .notDetermined:
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
            
        default:
            break
        }
        return false
    }
}
