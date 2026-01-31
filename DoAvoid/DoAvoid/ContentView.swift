//
//  ContentView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/30/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "flame")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hell world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
