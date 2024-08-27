//
//  ContentView.swift
//  api test
//
//  Created by Christian Wyglendowski on 8/27/24.
//

import SwiftUI
import ConvexMobile
import Combine

let client = ConvexClient(deploymentUrl: "https://prestigious-dolphin-371.convex.cloud")

struct ContentView: View {
    @State private var messages: [Task] = []
    @State private var cancellationHandle: Set<AnyCancellable> = []
    var body: some View {
        return List {
            ForEach(messages) { message in
                return Text(message.text)
            }
        }.task {
            try! await client.subscribe(name: "tasks:get")
                .replaceError(with: [Task(id: "id", isCompleted: false, text: "error")])
                .receive(on: DispatchQueue.main)
                .assign(to: \.messages, on: self)
                .store(in: &cancellationHandle)
        }
        .padding()
    }
}

struct Task : Identifiable, Decodable {
    let id: String
    let isCompleted: Bool
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isCompleted
        case text
    }
}

#Preview {
    ContentView()
}
