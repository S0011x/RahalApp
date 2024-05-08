//
//  OnBoardingView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//

import SwiftUI

struct OnBoardingView: View {
    var data: [OnBoardModel] = onBoardData    
    var body: some View {
        NavigationStack{
            TabView{
                
                ForEach(data , id: \.id) { item in
                    OnBoardingClass(
                        text: item.title,
                        number : item.number,
                        image: item.image
                    )
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .hideNavigationBar()
            .statusBar(hidden: true)
            .ignoresSafeArea(.all)
            .background(ColorConstants.WhiteA700)
                .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    OnBoardingView()
}

let onBoardData : [OnBoardModel] = [
    OnBoardModel(
        title: StringConstants.kMsg,
        number : 0,
        image: "onboarding_image"
    ),
    OnBoardModel(
        title:  StringConstants.kMsg2,
        number : 1,
        image: "onboarding_image2"
    ),
    OnBoardModel(
        title: StringConstants.kMsg3,
        number : 2,
        image: "onboarding_image3"
    ),
    OnBoardModel(
        title: StringConstants.kMsg4,
        number : 3,
        image: "onboarding_image4"
    ),
    OnBoardModel(
        title:  StringConstants.kMsg5,
        number : 4,
        image: "onboarding_image5"
    )
]

struct OnBoardModel: Identifiable {
    var id = UUID()
    var title: String
    var number: Int
    var image: String
}
