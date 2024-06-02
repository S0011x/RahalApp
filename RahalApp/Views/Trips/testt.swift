////
////  testt.swift
////  Masier
////
////  Created by suha alrajhi on 19/11/1445 AH.
////
//
//import SwiftUI
//import MapKit
//import AuthenticationServices
//import CloudKit
//
//struct test: View {
//    @StateObject var viewModel = HomeViewsModel1()
//    @State private var showingAlert = false
//    @State private var code = ""
//    @State private var isShowingAlert = false
//    @State private var isShowingAlert2 = false
//    @ObservedObject var loginViewModel = LoginViewModel()
//    @StateObject var vmm = LoginViewModel()
//    
//    var body: some View {
//        @State  var isSigninigIn = loginViewModel.isSigninigIn
//        
//        NavigationStack {
//            VStack {
//                ZStack {
//                    Map(coordinateRegion: viewModel.binding, showsUserLocation: true, userTrackingMode: .constant(.follow))
//                        .edgesIgnoringSafeArea(.all)
//                        .onAppear {
//                            viewModel.checkIfLocationIsEnabled()
//                        }
//                    
//                    VStack {
//                        HStack(alignment: .top) {
//                            ZStack {
//                                Color(.white)
//                                VStack {
//                                    NavigationLink(
//                                        destination: isSigninigIn ? AnyView(UserInformationView()) : AnyView(LoginView()),
//                                        label: {
//                                            Image(systemName: "person.crop.circle")
//                                                .resizable()
//                                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0), alignment: .center)
//                                                .foregroundColor(.blue)
//                                                .scaledToFit()
//                                                .clipped()
//                                                .padding(.top, getRelativeHeight(4.0))
//                                        })
//                                    
//                                    NavigationLink(destination: NotificationView()) {
//                                        Image(systemName: "bell.fill")
//                                            .resizable()
//                                            .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0), alignment: .center)
//                                            .foregroundColor(.blue)
//                                            .scaledToFit()
//                                            .clipped()
//                                            .padding(.top, getRelativeHeight(4.0))
//                                    }
//                                }
//                            }
//                            .frame(width: 50, height: 110)
//                            .cornerRadius(12)
//                            .padding(.top, 60)
//                            .padding(.leading, 280)
//                        }
//                        
//                        Spacer()
//                        
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(.white)
//                                .frame(width: 400, height: 180)
//                                .cornerRadius(35)
//                                .padding(.top, 500)
//                            VStack {
//                                Spacer(minLength: 0)
//                                NavigationLink(destination: {
//                                    if viewModel.checkLocationAuthorizationBool() {
//                                        CreateTripCRUD()
//                                    } else {
//                                        VStack(alignment: .center) {
//                                            Text("يجب السماح للوصول إلى موقعك")
//                                        }
//                                    }
//                                }, label: {
//                                    ButtonWidget(text: "إنشاء رحلة")
//                                })
//                                
//                                NavigationLink(destination: CreateTripCRUD()) {
//                                    Button(action: {
//                                        isShowingAlert = true
//                                    }, label: {
//                                        ButtonWidget(text: "انضم إلى رحلة")
//                                    })
//                                    .alert("ادخل كود الرحلة", isPresented: $isShowingAlert) {
//                                        TextField("", text: $code)
//                                        Button("إلغاء", action: submit)
//                                        Button("انضمام", action: {
//                                            let currentUserRecordID = CKRecord.ID(recordName: "currentUserRecord")
//                                            viewModel.joinTrip(withCode: code, currentUserRecordID: currentUserRecordID)
//                                        })
//                                    } message: {
//                                        Text("")
//                                    }
//                                }
//                                .alert(isPresented: $isShowingAlert2) {
//                                    Alert(
//                                        title: Text("لا يوجد رحلة بالكود المدخل"),
//                                        dismissButton: .default(Text("حاول مجددًا"), action: {
//                                            isShowingAlert = true
//                                        }))
//                                }
//                                
//                                .navigationDestination(isPresented: $viewModel.navigateToTripView) {
//                                                                    if let trip = viewModel.trip {
//                                                                        MembersMapView(
//                                                                            pickupLocation: trip.pickupLocation,
//                                                                            dropOffLocation: trip.dropOffLocation,
//                                                                            meetSpots: trip.meetSpots
//                                                                        )
//                                                                    }
//                                }
//                            }
//                            .padding(.bottom, 60)
//                        }
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .background(Color.gray)
//                .hideNavigationBar()
//            }
//        }
//    }
//    
//    func submit() {
//        print("You entered \(code)")
//    }
//}
//
//struct test_Previews: PreviewProvider {
//    static var previews: some View {
//        test()
//    }
//}
//
//
////check Signing in
////func checkAppleSignInStatus() -> Bool {
////    let appleIDProvider = ASAuthorizationAppleIDProvider()
////    let appleIDCredential = appleIDProvider.getCredentialState(forUserID: "userIdentifier")
////
////    switch appleIDCredential {
////    case .authorized:
////        // User is authorized (signed in) with Apple ID
////        return true
////    case .revoked, .notFound:
////        // User is either revoked the authorization or not signed in with Apple ID
////        return false
////    default:
////        // Unknown state
////        return false
////    }
////}
//
//final class HomeViewsModel1: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    @Published var trip: CreateTrip1? = nil
//    @Published var code = ""
//    @Published var statusMessage = ""
//    @Published var showAlert = false
//    @Published var navigateToTripView = false
//    
//    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//    
//    var binding: Binding<MKCoordinateRegion> {
//        Binding {
//            self.mapRegion
//        } set: { newRegion in
//            self.mapRegion = newRegion
//        }
//    }
//    
//    func checkIfLocationIsEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager!.delegate = self
//        } else {
//            print("Show an alert letting them know this is off")
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        let previousAuthorizationStatus = manager.authorizationStatus
//        manager.requestWhenInUseAuthorization()
//        if manager.authorizationStatus != previousAuthorizationStatus {
//            checkLocationAuthorization()
//        }
//    }
//    
//    private func checkLocationAuthorization() {
//        guard let location = locationManager else {
//            return
//        }
//        
//        switch location.authorizationStatus {
//        case .notDetermined:
//            print("Location authorization is not determined.")
//        case .restricted:
//            print("Location is restricted.")
//        case .denied:
//            print("Location permission denied.")
//        case .authorizedAlways, .authorizedWhenInUse:
//            if let location = location.location {
//                mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//            }
//            
//        default:
//            break
//        }
//    }
//    
//    func checkLocationAuthorizationBool() -> Bool {
//        guard let location = locationManager else {
//            return false
//        }
//        
//        switch location.authorizationStatus {
//        case .notDetermined, .restricted, .denied:
//            return false
//        case .authorizedAlways, .authorizedWhenInUse:
//            return true
//            
//        default:
//            return false
//        }
//    }
//    
//    func joinTrip(withCode code: String, currentUserRecordID: CKRecord.ID) {
//        let predicate = NSPredicate(format: "code == %@", code)
//        let query = CKQuery(recordType: "Trips", predicate: predicate)
//
//        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.statusMessage = "Error: \(error.localizedDescription)"
//                    self.showAlert = true
//                }
//                return
//            }
//
//            guard let tripRecord = records?.first else {
//                DispatchQueue.main.async {
//                    self.statusMessage = "No trip found with the provided code."
//                    self.showAlert = true
//                }
//                return
//            }
//
//            self.updateTripMembers(tripRecord: tripRecord, currentUserRecordID: currentUserRecordID)
//        }
//    }
//
//    func updateTripMembers(tripRecord: CKRecord, currentUserRecordID: CKRecord.ID, retryCount: Int = 0) {
//        var membersIDs = tripRecord["MembersIDs"] as? [CKRecord.Reference] ?? []
//        
//        let userReference = CKRecord.Reference(recordID: currentUserRecordID, action: .none)
//        membersIDs.append(userReference)  // Add the current user's reference
//        
//        tripRecord["MembersIDs"] = membersIDs
//        
//        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.save(tripRecord) { record, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    if retryCount < 3 && (error as? CKError)?.code == .serverRecordChanged {
//                        // Retry the operation if it's a conflict error
//                        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.fetch(withRecordID: tripRecord.recordID) { newRecord, fetchError in
//                            if let newRecord = newRecord, fetchError == nil {
//                                self.updateTripMembers(tripRecord: newRecord, currentUserRecordID: currentUserRecordID, retryCount: retryCount + 1)
//                            } else {
//                                self.statusMessage = "Error fetching updated trip record: \(fetchError?.localizedDescription ?? "Unknown error")"
//                                self.showAlert = true
//                            }
//                        }
//                    } else {
//                        self.statusMessage = "Error updating trip members: \(error.localizedDescription)"
//                        self.showAlert = true
//                    }
//                } else {
//                    // Fetch updated trip details to navigate
//                    self.fetchTrip(withCode: self.code) { tripModel in
//                        if let tripModel = tripModel {
//                            self.trip = tripModel
//                            self.navigateToTripView = true // Trigger navigation
//                        } else {
//                            self.statusMessage = "Updated trip not found."
//                            self.showAlert = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    public func fetchTrip(withCode code: String, completion: @escaping (CreateTrip1?) -> Void) {
//        let predicate = NSPredicate(format: "code == %@", code)
//        let query = CKQuery(recordType: "Trips", predicate: predicate)
//
//        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Failed to fetch trip: \(error)")
//                    completion(nil)
//                    return
//                }
//
//                guard let record = records?.first else {
//                    print("No trip found with the provided code.")
//                    completion(nil)
//                    return
//                }
//
//                let tripName = record["TripName"] as? String ?? ""
//                let tripCode = record["code"] as? String ?? ""
//                let ID = record["id"] as? String ?? ""
//                let userID = record["user_id"] as? String ?? ""
//                let tripDetails = record["tripDetails"] as? String ?? ""
//                let phoneNumber = record["phoneNumber"] as? Int ?? 0
//                let level = record["level"] as? String ?? "Easy"
//                let startDate = record["startDate"] as? Date ?? Date()
//                let endDate = record["endDate"] as? Date ?? Date()
//                let membersIDs = record["MembersIDs"] as? [CKRecord.Reference] ?? []
//                let pickupLocation = CLLocationCoordinate2D(
//                               latitude: record["pickupLocationLatitude"] as? CLLocationDegrees ?? 0.0,
//                               longitude: record["pickupLocationLongitude"] as? CLLocationDegrees ?? 0.0
//                           )
//                let dropOffLocation = CLLocationCoordinate2D(
//                               latitude: record["dropOffLocationLatitude"] as? CLLocationDegrees ?? 0.0,
//                               longitude: record["dropOffLocationLongitude"] as? CLLocationDegrees ?? 0.0
//                           )
//                let meetSpots = (record["meetSpots"] as? [[String: CLLocationDegrees]])?.map {
//                               CLLocationCoordinate2D(latitude: $0["latitude"] ?? 0.0, longitude: $0["longitude"] ?? 0.0)
//                           } ?? []
//
//                let tripModel = CreateTrip1(
//                                TripName: tripName,
//                                code: tripCode,
//                                record: record,
//                                id: ID,
//                                user_id: userID,
//                                tripDetails: tripDetails,
//                                phoneNumber: phoneNumber,
//                                level: level,
//                                startDate: startDate,
//                                endDate: endDate,
//                                MembersIDs: membersIDs,
//                                pickupLocation: pickupLocation,
//                                dropOffLocation: dropOffLocation,
//                                meetSpots: meetSpots
//                            )            }
//        }
//    }
//
//}
//
//
//
//
//
