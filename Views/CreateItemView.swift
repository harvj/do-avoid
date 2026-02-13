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
    @State private var kind: DoAvoidKind = .doItem

    var body: some View {
        VStack(spacing: 16) {
            // Header with title and close button
            ZStack {
                Text("New Item")
                    .font(AppStyle.Fonts.title)

                HStack {
                    Spacer()
                    Button {
                        onDone()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Close")
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Inputs
            TextField(kind == .doItem ? "Do what?" : "Avoid what?", text: $title)
                .fieldBackground()

            Picker("Type", selection: $kind) {
                Text("Do").tag(DoAvoidKind.doItem)
                Text("Avoid").tag(DoAvoidKind.avoidItem)
            }
            .pickerStyle(.segmented)

            Button {
                store.items.append(
                    DoAvoidItem(title: title, kind: kind)
                )
                onDone()
            } label: {
                Text("Add")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)

            Spacer(minLength: 0)
        }
        .padding()
    }
}

