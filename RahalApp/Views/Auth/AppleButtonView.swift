//
//  AppleButtonView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import Foundation
import AuthenticationServices
import SwiftUI
import UIKit

struct AppleButtonView: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let authorization = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        return authorization
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

#Preview {
    AppleButtonView()
}
