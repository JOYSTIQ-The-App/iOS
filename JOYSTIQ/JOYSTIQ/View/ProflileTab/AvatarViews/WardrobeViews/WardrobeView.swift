//
//  WardrobeView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//


import SwiftUI
import SceneKit

struct WardrobeView: View {
    
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var hideNavBar: Bool
    @Binding var avatarSnapshot: UIImage?
    @Binding var enviroInt: Int
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")
    
    private var s3Service: S3ServiceProtocol
    @Binding var avatarS3Key: S3Key
    private var apiService: APIServiceProtocol
    @State private var isLoading: Bool = false

    init(hideNavBar: Binding<Bool>, avatarSnapshot: Binding<UIImage?>, enviroInt: Binding<Int>, avatarS3Key: Binding<S3Key>, apiService: APIServiceProtocol = APIService(), s3Service: S3ServiceProtocol = S3Service()) {
        _hideNavBar = hideNavBar
        _avatarSnapshot = avatarSnapshot
        _enviroInt = enviroInt
        _avatarS3Key = avatarS3Key
        self.s3Service = s3Service
        self.apiService = apiService
    }
    
    //new menu props
    enum CustomizationOption {
        case skin, hair, torso, pants, shoes, env, none
    }
    @State private var selectedOption: CustomizationOption = .skin



    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            Spacer()
            
            Image("createyouravatar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenUtil.width * 0.6, height: 30)
                .padding(.bottom, 10)
            
            Divider()
                .frame(height: 2)
                .background(Color.green)
                   
            ZStack { //for scene and backround environment image
                
                sceneKitView
                    .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.5)
                    .zIndex(1)
                
                Image("wardrobeTest3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.5)
                    .zIndex(0)
                    
                
            }//end ZStack for scene and backround environment image
            .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 2)
            
