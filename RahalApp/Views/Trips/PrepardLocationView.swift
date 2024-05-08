import SwiftUI
import MapKit
struct PrepardLocationView: View {
    @State private var messagetwooneText: String = ""
    //@StateObject var mapData = MapViewModel()
    // Location Manager....
    @State var locationManager = CLLocationManager()
    
    var body: some View {
            ZStack(alignment: .center) {
                Map(interactionModes: [.rotate, .zoom])
                    .mapStyle(.standard)
                
                
                VStack{
                    HeaderView
                     Spacer()
                    HStack {
                        widgetBox(text: StringConstants.kLbl3)
                        widgetBox(text: StringConstants.kLbl5)
                        
                        imageBox(image: "img_sos_circle_fill")
                    }.frame(width:350, alignment: .trailing)
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
        PrepardLocationView()
    }
}


extension PrepardLocationView {
    private var HeaderView: some View{
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment:.top){
                
                NavigationLink(destination:HomeViews() ,label: {
                    Image("close")
                        .resizable()
                        .frame(width: getRelativeWidth(35), height: getRelativeWidth(35),
                               alignment: .center)
                })
                
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
                            Image("zoom")
                                .resizable()
                                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(34.0),
                                       alignment: .center)
                        })
                        
                        NavigationLink(destination: NotificationView() , label: {
                            Image("more")
                        })
                        
                    }
                }
                .frame(width:50,height: 180)
                .cornerRadius(12)
            }.frame(width:340)
        }.frame(width:340,alignment: .trailing)
    }
    
    
}
