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
    
    @State private var containerOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var dragStartTime: Date?

    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        if isLandscape {
            TimelineView(store: store)
        } else {
            GeometryReader { geo in
                VStack(spacing: 0) {

                    FieldView(
                        store: store,
                        displayMode: displayMode,
                        filterMode: filterMode
                    )
                    .frame(height: geo.size.height)

                    CreateItemView(
                        store: store,
                        onDone: { closeCreate(height: geo.size.height) }
                    )
                    .frame(height: geo.size.height)
                }
                .offset(y: containerOffset + dragOffset)
                .gesture(verticalIntentGesture(height: geo.size.height))
            }
        }
    }
        
    func verticalIntentGesture(height: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let y = value.translation.height
                let createDragThreshold: CGFloat = 80

                // Only allow dragging up when on Field
                if containerOffset == 0 && y < -createDragThreshold {
                    dragOffset = y
                }

                // Only allow dragging down when on Create
                if containerOffset == -height && y > 0 {
                    dragOffset = y
                }

                if dragStartTime == nil {
                    dragStartTime = Date()
                }
            }

            .onEnded { value in
                let vertical = value.translation.height
                let predicted = value.predictedEndTranslation.height

                let total = vertical + (predicted - vertical) * 0.3

                // How long the drag lasted
                let duration = Date().timeIntervalSince(dragStartTime ?? Date())
                dragStartTime = nil

                // Approx velocity
                let speed = abs(predicted - vertical) / max(duration, 0.01)

                // FAST gestures → filters only
                if speed > 900 {
                    if total < -40 {
                        toggleAvoids()
                    } else if total > 40 {
                        toggleDos()
                    }
                    return
                }

                // SLOW + DEEP pull → create
                if duration > 0.35 && speed < 600 && total < -120 {
                    openCreate(height: height)
                    return
                }

                // Medium drags → filter
                if total < -40 {
                    toggleAvoids()
                    return
                }

                if total > 40 {
                    toggleDos()
                    return
                }

                // Default: snap back
                resetDrag()
            }
    }

    
    func toggleAvoids() {
        if filterMode == .dosOnly {
            filterMode = .all
        } else {
            filterMode = .avoidsOnly
        }
        resetDrag()
    }
    
    func toggleDos() {
        if filterMode == .avoidsOnly {
            filterMode = .all
        } else {
            filterMode = .dosOnly
        }
        resetDrag()
    }

    func openCreate(height: CGFloat) {
        withAnimation(.spring()) {
            containerOffset = -height
            dragOffset = 0
            appMode = .create
        }
        triggerDismissHaptic()
    }

    func closeCreate(height: CGFloat) {
        resetDrag()
        appMode = .field
        triggerDismissHaptic()
    }

    func resetDrag() {
        withAnimation(.interpolatingSpring(
            stiffness: 280,
            damping: 28
        )) {
            containerOffset = 0
            dragOffset = 0

        }
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

