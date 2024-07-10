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
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: scaled.getScaledWidth(value: 100), height: scaled.getScaledHeight(value: 100))
//                .clipShape(Circle())
        } else if let url = imageURL {
            WebImage(url: url)
                .onSuccess { image, data, cacheType in
                    // Do something with the image
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: scaled.getScaledWidth(value: 100), height: scaled.getScaledHeight(value: 100))
//                .clipShape(Circle())
        } else {
            Rectangle()
                .fill(Color.gray)
                .aspectRatio(contentMode: .fill)
                .frame(width: scaled.getScaledWidth(value: 100), height: scaled.getScaledHeight(value: 100))
        }
    }
}
