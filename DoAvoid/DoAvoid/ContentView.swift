//
//  ContentView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/30/26.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

enum AppMode {
    case field          // normal portrait
    case create         // swipe-right input
}

enum DisplayMode: CaseIterable {
    case minimal        // no badges
    case withBadges     // default
    // future: .diagnostic, .debug, etc.
}

enum FilterMode {
    case all
    case dosOnly
    case avoidsOnly
}

struct ContentView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @StateObject private var store = DoAvoidStore()
    
    @State private var filterMode: FilterMode = .all
    @State private var appMode: AppMode = .field
    @State private var displayMode: DisplayMode = .withBadges
    
    @State private var fieldOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0

    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        if isLandscape {
            TimelineView(store: store)
        } else {
            ZStack {
                // Bottom layer (always there)
                CreateItemView(
                    store: store,
                    onDone: closeCreate
                )

                // Top layer (moves)
                FieldView(
                    store: store,
                    displayMode: displayMode,
                    filterMode: filterMode
                )
                .offset(y: fieldOffset + dragOffset)
                .gesture(verticalIntentGesture)
            }
        }
    }
        
    var verticalIntentGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let y = value.translation.height

                // Only drag upward
                if y < 0 {
                    dragOffset = y
                }
            }

            .onEnded { value in
                let vertical = value.translation.height
                let predicted = value.predictedEndTranslation.height

                let total = vertical + (predicted - vertical) * 0.3
                let speed = abs(predicted - vertical)

                dragOffset = 0

                // Fast flicks → filters
                if speed > 120 {
                    if total < 0 {
                        toggleAvoids()
                    } else if total > 0 {
                        toggleDos()
                    }
                    return
                }

                // Slow big pull → open sheet
                if total < -120 {
                    openCreate()
                    return
                }

                // Otherwise snap closed
                closeCreate()
            }
    }

    
    func toggleAvoids() {
        if filterMode == .dosOnly {
            filterMode = .all
        } else {
            filterMode = .avoidsOnly
        }
    }
    
    func toggleDos() {
        if filterMode == .avoidsOnly {
            filterMode = .all
        } else {
            filterMode = .dosOnly
        }
    }

    func openCreate() {
        fieldOffset = -UIScreen.main.bounds.height
        appMode = .create
        triggerDismissHaptic()
    }

    func closeCreate() {
        fieldOffset = 0
        appMode = .field
    }

    func triggerDismissHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

