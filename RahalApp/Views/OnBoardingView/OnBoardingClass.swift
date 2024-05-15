
import SwiftUI

struct OnBoardingClass: View {
    var text: String
    var number: Int
    var image: String

    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
            VStack {
                ZStack(alignment: .top) {
                    Image("img_rectangle_369")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: getRelativeHeight(396.0),
                               alignment: .center)
                    
                    
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                            
                            NavigationLink (destination: HomeViews() ,label: {
                                Button(action: {
                                    isOnboarding = false

                                }, label: {
                             
                                Text(StringConstants.kLbl7)
                                    .font(FontScheme.kSFArabicLight(size: getRelativeHeight(24.0)))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: getRelativeWidth(54.0), height: getRelativeHeight(32.0),
                                           alignment: .topLeading)
                                    .padding(.bottom, getRelativeHeight(381.4))
                                    .padding(.leading, getRelativeWidth(303.0))
                                    .padding(.horizontal)
                                })

                            })
                           
                            
                        }
                       
                        Text(text)
                            .font(FontScheme.kSFArabicRegular(size: getRelativeHeight(24.0)))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Black900)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .frame(width: getRelativeWidth(264.0), height: getRelativeHeight(131.0),
                                   alignment: .center)
                        
                        if(number == 4){
                            Button(action: {
                                isOnboarding = false

                            }, label: {
                                NavigationLink(destination: RegisterView(), label:{
                                    ButtonWidget(text: StringConstants.login)
                                }
                                )
                            })
                            Button(action: {
                                isOnboarding = false

                            }, label: {
                                
                                NavigationLink(destination: LoginView(), label:{
                                    ButtonWidget(text: StringConstants.register)
                                })
                            })
                            Text("")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .frame(width: getRelativeWidth(96.0), height: getRelativeHeight(20))
                        }
                        
                        if(number != 4){
                            Text("")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .frame(width: getRelativeWidth(96.0), height: getRelativeHeight(109.0))
                        }
                        PageIndicator(numPages: 5, currentPage: .constant(number),
                                      selectedColor: ColorConstants.Black900,
                                      unSelectedColor: ColorConstants.Black90075, spacing: 8.0)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,
                           alignment: .center)
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .hideNavigationBar()
            .statusBar(hidden: true)
            .ignoresSafeArea(.all)
            .background(ColorConstants.WhiteA700)
            
    }
}


struct OnBoardingClass_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingClass(
            text: StringConstants.kMsg,
            number : 0
            , image: "img_untitled_artwork_416x390"
        )
    }
}
