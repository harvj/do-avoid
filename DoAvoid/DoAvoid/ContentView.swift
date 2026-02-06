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
    
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        if isLandscape {
            TimelineView(store: store)
        } else {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appMode = .field
                        filterMode = .all
                        triggerDismissHaptic()
                    }
                
                switch appMode {
                case .field:
                    FieldView(
                        store: store,
                        displayMode: displayMode,
                        filterMode: filterMode
                    )
                    .gesture(verticalIntentGesture)

                case .create:
                    CreateItemView(
                        store: store,
                        onDone: {
                            appMode = .field
                            triggerDismissHaptic()
                        }
                    )
                }
            }
        }
    }
        
    var verticalIntentGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let vertical = value.translation.height
                let velocity = value.predictedEndTranslation.height - vertical

                // QUICK flicks → filters
                if abs(velocity) > 150 {
                    if velocity < 0 {
                        // quick up
                        if filterMode == .dosOnly {
                            filterMode = .all
                        } else {
                            filterMode = .avoidsOnly
                        }
                    } else {
                        // quick down
                        if filterMode == .avoidsOnly {
                            filterMode = .all
                        } else {
                            filterMode = .dosOnly
                        }
                    }
                    return
                }

                // SLOW pull up + hold → create
                if vertical < -100 {
                    appMode = .create
                }
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

