//
//  HomeTabViewModel.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/23/23.
//

import Foundation

class HomeTabViewModel: ObservableObject {
    @Published var isInitialized: Bool = false
    @Published var posts: [Post] = []
}
