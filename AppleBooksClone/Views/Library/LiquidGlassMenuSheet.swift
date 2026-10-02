import SwiftUI

public struct LiquidGlassMenuSheet: View {
    @Binding public var isPresented: Bool
    @Binding public var viewMode: ViewMode
    @Binding public var selectedSort: SortOption
    public var onSelectMode: () -> Void
    public var onRemoveDownloads: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 选择
            Button(action: {
                isPresented = false
                onSelectMode()
            }) {
                HStack(spacing: 14) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 19, weight: .regular))
                    Text("选择")
                        .font(.system(size: 17, weight: .regular))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.12))
                .padding(.horizontal, 16)

            // 显示视图模式：网格
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                    viewMode = .grid
                }
                isPresented = false
            }) {
                HStack(spacing: 14) {
                    if viewMode == .grid {
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 16)
                    } else {
                        Spacer().frame(width: 16)
                    }

                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 19, weight: .regular))
                    Text("网格")
                        .font(.system(size: 17, weight: .regular))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // 显示视图模式：列表
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                    viewMode = .list
                }
                isPresented = false
            }) {
                HStack(spacing: 14) {
                    if viewMode == .list {
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 16)
                    } else {
                        Spacer().frame(width: 16)
                    }

                    Image(systemName: "list.bullet")
                        .font(.system(size: 19, weight: .regular))
                    Text("列表")
                        .font(.system(size: 17, weight: .regular))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.12))
                .padding(.horizontal, 16)

            // 排序方式 Section
            Text("排序方式...")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.45))
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 6)

            ForEach(SortOption.allCases) { sort in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                        selectedSort = sort
                    }
                    isPresented = false
                }) {
                    HStack(spacing: 14) {
                        if selectedSort == sort {
                            Image(systemName: "checkmark")
                                .font(.system(size: 15, weight: .bold))
                                .frame(width: 16)
                        } else {
                            Spacer().frame(width: 16)
                        }

                        Text(sort.rawValue)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            Divider()
                .background(Color.white.opacity(0.12))
                .padding(.horizontal, 16)
                .padding(.top, 6)

            // 移除下载
            Button(action: {
                isPresented = false
                onRemoveDownloads()
            }) {
                HStack(spacing: 14) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .regular))
                    Text("移除下载")
                        .font(.system(size: 17, weight: .regular))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .frame(height: 52)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .frame(width: 250)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(white: 0.16).opacity(0.85))
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.45), location: 0.0),
                                .init(color: Color.white.opacity(0.12), location: 0.4),
                                .init(color: Color.white.opacity(0.25), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.45), radius: 25, x: 0, y: 14)
    }
}
