//  Created by cs dev on 4/5/23.
//

import SwiftUI

@main
struct JOYSTIQApp: App {
    
    @StateObject var userSession = UserSession()
    
    
    var body: some Scene {
        
        WindowGroup {
            
            if userSession.isLoggedIn {
            
                AppView().environmentObject(userSession)
                
            } else {
                
                LoginScreenView().environmentObject(userSession)
                
            }
            
            
        }
        
    }
    
}

class UserSession: ObservableObject {
    @Published var isLoggedIn = false
}
