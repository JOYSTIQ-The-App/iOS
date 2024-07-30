//
//  HomeHeaderView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/30/23.
//

import SwiftUI

struct HomeHeaderView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    @Binding var showDropDown: Bool
    @Binding var selectedFeed: FeedType
    @State private var showPostScreen = false
    let buymeacoffeeLink = "https://www.buymeacoffee.com/joystiq"
    //modal properties
    @State private var showFeedbackModal = false
    @State private var selectedOption: String? = nil
    @State private var feedbackSubmitted: Bool = false
    let options = ["Sharing & exploring gaming content", "Finding new gamers to play with", "Having a place to store my clips", "Having a profile to represent my gaming interests & statistics"]
    @State private var showBugReportModal = false
    @State private var bugReportText = ""
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            
            headerContent
            
            if !showDropDown {
                feedTypePicker
            }
            else {
                joystiqMenu
            }
        }
        .background(headerBackground)
        
    }

    // MARK: - Subviews
    private var headerContent: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                dropdownButton
                Spacer()
            }
            
            createPostButton
                .padding(.trailing, 15)
        }
        .frame(height: ScreenUtil.height * 0.07)
    }

    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation {
                showDropDown.toggle()
            }
            
        }) {
            Image("JS_Logo2")
                .resizable()
                .scaledToFit()
                .frame(width: ScreenUtil.height * 0.035, height: ScreenUtil.height * 0.035)
        }
        .buttonStyle(NeumorphicButtonStyle2())
    }
    
    private var createPostButton: some View {
        Button(action: {
            showPostScreen = true
        }) {
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: ScreenUtil.height * 0.025, height: ScreenUtil.height * 0.025)
                .foregroundColor(Color.white)
            
        }
        .sheet(isPresented: $showPostScreen) {
            CreatePostView(apiService: apiService, isPresented: $showPostScreen)
        }
    }
    
    private var headerBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var feedTypePicker: some View {
        HStack(alignment: .bottom, spacing: ScreenUtil.width * 0.15) {

            Spacer()
            
            Button(action: {
                selectedFeed = .following
            }) {
                VStack(spacing: 8) {
                    Text("Following")
                        .foregroundColor(selectedFeed == .following ? Color.white : Color.lightGray)
                    
                    Rectangle()
                        .frame(width: 70, height: 2) // You can adjust width as needed
                        .foregroundColor(selectedFeed == .following ? Color.white : Color.gray)
                    
                }
            }
            .width(ScreenUtil.width * 0.2)
            
            
            Button(action: {
                selectedFeed = .global
            }) {
                VStack(spacing: 8) {
                    Text("Global")
                        .foregroundColor(selectedFeed == .global ? Color.white : Color.lightGray)
                    
                    Rectangle()
                        .frame(width: 70, height: 2) // You can adjust width as needed
                        .foregroundColor(selectedFeed == .global ? Color.white : Color.gray)
                    
                }
            }
            .width(ScreenUtil.width * 0.2)
            
            Spacer()
         
        }
    }
    
    //MARK: - Menu Views
    private var joystiqMenu: some View {
        ZStack {
            
            if showFeedbackModal {
                feedbackModal
                    .zIndex(2)
            }
            
            if showBugReportModal {
                bugReportModal
                    .zIndex(2)
            }
            
            VStack(spacing: ScreenUtil.height * 0.025) {

                menuTitle
                
                menuInfo
                
                HStack(spacing: ScreenUtil.width * 0.08) {
                    coffeeButton
                    discordButton
                }
                
                feedbackButton
                
                bugreportButton
                
                Spacer()
            }
            .frame(width: ScreenUtil.width, height: ScreenUtil.height * 0.8)
            .background(Color.black.opacity(0.3))
            .zIndex(1)
            
        }
        
    }
    
    private var menuTitle: some View {
        Image("MenuText")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: ScreenUtil.width * 0.7, height: ScreenUtil.height * 0.024, alignment: .center)
            .padding(.top, ScreenUtil.height * 0.03)
    }
    
    private var menuInfo: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) { //just for padding - cant pad concat text
                Text("Beta v1.0.0 Patch Notes")
                    .bold()
                    .foregroundColor(Color.white)
                    .font(.system(size: ScreenUtil.height * 0.023))
                    
                +
                Text("\n- Improved post structures to resolve like & comment button issues \n- Updated JOYSTIQ Menu \n- Improved create post UX \n- Profile page redesign \n- Introduced alpha / beta medals \n- Improved avatars \n- UI improvements in settings")
                    .foregroundColor(Color.white)
                    .font(.system(size: ScreenUtil.height * 0.016))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)

        }
        .frame(width: ScreenUtil.width * 0.8, height: ScreenUtil.height * 0.2, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
    }
    
    private var coffeeButton: some View {
        Button(action: {
            if let url = URL(string: self.buymeacoffeeLink) {
                UIApplication.shared.open(url)
            }
        }) {
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(width: ScreenUtil.height * 0.15, height: ScreenUtil.height * 0.15)
                    .foregroundColor(Color("Black3"))
                    .background(Color.brown)
                    .cornerRadius(10)
        }
    }
    
    private var discordButton: some View {
        Button(action: {
            if let url = URL(string: "https://discord.gg/8HFpDE54Qs") {
                UIApplication.shared.open(url)
            }
        }, label: {
            Image("discordlogo2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ScreenUtil.height * 0.15, height: ScreenUtil.height * 0.15)
                .background(Color(hex: 0x738ADB))
                .cornerRadius(10)
        })
    }
    
    private var feedbackButton: some View {
        VStack(spacing: 0) { //for feedback
            
            if !feedbackSubmitted {
                
                Text("I am most interested in...")
                    .font(.system(size: ScreenUtil.height * 0.022))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Button(action: {
                    showFeedbackModal=true
                    
                }, label: {
                    Text("Answer")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.06)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                })
                .contentShape(Rectangle()) // This makes the entire frame tappable
                .padding(.top, 10)

                 
                
            } else {
                Text("Feedback Submitted. Thank you!")
                    .foregroundColor(.white)
            }
                
        } //end vstack for feedback
        .frame(width: ScreenUtil.width * 0.7)
        .padding()
        .background( //switch background gradient after submitting feedback
            feedbackSubmitted ?
            AnyView (
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight2").opacity(0.6)]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            :
            AnyView (
                RadialGradient(
                    gradient: Gradient(colors: [Color("GradientDark2"), Color("GradientLight")]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 240
                )
            )
        )
        .cornerRadius(10)
    }
    
    private var feedbackModal: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showFeedbackModal = false
                }
            feedbackSelector
        }
    }
    
    private var feedbackSelector: some View {
        
        VStack(spacing: 0) {
            
            if !feedbackSubmitted {
                
                Text("I am most interested in: ")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }, label: {
                     
                        Text(option)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(selectedOption == option ? Color.green.opacity(0.5) : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)
                            
                        
                    })
                    .padding(.vertical, 5)
                }
                
                //Submit feedback button
                Button(action: {
                    feedbackSubmitted = true
                    showFeedbackModal=false
                }, label: {
                    Text("Submit")
                        .foregroundColor(.white)
                        .frame(width: ScreenUtil.width * 0.4, height: ScreenUtil.height * 0.06)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                })
                .contentShape(Rectangle()) // This makes the entire frame tappable
                .padding(.top, 10)
                .disabled(selectedOption == nil) // Disable the button until an option is selected
                
            } else {
                Text("Feedback Submitted. Thank you")
                    .foregroundColor(.white)
            }
            
            
            
        } //end vstack for feedback
        .frame(width: ScreenUtil.width * 0.75)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(10)
    }
    
    private var bugreportButton: some View {
        Button(action: {
            showBugReportModal=true
        }, label: {
            HStack {
                Text("Bug report")
                    .foregroundColor(.white)
                
                Image(systemName: "ant")
                    .foregroundColor(.green)
            }
            .frame(width: ScreenUtil.width * 0.7)
            .padding()
            .background(Color("GradientLight"))
            .cornerRadius(10)
            
                
        })
        .contentShape(Rectangle()) // This makes the entire frame tappable

    }
    
    private var bugReportModal: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showFeedbackModal = false
                }
            bugReportEntry
        }
    }
    
    private var bugReportEntry: some View {
        VStack {
            
            Text("Describe the bug below. Thanks for helping us improve the platform!")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            //custom text field for clear background, text wrapping, and scrollable overflow
            ZStack(alignment: .topLeading) {
                if bugReportText.isEmpty {
                    Text("Description")
                        .foregroundColor(Color.gray)
                        .padding(.top, 15)
                        .padding(.leading, 15)
                }
                
                TextEditor(text: $bugReportText)
                    .autocapitalization(.none)
                    .padding(10)
                    .scrollContentBackground(.hidden) //opaque background
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(Color.white)
                    .frame(height: 100, alignment: .leading)
                    .cornerRadius(10)
            }
            
            HStack(spacing: ScreenUtil.width * 0.04) {
                
                Button(action: {
                    bugReportText = ""
                    showBugReportModal.toggle()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .frame(width: ScreenUtil.width * 0.2, height: 50)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(30)
                })
                .contentShape(Rectangle()) // This makes the entire frame tappable
                .padding(.top, 10)
                
                Button(action: {
                    // Check if feedback text is not empty
                    if !bugReportText.isEmpty {
                        // Username is currently "Anonymous"
                        /*
                        feedbackService.sendFeedback(username: username, feedbackText: bugReportText)
                        */
                        bugReportText = ""
                        showBugReportModal.toggle()
                    } else {
                        print("Report cannot be empty.")
                    }
                    
                }, label: {
                    Text("Submit")
                        .foregroundColor(.white)
                        .frame(width: ScreenUtil.width * 0.4, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                })
                .contentShape(Rectangle()) // This makes the entire frame tappable
                .padding(.top, 10)
            }
            
        } //end vstack for bug report entry
        .frame(width: ScreenUtil.width * 0.75)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight"), Color("GradientDark")]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(15)
    }

}

// MARK: - Previews
struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView<MockAPIService>(apiService: MockAPIService(), showDropDown: .constant(true), selectedFeed: .constant(.following))
    }
}

