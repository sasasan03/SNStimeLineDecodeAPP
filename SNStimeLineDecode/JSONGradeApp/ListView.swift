//
//  ContentView.swift
//  DecodeExample
//
//  Created by akio0911 on 2024/02/21.
//

import SwiftUI

struct ListView: View {
    @State var members: [Member]?

    var body: some View {
        List {
            if let members {
                ForEach(members, id: \.id, content: { member in
                    switch member.grade {
                    case .bronze:
                        HStack {
                            Text(member.name)
                            Text("bronze")
                        }
                    case .silver:
                        HStack {
                            Text(member.name)
                            Text("silver")
                        }
                    case .gold:
                        HStack {
                            Text(member.name)
                            Text("gold")
                        }
                    case .unknown(name: let name):
//                            Text(name)
                        EmptyView()
                    }
                })
            } else {
                Text("loading...")
            }
        }
        .onAppear {
            do {
                members = try ListClient().fetch()
            } catch {

            }
        }
    }
}

struct SingleView: View {
    @State var member: Member?

    var body: some View {
        VStack {
            if let member {
                Text(member.name)
                switch member.grade {
                case .gold:
                    Button("gold", action: {})
                case .silver:
                    Button("silver", action: {})
                case .bronze:
                    Button("silver", action: {})
                case .unknown(let name):
                    Text(name)
                }
            } else {
                Text("loading...")
            }
        }
        .padding()
        .onAppear {
            do {
                member = try SingleClient().fetch()
            } catch {

            }
        }
    }
}

#Preview {
    ListView()
}
