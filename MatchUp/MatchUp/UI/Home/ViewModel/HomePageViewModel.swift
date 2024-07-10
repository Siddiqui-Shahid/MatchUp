//
//  HomePageViewModel.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import SwiftUI
import Combine
import CoreData
import SDWebImageSwiftUI

class HomePageViewModel: ObservableObject {
    @Published var users: [UserViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let maxUsersLimit = 1000
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        guard let url = URL(string: "https://randomuser.me/api/?results=10") else {
            fetchUsersFromCoreData()
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PartnerModel.self, decoder: JSONDecoder())
            .map { $0.results ?? [] }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error fetching users: \(error)")
                    self?.fetchUsersFromCoreData()
                }
            }, receiveValue: { [weak self] apiUsers in
                let userViewModels = apiUsers.map { UserViewModel(apiUser: $0) }
                self?.fetchUsersFromCoreData()
                if let strongSelf = self {
                    strongSelf.users.insert(contentsOf: userViewModels, at: 0)
                    strongSelf.users = Array(strongSelf.users.prefix(strongSelf.maxUsersLimit))
                    CoreDataStack.shared.reset()
                    strongSelf.saveUsersToCoreData(users: strongSelf.users)
                    
                }
            })
            .store(in: &cancellables)
    }
    
    private func saveUsersToCoreData(users: [UserViewModel]) {
        let context = CoreDataStack.shared.context
        
        let dispatchGroup = DispatchGroup()
        
        for (index, apiUser) in users.enumerated() {
            dispatchGroup.enter()
            let userEntity = UserEntity(context: context)
            userEntity.email = apiUser.email
            userEntity.location = apiUser.location
            userEntity.selectionStatus = SelectionStatus.notDecided.rawValue
            userEntity.index = Int32(index) // Set the index attribute
            
            if let apiName = apiUser.userName {
                let nameEntity = NameEntity(context: context)
                nameEntity.title = apiName.title
                nameEntity.first = apiName.first
                nameEntity.last = apiName.last
                userEntity.name = nameEntity
            }
            
            if let apiPicture = apiUser.picture {
                let pictureEntity = PictureEntity(context: context)
                pictureEntity.large = apiPicture.largeURL
                pictureEntity.medium = apiPicture.mediumURL
                pictureEntity.thumbnail = apiPicture.thumbnailURL
                userEntity.picture = pictureEntity
                
                // saving the data of image for offline usage
                if let data = apiUser.picture?.largeData {
                    userEntity.imageData = data
                    dispatchGroup.leave()
                } else {
                    if let imageUrl = URL(string: apiPicture.largeURL ?? "") {
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            if let imageData = data {
                                userEntity.imageData = imageData
                            }
                            dispatchGroup.leave()
                        }.resume()
                    } else {
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                CoreDataStack.shared.saveContext()
            }
        }
        
    }
    
    private func fetchUsersFromCoreData() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            var temp: [(index: Int, userModel: UserViewModel)] = []
            temp = userEntities.map { userEntity in
                return (
                    index: Int(userEntity.index),
                    userModel: UserViewModel(
                        name: Username(first: userEntity.name?.first, last: userEntity.name?.last, title: "\(userEntity.index)\(userEntity.name?.title ?? "")"),
                        email: userEntity.email,
                        location: userEntity.location,
                        picture: UserPicture(largeURL: userEntity.picture?.large, largeData: userEntity.imageData),
                        status: userEntity.selectionStatus,
                        imageData: userEntity.imageData
                    )
                )
            }.sorted(by: { a, b in
                a.index < b.index
            })
            let data = temp
                .compactMap{ $0.userModel }
            self.users = data
        } catch {
            debugPrint("Error fetching users from Core Data: \(error)")
        }
    }
    
    func updateSelectionStatus(for email: String, status: SelectionStatus) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        for index in 0..<users.count {
            if users[index].email == email {
                users[index].status = status
            }
        }
        do {
            let userEntities = try context.fetch(fetchRequest)
            if let userEntity = userEntities.first {
                userEntity.selectionStatus = status.rawValue
                try context.save()
            }
        } catch {
            debugPrint("Error updating selection status in Core Data: \(error)")
        }
    }
    
}

struct UserViewModel {
    let userName: Username?
    let picture: UserPicture?
    let email: String?
    let location: String?
    var status: SelectionStatus = .notDecided
    var imageData: Data?
    
    init(apiUser: APIUser) {
        self.userName = Username(first: apiUser.name?.first, last: apiUser.name?.last, title: apiUser.name?.title)
        self.email = apiUser.email ?? ""
        self.location = apiUser.location?.getLocation(location: apiUser.location)
        self.picture = UserPicture(largeURL: apiUser.picture?.large)
    }
    
    init(name: Username?, email: String?, location: String?, picture: UserPicture?, status: Int16, imageData: Data?) {
        self.userName = name
        self.picture = picture
        self.email = email
        self.imageData = imageData
        self.location = location
        self.status = SelectionStatus(rawValue: status) ?? .notDecided
    }
    
    
}

struct Username{
    public var first: String?
    public var last: String?
    public var title: String?
    init(first: String? = nil, last: String? = nil, title: String? = nil) {
        self.first = first
        self.last = last
        self.title = title
    }
}

struct UserPicture{
    let largeURL: String?
    let mediumURL: String?
    let thumbnailURL: String?
    let largeData: Data?
    let mediumData: Data?
    let thumbnailData: Data?
    init(largeURL: String? = nil, mediumURL: String? = nil, thumbnailURL: String? = nil, largeData: Data? = nil, mediumData: Data? = nil, thumbnailData: Data? = nil) {
        self.largeURL = largeURL
        self.mediumURL = mediumURL
        self.thumbnailURL = thumbnailURL
        self.largeData = largeData
        self.mediumData = mediumData
        self.thumbnailData = thumbnailData
    }
}
