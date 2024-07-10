//
//  HomePageView.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = HomePageViewModel()
    public let scaled = ScaledDimensions.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.users, id: \.email) { user in
                        VStack(alignment: .center) {
                            CustomImageView(imageURL: URL(string: user.picture?.largeURL ?? ""), imageData: user.picture?.largeData)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                            
                            Text("\(user.userName?.title ?? ""). \(user.userName?.first ?? "") \(user.userName?.last ?? "")")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(user.location ?? "")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            if user.status == .notDecided {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            viewModel.updateSelectionStatus(for: user.email ?? "", status: .rejected)
                                        }
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            viewModel.updateSelectionStatus(for: user.email ?? "", status: .accepted)
                                        }
                                }
                                .padding()
                            } else {
                                Text(user.status == .accepted ? "Accepted" : "Declined")
                                    .foregroundColor(.white)
                                    .frame(height: scaled.getScaledHeight(value: 40))
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    }
                }
                .navigationTitle("Random Users")
            }
        }
    }
}


import SwiftUI

struct UserProfileView: View {
    var body: some View {
        VStack {
            Image("profile_picture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
            
            Text("Adilson Pultrum")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("56, Oudega gem")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("SmallingerInd, Drenthe")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Button(action: {
                    // Action for dislike button
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    // Action for like button
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

#Preview {
    HomePageView()
}
