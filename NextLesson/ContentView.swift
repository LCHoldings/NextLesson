//
//  ContentView.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Button") {
                print("hola")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
