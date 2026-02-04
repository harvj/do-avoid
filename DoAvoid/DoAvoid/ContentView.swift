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
                        }
                    )
                }
            }
            .gesture(horizontalSwipeGesture)
            .onTapGesture {
                filterMode = .all
            }
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
                        appMode = .field
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
