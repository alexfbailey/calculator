import SwiftUI

struct CategoryPickerView: View {
    let gender: Gender
    let categories: [ClothingCategory]
    let selected: ClothingCategory
    let onSelect: (ClothingCategory) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var filtered: [ClothingCategory] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { cat in
                Button {
                    onSelect(cat)
                    dismiss()
                } label: {
                    HStack {
                        Text(cat.rawValue)
                            .foregroundStyle(.primary)
                            .font(.body.weight(.medium))
                        Spacer()
                        if cat == selected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .accessibilityLabel("\(cat.rawValue)\(cat == selected ? ", selected" : "")")
            }
            .searchable(text: $searchText, prompt: "Search categories")
            .navigationTitle("\(gender.rawValue)'s")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
