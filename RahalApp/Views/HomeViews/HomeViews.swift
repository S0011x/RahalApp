import SwiftUI
import MapKit
import AuthenticationServices

struct HomeViews: View {
    //Home
    @StateObject var viewModel = HomeViewsModel()

    @State private var showingAlert = false
    @State private var code = ""
    
    
    @State private var isShowingAlert = false
    @State private var isShowingAlert2 = false
    @State private var navigateToSelectDestinationView = false
    
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        @State  var isSigninigIn = loginViewModel.isSigninigIn
//        Text("\(isSigninigIn)")
        
        NavigationStack{
            VStack {
                ZStack{
                    
                    Map(coordinateRegion: viewModel.binding,showsUserLocation: true,userTrackingMode: .constant(.follow))
                                    .edgesIgnoringSafeArea(.all)
                                    .onAppear(perform: {
                                        viewModel.checkIfLocationIsEnabled()
                     })

                    
                    VStack() {
                        HStack(alignment:.top) {
                            ZStack{
                                Color(.whiteA700)
                                VStack {
                                    NavigationLink(
                                        destination: isSigninigIn ? AnyView(UserInformationView()) : AnyView(LoginView()),
                                        label: {
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                                       alignment: .center)
                                                .foregroundColor(ColorConstants.IconColor)
                                                .scaledToFit()
                                                .clipped()
                                                .padding(.top, getRelativeHeight(4.0))
                                        
                                    })
                                    
                                    NavigationLink(destination: NotificationView() , label: {
                                        
                                        Image(systemName: "bell.fill")
                                            .resizable()
                                            .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                                   alignment: .center)
                                            .foregroundColor(ColorConstants.IconColor)
                                            .scaledToFit()
                                            .clipped()
                                            .padding(.top, getRelativeHeight(4.0))
                                    })
                                    
                                }
                                //                            .padding(.top, 80)
                            }    .frame(width:50,height: 110)
                                .cornerRadius(12)
                                .padding(.top, 60)
                                .padding(.leading, 280)
                        }
                        
                        Spacer()
                        
                        
                        ZStack {
                            Rectangle()
                            
                                .foregroundColor(.whiteA700)
                                .frame(width: 400, height: 180)
                                .cornerRadius(35)
                                .padding(.top, 500)
                            VStack {
                                Spacer(minLength: 0)
                                NavigationLink(destination: {
                                    if( viewModel.checkLocationAuthorizationBool()){
                                        CreateTripCRUD()
//                                        CreateTrip()
                                    }else{
                                        VStack(alignment: .center){
                                            Text("يجب السماح للوصول إلى موقعك")
                                        }
                                    }
                                }, label: {
                                    ButtonWidget(text:StringConstants.kLbl )
                                } )
                                
                                NavigationLink(destination: CreateTripCRUD()) {
                                    
                                    Button(action: {
                                        isShowingAlert = true
    //                                    navigateToSelectDestinationView = true
                                    },
                                           label: {
                                        ButtonWidget(text: "انضم إلى رحلة" )
                                    })
                                    .alert("ادخل كود الرحلة",isPresented: $isShowingAlert)
                                    {
                                        
                                        
                                                  TextField("757687", text: $code)
                                                  Button("إلغاء", action: submit)
                                                 
                                                      Button("انضمام", action: {
                                                          if(code == "333" ){
                                                              navigateToSelectDestinationView = true
                                                          } else {
                                                              
                                                              isShowingAlert = false
                                                              isShowingAlert2 = true
                                                              
                                                          }
                                                          
                                                      })
                                        
                                    }  message: {
                                            Text("")
                                    }
                                    
                                }
                                
                                .alert(isPresented: $isShowingAlert2) {
                                    Alert(
                                      title: Text("لا يوجد رحلة بالكود المدخل"),
                                      dismissButton: .default(Text("حاول مجددًا"), action: {
                                          isShowingAlert = true
                                      }))
                                }
                                
                              
                                .navigationDestination(isPresented: $navigateToSelectDestinationView) {
                                    MembersMapView(pickupLocation:  CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501), dropOffLocation: CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701), meetSpots: [ CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)])

                                }
                            
                                
                            }.padding(.bottom, 60)
                        }
                        
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

//check Signing in
//func checkAppleSignInStatus() -> Bool {
//    let appleIDProvider = ASAuthorizationAppleIDProvider()
//    let appleIDCredential = appleIDProvider.getCredentialState(forUserID: "userIdentifier")
//    
//    switch appleIDCredential {
//    case .authorized:
//        // User is authorized (signed in) with Apple ID
//        return true
//    case .revoked, .notFound:
//        // User is either revoked the authorization or not signed in with Apple ID
//        return false
//    default:
//        // Unknown state
//        return false
//    }
//}

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
