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

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView( )
//    }
//}
