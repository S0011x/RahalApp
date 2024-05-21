import SwiftUI
import MapKit
import Network
import OneSignalFramework

struct PrepardLocationView: View {
    @State private var messagetwooneText: String = ""
    //@StateObject var mapData = MapViewModel()
    // Location Manager....
    @State var locationManager = CLLocationManager()
    
    @State var pickupLocation: CLLocationCoordinate2D
    @State var dropOffLocation: CLLocationCoordinate2D
    @State var meetSpots: [CLLocationCoordinate2D]

   
    @State private var wifiImage: Image = Image(systemName: "wifi")
    @State private var wifiColor: Color = .white
    
    
    //Close and Meniu
    @State private var selectedOption: String? = nil
    @State private var isShareSheetPresented = false
    @State private var isShowingAlert = false
    @State private var isNavigateToAnotherView = false
    
    //Hide
    @State private var hideElements = false
    
    //NotificationViewModel
    var notificationViewModel = NotificationViewModel()

    func CheckNetwoekConection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("Internet connection is available.")
                    wifiImage = Image(systemName: "wifi")
                    wifiColor = ColorConstants.IconColor
                } else if path.status == .unsatisfied {
                    print("Internet connection is not strong.")
                    wifiImage = Image(systemName: "wifi.exclamationmark")
                    wifiColor = .red
                } else {
                    print("Internet connection is not available.")
                    wifiImage = Image(systemName: "wifi.slash")
                    wifiColor = .red
                }
            }
        }
    }
    
    var body: some View {
            ZStack(alignment: .center) {
                
                MyMapView(requestLocation: $pickupLocation, destinationLocation: $dropOffLocation,meetSpots: $meetSpots).edgesIgnoringSafeArea(.all)
                
                
                if !hideElements {
                    VStack{
                        HeaderView
                        
                        Spacer()
                        
                        ScrollView (.horizontal) {
                            HStack {
                                widgetBox(text: StringConstants.kLbl5)
                                widgetBox(text: "أنا هنا")
                                widgetBox(text: "أحتاج ماء")
                                widgetBox(text: "أحتاج استراحة")
                                widgetBox(text: "لقد علقت")
                            }.frame(width:500, alignment: .trailing)
                        }
                    } .onAppear {
                        CheckNetwoekConection()
                    }
                } else {
                    Button {
                        hideElements.toggle()
                    }  label: {
                        ZStack {
                            
                            Rectangle()
                                .foregroundColor(.whiteA700)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            
                            Image(systemName: "square.arrowtriangle.4.outward")
                                .resizable()
                                .frame(width: getRelativeWidth(45), height: getRelativeWidth(45),
                                       alignment: .center)
                                .foregroundColor(Color.red)
                        }.frame(width:340,alignment: .topTrailing)
                            .padding(.bottom , 700)

                        
                    }
                }
        }.hideNavigationBar()
        
    }
        
    
    func widgetBox(text: String) -> some View{
        
        var text = text
        
        return  HStack(spacing: 0) {
            
            Button {
                notificationViewModel.addItem(name: text)
            } label: {

            Text(text)
                .font(FontScheme
                    .kSFArabicSemibold(size: getRelativeHeight(16.0)))
                .fontWeight(.semibold)
                .padding(.horizontal, getRelativeWidth(8.0))
                .padding(.vertical, getRelativeHeight(7.0))
                .foregroundColor(ColorConstants.IconColor)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .frame(width: getRelativeWidth(91.0),
                       height: getRelativeHeight(36.0), alignment: .center)
                .background(RoundedCorners(topLeft: 18.0, topRight: 18.0,
                                           bottomLeft: 18.0, bottomRight: 18.0)
                    .fill(ColorConstants.WhiteA700))}.frame(width: getRelativeWidth(91.0), height: getRelativeHeight(36.0),
                  alignment: .center)
                    .background(RoundedCorners(topLeft: 18.0, topRight: 18.0, bottomLeft: 18.0,
                                      bottomRight: 18.0)
                        .fill(ColorConstants.WhiteA700))
        
        
        }
    }
    
    func imageBox(image: String) -> some View{
        return  HStack(spacing: 0) {
            Image(image)
                .resizable()
                .frame(width: getRelativeWidth(21.0),
                       height: getRelativeWidth(21.0), alignment: .center)
                .scaledToFit()
                .padding(.horizontal, getRelativeWidth(8.0))
                .padding(.vertical, getRelativeHeight(7.0))
                 .background(RoundedCorners(topLeft: 18.0, topRight: 18.0,
                                           bottomLeft: 18.0, bottomRight: 18.0)
                    .fill(ColorConstants.WhiteA700))
        }
    }
}

