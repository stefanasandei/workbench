//
//  ContentView.swift
//  Workbench
//
//  Created by Asandei Stefan on 11.06.2024.
//

import SwiftUI

var listItems = ["Item 1", "Item 2", "Item 3", "Item 4"]

struct ContentView: View
{
    @State var select: String? = "Item 1"
    
    var body: some View
    {
        VStack
        {
            NavigationView()
            {
                List(selection: $select)
                {
                    ForEach((0..<listItems.count), id: \.self)
                    {index in
                        NavigationLink(listItems[index])
                        {
                            Text(listItems[index])
                                .padding(.vertical, 2.0)
                        }
                    }
                    Spacer()
                }
                .frame(width:160)
                .listStyle(SidebarListStyle())
            
                Text("Choose something")
            }
            .navigationTitle("My Title")
        }
    }
}

#Preview {
    ContentView()
}
