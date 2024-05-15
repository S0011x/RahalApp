import SwiftUI

struct SplashView: View {
    @Binding var isOnboarding: Bool
    
    @State var isFinished = false
    
    var body: some View {
        if(self.isFinished){
            if isOnboarding {
                OnBoardingView()
            }else{
                HomeViews()
            }
        }else{
            
            VStack {
                VStack {
                    Image("img_untitled_artwork")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,
                               alignment: .topLeading)
                        .scaledToFit()
                        .clipped()
                }
                
                //GIF Splash
//                GifView(gifName: "Splash")
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(ColorConstants.BlueGray600)
            .hideNavigationBar()
            .ignoresSafeArea()
            .onAppear(perform: {
                animation()
            })
        }
    }
    
    func animation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
       
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                     withAnimation(){
                         isFinished.toggle()
                     }
                 }
                 
             }
    }
}

struct GifView: UIViewRepresentable {
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
    
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        //                    imageView.contentMode = .scaleAspectFit
        
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {
            let imageSource = CGImageSourceCreateWithData(gifData as CFData, nil)
            var images = [UIImage]()
            
            if let imageSource = imageSource {
                let count = CGImageSourceGetCount(imageSource)
                for i in 0..<count {
                    if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                        images.append(UIImage(cgImage: cgImage))
                    }
                }
            }
            
            imageView.animationImages = images
            imageView.animationDuration = TimeInterval(images.count) * 0.1
            imageView.startAnimating()
        }
        
        return imageView
    }
}

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView( )
//    }
//}
