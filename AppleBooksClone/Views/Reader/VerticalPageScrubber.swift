import SwiftUI

public struct VerticalPageScrubber: View {
    @Binding public var currentPage: Int
    public let totalPages: Int
    @State private var isDragging: Bool = false

    public init(currentPage: Binding<Int>, totalPages: Int) {
        self._currentPage = currentPage
        self.totalPages = max(totalPages, 1)
    }

    public var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let progress = CGFloat(currentPage - 1) / CGFloat(max(totalPages - 1, 1))
            let thumbY = min(max(progress * (height - 36), 0), height - 36)

            ZStack(alignment: .top) {
                // 背景微透液态玻璃滑槽
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.8)
                    )

                // 拖动滑块指示器
                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 36)
                    .offset(y: thumbY)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let clampedY = min(max(value.location.y, 0), height)
                        let newProgress = clampedY / height
                        let page = Int(round(newProgress * CGFloat(totalPages - 1))) + 1
                        currentPage = min(max(page, 1), totalPages)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .frame(width: 32, height: 200)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}
