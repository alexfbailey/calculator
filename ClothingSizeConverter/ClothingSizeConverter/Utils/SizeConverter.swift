import Foundation

/// Pure, stateless size conversion engine.
/// All methods are static and side-effect free.
enum SizeConverter {

    /// Convert a numeric size from one region to another.
    /// Returns nil if the input size is not in the source region's table.
    /// Tolerance for floating-point comparison (IEEE 754 safe).
    private static let epsilon: Double = 0.001

    static func convert(
        value: Double,
        from source: SizeRegion,
        to target: SizeRegion,
        gender: Gender,
        category: ClothingCategory
    ) -> Double? {
        guard let table = SizeData.table(for: gender, category: category),
              let sourceArray = table[source],
              let targetArray = table[target],
              let index = sourceArray.firstIndex(where: { abs($0 - value) < epsilon }),
              index < targetArray.count else {
            return nil
        }
        return targetArray[index]
    }

    /// All valid numeric sizes for a region/gender/category.
    static func availableSizes(
        for region: SizeRegion,
        gender: Gender,
        category: ClothingCategory
    ) -> [Double] {
        guard let table = SizeData.table(for: gender, category: category),
              let sizes = table[region] else {
            return []
        }
        return sizes
    }

    /// Map a letter size to its numeric value for a given region.
    static func numericSize(
        for letter: LetterSize,
        region: SizeRegion,
        gender: Gender,
        category: ClothingCategory
    ) -> Double? {
        let indexMap = gender == .women
            ? SizeData.womenLetterIndex
            : SizeData.menLetterIndex

        guard let index = indexMap[letter] else { return nil }
        let sizes = availableSizes(for: region, gender: gender, category: category)
        guard index < sizes.count else { return nil }
        return sizes[index]
    }

    /// Format a Double for display: 38.0 -> "38", 7.5 -> "7.5"
    static func formatSize(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.1f", value)
    }

}
