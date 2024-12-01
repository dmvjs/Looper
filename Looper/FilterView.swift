//
//  FilterView.swift
//  Looper
//
//  Created by Kirk Elliott on 12/1/24.
//


import SwiftUI

/// A view for filtering samples by Key.
struct FilterView: View {
    @Binding var selectedKeys: Set<Int>
    
    let availableKeys = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(availableKeys, id: \.self) { key in
                    Button(action: {
                        if selectedKeys.contains(key) {
                            selectedKeys.remove(key)
                        } else {
                            selectedKeys.insert(key)
                        }
                    }) {
                        Text("Key \(key)")
                            .padding(8)
                            .background(selectedKeys.contains(key) ? Color.blue : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedKeys: .constant(Set([1, 2])))
    }
}
