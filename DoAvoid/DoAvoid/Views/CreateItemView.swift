//
//  CreateItemView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation
import SwiftUI

struct CreateItemView: View {
    @ObservedObject var store: DoAvoidStore
    let onDone: () -> Void

    @State private var title: String = ""
    @State private var kind: DoAvoidKind = .do

    var body: some View {
        VStack(spacing: 24) {
            TextField("New item", text: $title)
                .textFieldStyle(.roundedBorder)

            Picker("Type", selection: $kind) {
                Text("Do").tag(DoAvoidKind.do)
                Text("Avoid").tag(DoAvoidKind.avoid)
            }
            .pickerStyle(.segmented)

            Button("Add") {
                store.items.append(
                    DoAvoidItem(title: title, kind: kind)
                )
                onDone()
            }
            .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            
        }
        .padding()
    }
}
