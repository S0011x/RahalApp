import SwiftUI
import MapKit
import Network

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

    func CheckNetwoekConection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("Internet connection is available.")
                    wifiImage = Image(systemName: "wifi")
                    wifiColor = .blueGray600
                } else if path.status == .unsatisfied {
                    print("Internet connection is not strong.")
                    wifiImage = Image(systemName: "wifi.exclamationmark")
                    wifiColor = .gray
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
                
                
                VStack{
                    HeaderView
                    
                     Spacer()
                    HStack {
                        
                        //show members to the leader
                        widgetBox(text: StringConstants.kLbl3)
                        widgetBox(text: StringConstants.kLbl5)
                        
                        imageBox(image: "img_sos_circle_fill")
                    }.frame(width:350, alignment: .trailing)
                } .onAppear {
                    CheckNetwoekConection()
                }
        }.hideNavigationBar()
        
    }
        
    
    func widgetBox(text: String) -> some View{
        return  HStack(spacing: 0) {
            Text(text)
                .font(FontScheme
                    .kSFArabicSemibold(size: getRelativeHeight(16.0)))
                .fontWeight(.semibold)
                .padding(.horizontal, getRelativeWidth(8.0))
                .padding(.vertical, getRelativeHeight(7.0))
                .foregroundColor(ColorConstants.BlueGray600)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .frame(width: getRelativeWidth(91.0),
                       height: getRelativeHeight(36.0), alignment: .center)
                .background(RoundedCorners(topLeft: 18.0, topRight: 18.0,
                                           bottomLeft: 18.0, bottomRight: 18.0)
                    .fill(ColorConstants.Gray10001))
        }.frame(width: getRelativeWidth(91.0), height: getRelativeHeight(36.0),
                  alignment: .center)
           .background(RoundedCorners(topLeft: 18.0, topRight: 18.0, bottomLeft: 18.0,
                                      bottomRight: 18.0)
               .fill(ColorConstants.Gray10001))
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
                    .fill(ColorConstants.Gray100))
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
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.whiteA700)
                        .frame(width: 45, height: 45)
                        .cornerRadius(8)
                    
                    NavigationLink(destination:HomeViews() ,label: {
//                        Image("close")
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: getRelativeWidth(34), height: getRelativeWidth(34),
                                   alignment: .center)
                            .foregroundColor(wifiColor)
                    })
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
//
//                wifiImage
//                    .resizable()
//                    .frame(width: 55, height: 45)
//                    .foregroundColor(wifiColor)
//                    .cornerRadius(12)
//                    .background
                
                Spacer()
                ZStack{
                    Color(.whiteA700)
                    VStack {
                        NavigationLink(destination: UserAccountView(), label: {
                            Image("img_person_circle_1")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                        })
                        
                        NavigationLink(destination: NotificationView() , label: {
                            Image("img_group_22")
                        })
                        
                        NavigationLink(destination: UserAccountView(), label: {
//                            Image("zoom")
                            Image(systemName: "square.arrowtriangle.4.outward")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                                .foregroundColor(.blueGray600)
                        })
                        
                        NavigationLink(destination: NotificationView() , label: {
                            Image("more")
//                                .toolbar {
//
//                                }
                        })
                        
                    }
                }
                .frame(width:50,height: 180)
                .cornerRadius(12)
            }.frame(width:340)
        }.frame(width:340,alignment: .trailing)
    }
    
    
}
