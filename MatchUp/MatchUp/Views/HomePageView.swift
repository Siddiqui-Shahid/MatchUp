//
//  HomePageView.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = HomePageViewModel()
    
    var body: some View {
        List(viewModel.users, id: \.email) { user in
            VStack(alignment: .leading) {
                Text("\(user.name.title) \(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                if let url = URL(string: user.picture.thumbnail) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
