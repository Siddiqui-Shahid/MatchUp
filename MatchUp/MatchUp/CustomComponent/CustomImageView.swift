//
//  CustomImageView.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomImageView: View {
    var imageURL: URL?
    var imageData: Data?
    public let scaled = ScaledDimensions.shared
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            } else if let url = imageURL {
                WebImage(url: url)
                    .onSuccess { _, _, _ in
                        isLoading = false
                    }
                    .onFailure { _ in
                        isLoading = false
                    }
                    .onProgress { _, _ in
                        isLoading = true
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            } else {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                        .foregroundColor(.gray)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLoading)
    }
}
