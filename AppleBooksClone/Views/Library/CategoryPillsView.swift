import SwiftUI

public struct CategoryPillsView: View {
    @Binding public var selectedCategory: BookCategory

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BookCategory.allCases) { category in
                    let isSelected = selectedCategory == category

                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category.rawValue)
                            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(isSelected ? .white : .primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.orange : Color(.systemGray6))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }
}
