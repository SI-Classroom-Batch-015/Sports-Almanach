//
//  ContentView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 04.09.24.
//

import SwiftUI

struct ContentView: View {
    
    // Initial wird die HomeView angezeigt
    @State private var displayedTab: CustomTabBar.Tab = .home
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        ZStack {
            Image("hintergrund")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            NavigationStack {
                CustomTabBar(
                    displayedTab: $displayedTab,
                    previousTab: displayedTab
                )
                .environmentObject(userViewModel)
                .environmentObject(eventViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
        .environmentObject(EventViewModel())
}
