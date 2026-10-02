import SwiftUI

// MARK: - 竖向流体玻璃进度滑杆 (WWDC25 Native Liquid Glass Vertical Scrubber)

public struct VerticalPageScrubber: View {
    @Binding public var currentPage: Int
    public let totalPages: Int
    @State private var isDragging: Bool = false

    public init(currentPage: Binding<Int>, totalPages: Int) {
        self._currentPage = currentPage
        self.totalPages = max(totalPages, 1)
    }

    public var body: some View {
        GlassEffectContainer {
            GeometryReader { geometry in
                let height = geometry.size.height
                let progress = CGFloat(currentPage - 1) / CGFloat(max(totalPages - 1, 1))
                let thumbY = min(max(progress * (height - 36), 0), height - 36)

                ZStack(alignment: .top) {
                    // 滑槽玻璃底槽
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.08))

                    // 拖拽滑块玻璃药丸
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.85))
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
            .frame(width: 30, height: 200)
            .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
        }
    }
}
