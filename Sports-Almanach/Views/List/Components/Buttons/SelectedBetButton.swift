//
//  ButtonRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.10.24.
//

import SwiftUI

struct SelectedBetButton: View {
    var action: () -> Void
    @ObservedObject var eventViewModel: EventViewModel
    var event: Event
    
    var body: some View {
        Button(action: action) {
            Text(eventViewModel.selectedEvents.contains(event) ? "--->>   Bereit zum Wetten   <<---" : "--->>  Hinzufügen zur Wette  <<---")
                .font(.subheadline)
                .foregroundColor(eventViewModel.selectedEvents.contains(event) ? .green : .blue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                    
                )
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    SelectedBetButton(
        action: { print("Button gedrückt!") },
        eventViewModel: EventViewModel(),
        event: MockEvents.events.first!
    )
}
