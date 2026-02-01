//
//  ContentView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/30/26.
//

import SwiftUI

enum AppMode {
    case field          // normal portrait
    case create         // swipe-right input
}

enum DisplayMode: CaseIterable {
    case minimal        // no badges
    case withBadges     // default
    // future: .diagnostic, .debug, etc.
}

struct ContentView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @StateObject private var store = DoAvoidStore()
    
    @State private var appMode: AppMode = .field
    @State private var displayMode: DisplayMode = .withBadges

    @State private var isHoldingUpward = false
    @State private var holdTask: Task<Void, Never>? = nil
    
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        if isLandscape {
            TimelineView(store: store)
        } else {
            ZStack {
                switch appMode {
                case .field:
                    FieldView(
                        store: store,
                        displayMode: displayMode
                    )
                    .gesture(scrollUpAndHoldGesture)

                case .create:
                    CreateItemView(
                        store: store,
                        onDone: {
                            appMode = .field
                        }
                    )
                }
            }
            .gesture(horizontalSwipeGesture)
        }
    }
    
    var horizontalSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = abs(value.translation.height)

                // Only react to mostly-horizontal swipes
                guard vertical < 40 else { return }

                if horizontal > 80 {
                    // Swipe right → create
                    appMode = .create
                } else if horizontal < -80 {
                    // Swipe left → cycle display mode
                    cycleDisplayMode()
                }
            }
    }
    
    var scrollUpAndHoldGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                // Only care about upward drag
                guard value.translation.height < -80 else {
                    cancelHold()
                    return
                }

                if !isHoldingUpward {
                    isHoldingUpward = true
                    startHoldTimer()
                }
            }
            .onEnded { _ in
                cancelHold()
            }
    }
    
    func startHoldTimer() {
        holdTask?.cancel()

        holdTask = Task {
            try? await Task.sleep(nanoseconds: 600_000_000) // ~0.6s
            if isHoldingUpward {
                appMode = .create
            }
        }
    }

    func cancelHold() {
        isHoldingUpward = false
        holdTask?.cancel()
        holdTask = nil
    }
    
    func cycleDisplayMode() {
        let all = DisplayMode.allCases
        if let index = all.firstIndex(of: displayMode) {
            displayMode = all[(index + 1) % all.count]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
