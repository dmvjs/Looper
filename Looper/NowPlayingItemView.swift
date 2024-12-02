//
//  NowPlayingItemView.swift
//  Looper
//
//  Created by Kirk Elliott on 12/1/24.
//
import SwiftUI

struct NowPlayingItemView: View {
    let sample: Sample
    @Binding var volume: Float?
    let onRemove: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(sample.title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(sample.artist)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            if let volume = volume {
                Slider(value: Binding(
                    get: { volume },
                    set: { newValue in
                        self.volume = newValue
                    }
                ), in: 0...1)
                    .accentColor(.white)
                    .frame(width: 100)
            }
            Button(action: {
                onRemove()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(10)
    }
}
