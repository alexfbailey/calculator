import SwiftUI

struct RegionPickerView: View {
    let title: String
    @Binding var selected: SizeRegion
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(SizeRegion.allCases) { region in
                Button {
                    selected = region
                    dismiss()
                } label: {
                    HStack(spacing: 14) {
                        Text(region.flag)
                            .font(.title2)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(region.rawValue)
                                .font(.body.weight(.medium))
                                .foregroundStyle(.primary)
                            Text(region.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if region == selected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .accessibilityLabel("\(region.displayName)\(region == selected ? ", selected" : "")")
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
