import SwiftUI

struct ContentView: View {
    @State private var vm = ConverterViewModel()
    @State private var showCategoryPicker = false
    @State private var showFromRegion = false
    @State private var showToRegion = false
    @State private var showCupSheet = false
    @State private var showLetterSheet = false
    @State private var showMenu = false
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Theme Colors

    private var bg: Color {
        colorScheme == .dark
            ? Color(red: 0.08, green: 0.08, blue: 0.10)
            : Color(red: 0.56, green: 0.79, blue: 0.84)
    }
    private var keyBg: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.10)
            : Color.white.opacity(0.55)
    }
    private var keyFnBg: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.16)
            : Color.white.opacity(0.75)
    }
    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(white: 0.1)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.65) : Color(white: 0.3)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    genderPicker
                    categoryButton
                    Spacer(minLength: 8)
                    resultDisplay
                    Spacer(minLength: 8)
                    sizeOptionButton
                    keypad
                }
                .padding(.bottom, 4)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showMenu = true } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(textPrimary)
                    }
                    .accessibilityLabel("Menu")
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear { vm.loadDefaults() }
        .onChange(of: vm.fromRegion) { old, new in
            if new == vm.toRegion { vm.toRegion = old }
            vm.saveDefaults()
        }
        .onChange(of: vm.toRegion) { old, new in
            if new == vm.fromRegion { vm.fromRegion = old }
            vm.saveDefaults()
        }
        .onChange(of: vm.convertedResult) { _, newValue in
            let announcement = newValue == "\u{2014}" ? "No result" : "Result: \(newValue)"
            UIAccessibility.post(notification: .announcement, argument: announcement)
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategoryPickerView(
                gender: vm.gender,
                categories: vm.filteredCategories,
                selected: vm.category
            ) { vm.setCategory($0) }
        }
        .sheet(isPresented: $showFromRegion) {
            RegionPickerView(title: "Convert From", selected: $vm.fromRegion)
        }
        .sheet(isPresented: $showToRegion) {
            RegionPickerView(title: "Convert To", selected: $vm.toRegion)
        }
        .sheet(isPresented: $showCupSheet) { cupSheet }
        .sheet(isPresented: $showLetterSheet) { letterSheet }
        .sheet(isPresented: $showMenu) {
            MenuView(onClearAll: { vm.clearAllData() })
        }
    }

    // MARK: - Gender Picker

    private var genderPicker: some View {
        Picker("Gender", selection: Binding(
            get: { vm.gender },
            set: { vm.setGender($0) }
        )) {
            ForEach(Gender.allCases) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 24)
        .padding(.top, 4)
        .accessibilityLabel("Gender selection")
    }

    // MARK: - Category

    private var categoryButton: some View {
        Button { showCategoryPicker = true } label: {
            HStack(spacing: 5) {
                Text(vm.category.rawValue)
                    .font(.title3.weight(.semibold))
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.medium))
                    .opacity(0.5)
            }
            .foregroundStyle(textPrimary)
        }
        .padding(.top, 6)
        .accessibilityLabel("Category: \(vm.category.rawValue). Double tap to change.")
    }

    // MARK: - Result Display

    private var resultDisplay: some View {
        VStack(spacing: 12) {
            sizeRow(
                value: vm.convertedResult,
                region: vm.toRegion,
                color: textSecondary,
                onRegionTap: { showToRegion = true },
                accessLabel: "Converted size"
            )

            HStack(spacing: 12) {
                Button { vm.swapRegions() } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.body.weight(.medium))
                        .foregroundStyle(textPrimary)
                }
                .accessibilityLabel("Swap convert from and to regions")
                Rectangle()
                    .fill(textPrimary.opacity(0.15))
                    .frame(height: 0.5)
            }
            .padding(.horizontal, 24)

            sizeRow(
                value: vm.inputDisplay,
                region: vm.fromRegion,
                color: textPrimary,
                onRegionTap: { showFromRegion = true },
                accessLabel: "Input size"
            )
        }
    }

    private func sizeRow(
        value: String,
        region: SizeRegion,
        color: Color,
        onRegionTap: @escaping () -> Void,
        accessLabel: String
    ) -> some View {
        HStack(alignment: .lastTextBaseline) {
            Spacer()
            Text(value)
                .font(.system(size: fontSize(for: value), weight: .light))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .accessibilityLabel("\(accessLabel): \(value)")

            Button(action: onRegionTap) {
                HStack(spacing: 3) {
                    Text(region.rawValue).font(.title3)
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .opacity(0.5)
                }
                .foregroundStyle(color)
            }
            .accessibilityLabel("\(region.displayName). Double tap to change.")
        }
        .padding(.horizontal, 24)
    }

    private func fontSize(for text: String) -> CGFloat {
        switch text.count {
        case 0...4: return 64
        case 5...7: return 46
        default: return 34
        }
    }

    // MARK: - Size Option Button

    @ViewBuilder
    private var sizeOptionButton: some View {
        if vm.showCupPicker {
            pillButton("Cup: \(vm.cupSize.rawValue)") { showCupSheet = true }
                .accessibilityLabel("Cup size \(vm.cupSize.rawValue). Double tap to change.")
        } else if vm.showLetterPicker {
            pillButton(vm.selectedLetter?.rawValue ?? "Letter Size") { showLetterSheet = true }
                .accessibilityLabel("Letter size selector. Double tap to pick.")
        }
    }

    private func pillButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .opacity(0.45)
            }
            .frame(width: 264, height: 48)
            .background(keyBg)
            .foregroundStyle(textPrimary)
            .clipShape(Capsule())
        }
        .padding(.bottom, 8)
    }

    // MARK: - Keypad

    private var keypad: some View {
        VStack(spacing: 12) {
            keyRow(["7", "8", "9"])
            keyRow(["4", "5", "6"])
            keyRow(["1", "2", "3"])

            HStack(spacing: 12) {
                if vm.showDecimalKey {
                    keyButton(".", isFunction: true) { vm.handleDot() }
                } else {
                    keyButton("C", isFunction: true) { vm.handleClear() }
                }
                keyButton("0", isFunction: false) { vm.handleNumber("0") }
                Button { vm.handleBackspace() } label: {
                    Image(systemName: "delete.backward")
                        .font(.title2)
                        .frame(width: 80, height: 80)
                        .background(keyFnBg)
                        .foregroundStyle(textPrimary)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Backspace")
                .accessibilityHint("Long press to clear all")
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.6)
                        .onEnded { _ in vm.handleClear() }
                )
            }
        }
        .padding(.horizontal, 12)
    }

    private func keyRow(_ digits: [String]) -> some View {
        HStack(spacing: 12) {
            ForEach(digits, id: \.self) { d in
                keyButton(d, isFunction: false) { vm.handleNumber(d) }
            }
        }
    }

    private func keyButton(_ label: String, isFunction: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: isFunction ? 28 : 32, weight: .regular))
                .frame(width: 80, height: 80)
                .background(isFunction ? keyFnBg : keyBg)
                .foregroundStyle(textPrimary)
                .clipShape(Circle())
        }
        .accessibilityLabel(label == "C" ? "Clear" : label)
    }

    // MARK: - Cup Size Sheet

    private var cupSheet: some View {
        NavigationStack {
            List(CupSize.allCases) { cup in
                Button {
                    vm.cupSize = cup
                    showCupSheet = false
                } label: {
                    HStack {
                        Text(cup.rawValue)
                            .foregroundStyle(.primary)
                            .font(.body.weight(.medium))
                        Spacer()
                        if cup == vm.cupSize {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
            }
            .navigationTitle("Cup Size")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showCupSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Letter Size Sheet

    private var letterSheet: some View {
        NavigationStack {
            List(LetterSize.allCases) { letter in
                Button {
                    vm.selectLetter(letter)
                    showLetterSheet = false
                } label: {
                    HStack {
                        Text(letter.rawValue)
                            .foregroundStyle(.primary)
                            .font(.body.weight(.medium))
                        Spacer()
                        if letter == vm.selectedLetter {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
            }
            .navigationTitle("Letter Size")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showLetterSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    ContentView()
}
