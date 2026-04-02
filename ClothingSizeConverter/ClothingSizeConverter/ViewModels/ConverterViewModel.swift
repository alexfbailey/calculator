import SwiftUI
import Observation

/// Main view model for the converter screen.
/// Manages all user state: selections, input, and computed conversion result.
@Observable
@MainActor
final class ConverterViewModel {

    // MARK: - UserDefaults Keys

    static let fromRegionKey = "fromRegion"
    static let toRegionKey = "toRegion"

    // MARK: - User Selections

    var gender: Gender = .women
    var category: ClothingCategory = .dress
    var fromRegion: SizeRegion = .usCA
    var toRegion: SizeRegion = .uk
    var cupSize: CupSize = .a
    var selectedLetter: LetterSize?

    // MARK: - Input

    var inputString: String = ""

    // MARK: - Computed

    var convertedResult: String {
        guard let inputValue = Double(inputString),
              let result = SizeConverter.convert(
                  value: inputValue,
                  from: fromRegion,
                  to: toRegion,
                  gender: gender,
                  category: category
              ) else {
            return "\u{2014}"
        }
        let formatted = SizeConverter.formatSize(result)
        return category.hasCupSize ? "\(formatted)\(cupSize.rawValue)" : formatted
    }

    var inputDisplay: String {
        guard !inputString.isEmpty else { return "\u{2014}" }
        return category.hasCupSize ? "\(inputString)\(cupSize.rawValue)" : inputString
    }

    var filteredCategories: [ClothingCategory] {
        ClothingCategory.allCases.filter { $0.availableFor.contains(gender) }
    }

    var showDecimalKey: Bool { category.hasDecimalSizes }
    var showCupPicker: Bool { category.hasCupSize }
    var showLetterPicker: Bool { category.hasLetterSizes }

    // MARK: - Keypad Actions

    func handleNumber(_ digit: String) {
        guard digit.count == 1, digit.first?.isNumber == true else { return }

        if inputString == "0" && digit != "0" {
            inputString = digit
            return
        }
        if inputString == "0" && digit == "0" { return }

        let digitCount = inputString.filter(\.isNumber).count
        guard digitCount < 4 else { return }

        if inputString.contains(".") {
            let afterDot = inputString.split(separator: ".", maxSplits: 1)
            if afterDot.count > 1, afterDot[1].count >= 1 { return }
        }

        inputString += digit
    }

    func handleDot() {
        guard category.hasDecimalSizes, !inputString.contains(".") else { return }
        if inputString.isEmpty { inputString = "0" }
        inputString += "."
    }

    func handleClear() {
        resetInput()
    }

    func handleBackspace() {
        guard !inputString.isEmpty else { return }
        inputString = String(inputString.dropLast())
    }

    // MARK: - Selection Actions

    func setGender(_ newGender: Gender) {
        gender = newGender
        if !category.availableFor.contains(gender) {
            category = filteredCategories.first ?? .top
        }
        resetInput()
    }

    func setCategory(_ newCategory: ClothingCategory) {
        category = newCategory
        if inputString.hasSuffix(".") {
            inputString = String(inputString.dropLast())
        }
        resetInput()
    }

    func selectLetter(_ letter: LetterSize) {
        selectedLetter = letter
        guard let value = SizeConverter.numericSize(
            for: letter, region: fromRegion, gender: gender, category: category
        ) else { return }
        inputString = SizeConverter.formatSize(value)
    }

    func swapRegions() {
        swap(&fromRegion, &toRegion)
        resetInput()
    }

    // MARK: - Persistence

    func loadDefaults() {
        if let raw = UserDefaults.standard.string(forKey: Self.fromRegionKey),
           let region = SizeRegion(rawValue: raw) {
            fromRegion = region
        }
        if let raw = UserDefaults.standard.string(forKey: Self.toRegionKey),
           let region = SizeRegion(rawValue: raw) {
            toRegion = region
        }
    }

    func saveDefaults() {
        UserDefaults.standard.set(fromRegion.rawValue, forKey: Self.fromRegionKey)
        UserDefaults.standard.set(toRegion.rawValue, forKey: Self.toRegionKey)
    }

    func clearAllData() {
        [Self.fromRegionKey, Self.toRegionKey].forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
        gender = .women
        category = .dress
        fromRegion = .usCA
        toRegion = .uk
        cupSize = .a
        selectedLetter = nil
        inputString = ""
    }

    // MARK: - Private

    private func resetInput() {
        inputString = ""
        selectedLetter = nil
    }
}
