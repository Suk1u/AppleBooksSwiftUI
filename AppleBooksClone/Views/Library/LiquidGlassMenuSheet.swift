import SwiftUI

// MARK: - 悬浮液态玻璃弹出菜单组件 (WWDC25 Native Liquid Glass Sheet)

public struct LiquidGlassMenuSheet: View {
    @Binding public var isPresented: Bool
    @Binding public var viewMode: ViewMode
    @Binding public var selectedSort: SortOption
    public var onSelectMode: () -> Void
    public var onRemoveDownloads: () -> Void

    public var body: some View {
        GlassEffectContainer {
            VStack(alignment: .leading, spacing: 0) {
                // 选择功能项
                Button(action: {
                    isPresented = false
                    onSelectMode()
                }) {
                    HStack(spacing: 14) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 18))
                        Text("选择")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                Divider()
                    .padding(.horizontal, 16)

                // 视图模式：网格
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                        viewMode = .grid
                    }
                    isPresented = false
                }) {
                    HStack(spacing: 14) {
                        if viewMode == .grid {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 16)
                        } else {
                            Spacer().frame(width: 16)
                        }

                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 18))
                        Text("网格")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                // 视图模式：列表
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                        viewMode = .list
                    }
                    isPresented = false
                }) {
                    HStack(spacing: 14) {
                        if viewMode == .list {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 16)
                        } else {
                            Spacer().frame(width: 16)
                        }

                        Image(systemName: "list.bullet")
                            .font(.system(size: 18))
                        Text("列表")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                Divider()
                    .padding(.horizontal, 16)

                // 排序规则标题
                Text("排序方式...")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 4)

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
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(width: 16)
                            } else {
                                Spacer().frame(width: 16)
                            }

                            Text(sort.rawValue)
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .frame(height: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.glass)
                }

                Divider()
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                // 移除下载
                Button(action: {
                    isPresented = false
                    onRemoveDownloads()
                }) {
                    HStack(spacing: 14) {
                        Image(systemName: "trash")
                            .font(.system(size: 17))
                        Text("移除下载")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)
            }
            .padding(.vertical, 8)
            .frame(width: 250)
            .glassEffect(
                .regular.interactive(),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
        }
    }
}
