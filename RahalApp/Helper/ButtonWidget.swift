//
//  ButtonWidget.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//

import SwiftUI

struct ButtonWidget: View {
    var text: String
    var body: some View {
            HStack(spacing: 0) {
                Text(text)
                    .fontWeight(.heavy)
                    
                    .foregroundColor(ColorConstants.WhiteA700)
                    .multilineTextAlignment(.center)
                    .frame(width: getRelativeWidth(300),
                           height: getRelativeHeight(43.0), alignment: .center)
                    .background(RoundedCorners(topLeft: 21.0, topRight: 21.0,
                                               bottomLeft: 21.0, bottomRight: 21.0)
                            .fill(ColorConstants.BlueGray600))
            }
    }
}

#Preview {
    ButtonWidget(text: StringConstants.kLbl)
}
