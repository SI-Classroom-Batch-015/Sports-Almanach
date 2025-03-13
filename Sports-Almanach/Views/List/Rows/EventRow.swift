//
//  EventRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    @EnvironmentObject var eventViewModel: EventViewModel
    var showNavigationLink: Bool = true  // Flexible Verwendung
    
    var body: some View {
        let rowContent = VStack(alignment: .leading) {
            AsyncImage(url: URL(string: event.image)) { image in
                image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 162)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(height: 32)
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
            }
            
            Spacer().frame(height: 8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(eventNameShort(event.name, limit: 34))
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Text("\(eventViewModel.formattedDate(for: event)) um \(eventViewModel.formattedTime(for: event))")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                Spacer()
                
                let status = EventStatus(rawValue: event.statusString) ?? .unknown
                Text(status.currentStatusGerman)
                    .font(.subheadline)
                    .padding(6)
                    .background(status.color)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 1)
        )
        .padding(.vertical, 8)
        
        // Bedingte NavigationLink basierend auf showNavigationLink
        if showNavigationLink {
            NavigationLink(destination: EventDetailView(event: event)) {
                rowContent
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button {
                    eventViewModel.addToSelectedtEvents(event)
                } label: {
                    Label("Zur Wette", systemImage: "plus.circle.fill")
                }
                .tint(.green)
            }
        } else {
            rowContent
        }
    }
    
    // Kürzen des Eventnamens
    private func eventNameShort(_ name: String, limit: Int) -> String {
        if name.count > limit {
            let index = name.index(name.startIndex, offsetBy: limit)
            return String(name[..<index]) + "..."
        }
        return name
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    let eventViewModel = EventViewModel()
    return EventRow(event: mockEvent)
        .environmentObject(eventViewModel)
        .padding()
}