            wardrobeCustomizer

            
        } //end Main VStack for scenekitview and wardrobe controls
        .edgesIgnoringSafeArea(.all)
        .frame(width: ScreenUtil.width, height: ScreenUtil.height)
        .background(Color("GradientDark"))
        .onAppear {
            hideNavBar = true
        }
    }
    
    private var wardrobeCustomizer: some View {
        VStack(spacing: 0) {
            wardrobeButtons
            Spacer()
            customizerView
            Spacer()
            saveButton
        }
        .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.35)
        .padding(.bottom, ScreenUtil.height * 0.05)
    }

    @ViewBuilder
    private var customizerView: some View {
        switch selectedOption {
        case .skin:
            SkinToneSwitcherView(sceneKitView: $sceneKitView)
        case .hair:
            HairSwitcherView(sceneKitView: $sceneKitView)
        case .torso:
            ShirtSwitcherView(sceneKitView: $sceneKitView)
        case .pants:
            PantSwitcherView(sceneKitView: $sceneKitView)
        case .shoes:
            ShoeSwitcherView(sceneKitView: $sceneKitView)
        case .env:
            EnvironmentSwitcherView(enviroInt: $enviroInt)
        case .none:
            EmptyView()  // Or provide a default view
        }
    }

    private var wardrobeButtons: some View {
        HStack(spacing: 0) {
            skinButton
            hairButton
            torsoButton
            pantsButton
            shoesButton
            envButton
        }
    }
    
    private var skinButton: some View {
        Button(action: {
            selectedOption = .skin
        }) {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .skin ? Color.clear : Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var hairButton: some View {
        Button(action: {
            selectedOption = .hair
        }) {
            Image("hairicon")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .hair ? Color.clear : Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var torsoButton: some View {
        Button(action: {
            selectedOption = .torso
        }) {
            Image(systemName: "tshirt.fill")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .torso ? Color.clear: Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var pantsButton: some View {
        Button(action: {
            selectedOption = .pants
        }) {
            Image("shorts")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .pants ? Color.clear : Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var shoesButton: some View {
        Button(action: {
            selectedOption = .shoes
        }) {
            Image(systemName: "shoe.2.fill")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.08)
                .padding(.vertical, ScreenUtil.height * 0.007)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .shoes ? Color.clear : Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var envButton: some View {
        Button(action: {
            selectedOption = .env
        }) {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .frame(width: ScreenUtil.width * 0.114, height: ScreenUtil.width * 0.11)
                .foregroundColor(Color("LightGray"))
                .padding(ScreenUtil.width * 0.026)
                .background(selectedOption == .env ? Color.clear : Color("GradientDark2").opacity(0.2))
        }
    }
    
    private var saveButton: some View {
        HStack(spacing: 0) { //for save and cancel buttons
    
            //Save button
            Button(action: {
                isLoading = true
                saveAvatar()
            }, label: {
                if isLoading {
                    ProgressView() // Spinning loader
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                } else {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                }
            })
            .contentShape(Rectangle())
            .disabled(isLoading)
        } //end HStack
    }
    
    private var EarlierIteration: some View {
        
        NavigationView {
                
            Grid(horizontalSpacing: 20, verticalSpacing: 20) { //start grid for cosmetic customizations menu
                
                GridRow { //start gridrow1
                    
                    NavigationLink(destination: SkinToneSwitcherView(sceneKitView: $sceneKitView)) { //start navlink
                        
                        ZStack { //for torso button

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "figure.stand")
                                .resizable()
                                .frame(width: 15, height: 30)
                                .foregroundColor(Color("LightGray"))
                            
                        } //end zstack for torso button
                        
                    } //end navLink
                    
                    NavigationLink(destination: HairSwitcherView(sceneKitView: $sceneKitView)) { //start hair navlink
                        
                        ZStack {
                            
                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("LightGray"))
                            
                            Image("hairicon")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                    }
                    
                    NavigationLink(destination: ShirtSwitcherView(sceneKitView: $sceneKitView)) { //start navlink
                        
                        ZStack { //for torso button

                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "tshirt.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("LightGray"))
                            
                        } //end zstack for torso button
                        
                        
                                                
                   } //end navLink

                } //end gridrow1
                
                GridRow { //start gridrow2
                    
                    NavigationLink(destination: PantSwitcherView(sceneKitView: $sceneKitView)) {
                        
                        ZStack {
                            
                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image("shorts")
                                .resizable()
                                .frame(width: 25, height: 30)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                        
                    }
                    
                    NavigationLink(destination: ShoeSwitcherView(sceneKitView: $sceneKitView)) {
                            Image(systemName: "shoe.2.fill")
                                .resizable()
                                .frame(width: 50, height: 35)
                                .foregroundColor(Color("LightGray"))
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5) // Adjust corner radius as needed
                                        .stroke(Color("LightGray"), lineWidth: 2) // Customize border color and width
                                )
                    } //end navLink for shoes
                    
                    
                    NavigationLink(destination: EnvironmentSwitcherView(enviroInt: $enviroInt)) {
                        
                        ZStack {
                            
                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("LightGray"))
                            
                            
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color("LightGray"))
                            
                        }
                    }
                    
                } //end gridrow2
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 1)
                    .background(Color.gray)
                
                
                HStack(spacing: 0) { //for save and cancel buttons
            
                    //Save button
                    Button(action: {
                        isLoading = true
                        saveAvatar()
                    }, label: {
                        if isLoading {
                            ProgressView() // Spinning loader
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading
                                    )
                                )
                                .cornerRadius(30)
                        } else {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading
                                    )
                                )
                                .cornerRadius(30)
                        }
                    })
                    .contentShape(Rectangle())
                    .disabled(isLoading)
               
                } //end HStack for save and cancel buttons
                
                
            } //end grid for cosmetic customizations menu/
            .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.35)
            .background(Color("GradientDark"))

        } //end navigation view
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .accentColor(Color.white.opacity(0.8))
    }
    
    func saveAvatar() {
        avatarSnapshot = sceneKitView.takeTheSnapshot()
        guard let data = avatarSnapshot?.pngData() else {
            print("Error converting image to Data")
            return
        }
        
        // Generate a unique key with the .png extension for the avatar image
        let newKey = "\(UUID().uuidString).png"
        
        Task {
            do {
                let uploadedKey = try await s3Service.uploadData(data, withKey: newKey)
                print("Uploaded image with key: \(uploadedKey)")
                
                var environment = "classic"
                if enviroInt == 1 {
                    environment = "gameroom"
                }
                
                if avatarS3Key.Valid {
                    // Use the oldS3Key property of the WardrobeView directly
                    apiService.updateUserAvatar(username: user.username, oldS3Key: avatarS3Key.String, newS3Key: uploadedKey, enviro: environment) { result in
                        switch result {
                        case .success:
                            avatarS3Key.String = uploadedKey
                            print("Successfully updated user avatar")
                        case .failure(let error):
                            print("Error updating user avatar: \(error.localizedDescription)")
                        }
                    }
                } else {
                    apiService.updateUserAvatar(username: user.username, oldS3Key: nil, newS3Key: uploadedKey, enviro: environment) { result in
                        switch result {
                        case .success:
                            avatarS3Key.String = uploadedKey
                            print("Successfully updated user avatar")
                        case .failure(let error):
                            print("Error updating user avatar: \(error.localizedDescription)")
                        }
                    }
                }

                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return WardrobeView(
            hideNavBar: .constant(true),
            avatarSnapshot: .constant(UIImage(systemName: "person.circle")!),
            enviroInt: .constant(1),
            avatarS3Key: .constant(S3Key(String: "", Valid: false)),
            apiService: MockAPIService(),
            s3Service: MockS3Service()
        )
        .environmentObject(testUser)
    }
}