struct PrepardLocationView_Previews: PreviewProvider {
    static var previews: some View {
        PrepardLocationView(pickupLocation:  CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501), dropOffLocation: CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701), meetSpots: [ CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)])
    }
}


extension PrepardLocationView {
    private var HeaderView: some View{
        
        
        
        
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment:.top){
                
                VStack {
   
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.whiteA700)
                                .frame(width: 45, height: 45)
                                .cornerRadius(8)
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: getRelativeWidth(34), height: getRelativeWidth(34),
                                       alignment: .center)
                                .foregroundColor(ColorConstants.IconColor)
                        }
                    }

                }
                
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.whiteA700)
                        .frame(width: 45, height: 45)
                        .cornerRadius(8)
                    
                    wifiImage
                        .resizable()
                        .frame(width: getRelativeWidth(30), height: getRelativeWidth(24))
                        .foregroundColor(wifiColor)
                }

                
                Spacer()
                ZStack{
                    Color(.whiteA700)
                    VStack {
                        NavigationLink(destination: UserInformationView(), label: {
                            
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                                .foregroundColor(ColorConstants.IconColor)
                        })
                        
                        NavigationLink(destination: NotificationView() , label: {
                           
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                                .foregroundColor(ColorConstants.IconColor)
                        })
                        
                        Button {
                            hideElements.toggle()
                        }  label: {
                           
                            Image(systemName: "square.arrowtriangle.4.outward")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                                .foregroundColor(ColorConstants.IconColor)
                            
                        }
                        

                            Menu {
                                NavigationLink(destination: CreateTripCRUD(), tag: "Option 1", selection: $selectedOption) {
                                     Label("تعديل", systemImage: "pencil") .accentColor(ColorConstants.IconColor)
                                 }
                                 
                               
                                 Button(action: {
                                     selectedOption = "Option 2"
                                 
                                     isShareSheetPresented = true
                                 }) {
                                     Label("مشاركة", systemImage: "square.and.arrow.up.fill") .accentColor(ColorConstants.IconColor)
                                   
                                 }
                             } label: {
                                 Image(systemName: "ellipsis.circle")
                                     .resizable()
                                     .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                            alignment: .center)
                                     .foregroundColor(ColorConstants.IconColor)
                             }
                             .sheet(isPresented: $isShareSheetPresented, onDismiss: {
                                         // Reset selectedOption if needed
                                     }) {
                                         if let selectedOption = selectedOption {
                                             ShareSheet(activityItems: [selectedOption])
                                         }
                                     }
                        
                    }
                }
                .frame(width:50,height: 180)
                .cornerRadius(12)
            }.frame(width:340)
        }.frame(width:340,alignment: .trailing)
        
        
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("هل تود إغلاق الرحلة؟"),
                    message: Text("في حال إغلاق الرحلة ستغلق عند جميع الأعضاء ولن تتمكن من فتحها مجددًا"),
                    primaryButton:.default(Text("إغلاق"), action: {
                        isNavigateToAnotherView = true
                    }),
                    secondaryButton:   .cancel(Text("إلغاء"))
                )
            }
        
            .navigationDestination(isPresented: $isNavigateToAnotherView) {
                HomeViews()

            }

    }
    
    
}


struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
