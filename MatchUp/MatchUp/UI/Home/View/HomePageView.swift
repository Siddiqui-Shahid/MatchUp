//
//  HomePageView.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = HomePageViewModel()
    @State private var searchText = ""
    public let scaled = ScaledDimensions.shared
    
    var filteredUsers: [UserViewModel] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { user in
                user.location?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(filteredUsers.indices, id: \.self) { index in
                            let user = filteredUsers[index]
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                VStack(alignment: .center, spacing: scaled.getScaledHeight(value: 12)) {
                                    CustomImageView(imageURL: URL(string: user.picture?.largeURL ?? ""), imageData: user.picture?.largeData)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                        .frame(width: scaled.getScaledWidth(value: 120), height: scaled.getScaledHeight(value: 120))
                                        .padding(.top, scaled.getScaledHeight(value: 16))

                                    Text("\(user.userName?.title ?? ""). \(user.userName?.first ?? "") \(user.userName?.last ?? "")")
                                        .font(.system(size: scaled.getScaledFontSize(value: 22), weight: .bold))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)

                                    Text(user.location ?? "")
                                        .font(.system(size: scaled.getScaledFontSize(value: 16)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)

                                    if user.status == .notDecided {
                                        HStack(spacing: scaled.getScaledWidth(value: 40)) {
                                            Button(action: {
                                                withAnimation {
                                                    viewModel.updateSelectionStatus(for: user.email ?? "", status: .rejected)
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: scaled.getScaledWidth(value: 50), height: scaled.getScaledHeight(value: 50))
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(ScaleButtonStyle())
                                            
                                            Button(action: {
                                                withAnimation {
                                                    viewModel.updateSelectionStatus(for: user.email ?? "", status: .accepted)
                                                }
                                            }) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: scaled.getScaledWidth(value: 50), height: scaled.getScaledHeight(value: 50))
                                                    .foregroundColor(.green)
                                            }
                                            .buttonStyle(ScaleButtonStyle())
                                        }
                                        .padding(.vertical, scaled.getScaledHeight(value: 16))
                                    } else {
                                        StatusBadgeView(status: user.status)
                                            .padding(.vertical, scaled.getScaledHeight(value: 16))
                                    }
                                    
                                    if index == viewModel.users.count - 1 {
                                        ProgressView()
                                            .onAppear {
                                                viewModel.fetchUsers()
                                            }
                                    }
                                }
                                .padding(.vertical, scaled.getScaledHeight(value: 8))
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await refreshData()
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by location")
                .navigationTitle("Match Up")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
    
    func refreshData() async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        viewModel.fetchUsers(isPaginated: false)
    }
}

// MARK: - Supporting Views

struct StatusBadgeView: View {
    let status: SelectionStatus
    public let scaled = ScaledDimensions.shared
    
    var body: some View {
        Text(status == .accepted ? "Accepted" : "Declined")
            .font(.system(size: scaled.getScaledFontSize(value: 16), weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, scaled.getScaledWidth(value: 16))
            .padding(.vertical, scaled.getScaledHeight(value: 8))
            .background(
                Capsule()
                    .fill(status == .accepted ? Color.green : Color.red)
            )
            .transition(.scale)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}



import SwiftUI

struct UserProfileView: View {
    let user: UserViewModel
    let onAccept: () -> Void
    let onReject: () -> Void
    public let scaled = ScaledDimensions.shared
    
    var body: some View {
        VStack(spacing: scaled.getScaledHeight(value: 16)) {
            CustomImageView(imageURL: URL(string: user.picture?.largeURL ?? ""), imageData: user.picture?.largeData)
                .frame(width: scaled.getScaledWidth(value: 150), height: scaled.getScaledHeight(value: 150))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.top, scaled.getScaledHeight(value: 20))
            
            Text("\(user.userName?.title ?? ""). \(user.userName?.first ?? "") \(user.userName?.last ?? "")")
                .font(.system(size: scaled.getScaledFontSize(value: 28), weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(user.location ?? "")
                .font(.system(size: scaled.getScaledFontSize(value: 18)))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if user.status == .notDecided {
                HStack(spacing: scaled.getScaledWidth(value: 60)) {
                    Button(action: onReject) {
                        VStack {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: scaled.getScaledWidth(value: 60), height: scaled.getScaledHeight(value: 60))
                                .foregroundColor(.red)
                            
                            Text("Decline")
                                .font(.system(size: scaled.getScaledFontSize(value: 14), weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button(action: onAccept) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: scaled.getScaledWidth(value: 60), height: scaled.getScaledHeight(value: 60))
                                .foregroundColor(.green)
                            
                            Text("Accept")
                                .font(.system(size: scaled.getScaledFontSize(value: 14), weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.vertical, scaled.getScaledHeight(value: 20))
            } else {
                StatusBadgeView(status: user.status)
                    .padding(.vertical, scaled.getScaledHeight(value: 20))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, scaled.getScaledWidth(value: 20))
    }
}

#Preview {
    HomePageView()
}
