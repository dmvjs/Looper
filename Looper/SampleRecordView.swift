import SwiftUI

struct SampleRecordView: View {
    let sample: Sample
    let onSelect: () -> Void

    var body: some View {
        HStack(spacing: 12) { // Reduced spacing for a compact, sleek design
            Rectangle()
                .fill(keyColor(sample.key).opacity(0.9))
                .frame(width: 4) // Slim key color indicator
            Text("\(sample.artist) - \(sample.title)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer()
            Text("Key \(sample.key)")
                .font(.system(size: 12, weight: .medium))
                .padding(4)
                .background(keyColor(sample.key).opacity(0.8))
                .cornerRadius(4)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.6))
        .cornerRadius(8)
        .onTapGesture {
            onSelect()
        }
    }

    private func keyColor(_ key: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .teal, .cyan, .mint, .gray]
        return colors[(key - 1) % colors.count]
    }
}
