import Foundation

// MARK: - Size Region

enum SizeRegion: String, CaseIterable, Identifiable, Sendable {
    case usCA = "US/CA"
    case uk = "UK"
    case eu = "EU"
    case au = "AU"
    case it = "IT"
    case fr = "FR"
    case de = "DE"
    case jp = "JP"
    case cn = "CN"
    case kr = "KR"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .usCA: return "US / Canada"
        case .uk:   return "United Kingdom"
        case .eu:   return "Europe"
        case .au:   return "Australia"
        case .it:   return "Italy"
        case .fr:   return "France"
        case .de:   return "Germany"
        case .jp:   return "Japan"
        case .cn:   return "China"
        case .kr:   return "South Korea"
        }
    }

    var flag: String {
        switch self {
        case .usCA: return "\u{1F1FA}\u{1F1F8}"
        case .uk:   return "\u{1F1EC}\u{1F1E7}"
        case .eu:   return "\u{1F1EA}\u{1F1FA}"
        case .au:   return "\u{1F1E6}\u{1F1FA}"
        case .it:   return "\u{1F1EE}\u{1F1F9}"
        case .fr:   return "\u{1F1EB}\u{1F1F7}"
        case .de:   return "\u{1F1E9}\u{1F1EA}"
        case .jp:   return "\u{1F1EF}\u{1F1F5}"
        case .cn:   return "\u{1F1E8}\u{1F1F3}"
        case .kr:   return "\u{1F1F0}\u{1F1F7}"
        }
    }
}

// MARK: - Gender

enum Gender: String, CaseIterable, Identifiable, Sendable {
    case women = "Women"
    case men = "Men"

    var id: String { rawValue }
}

// MARK: - Clothing Category

enum ClothingCategory: String, CaseIterable, Identifiable, Sendable {
    case dress = "Dress"
    case top = "Top"
    case pants = "Pants"
    case jeans = "Jeans"
    case shoes = "Shoes"
    case bra = "Bra"
    case jacket = "Jacket"
    case skirt = "Skirt"
    case swimwear = "Swimwear"
    case shirt = "Shirt"
    case shorts = "Shorts"
    case suit = "Suit"

    var id: String { rawValue }

    /// Which genders this category is available for.
    var availableFor: Set<Gender> {
        switch self {
        case .bra, .skirt, .dress:
            return [.women]
        case .shirt, .shorts, .suit:
            return [.men]
        case .top, .pants, .jeans, .shoes, .jacket, .swimwear:
            return [.women, .men]
        }
    }

    /// Whether this category supports letter sizes (XS, S, M, L, etc.)
    var hasLetterSizes: Bool {
        switch self {
        case .jeans, .shoes, .bra, .shirt:
            return false
        default:
            return true
        }
    }

    /// Whether this category uses decimal sizes (e.g., 7.5 for shoes)
    var hasDecimalSizes: Bool {
        switch self {
        case .shoes, .shirt:
            return true
        default:
            return false
        }
    }

    /// Whether this category requires a cup size selector (bras only)
    var hasCupSize: Bool {
        self == .bra
    }

    /// SF Symbol name for the category
    var systemImage: String {
        switch self {
        case .shoes:    return "shoeprints.fill"
        case .bra:      return "tshirt.fill"
        case .jacket:   return "cloud.snow.fill"
        case .suit:     return "person.fill"
        default:        return "tshirt.fill"
        }
    }
}

// MARK: - Letter Size

enum LetterSize: String, CaseIterable, Identifiable, Sendable {
    case xxxs = "XXXS"
    case xxs = "XXS"
    case xs = "XS"
    case s = "S"
    case m = "M"
    case l = "L"
    case xl = "XL"
    case xxl = "XXL"
    case xxxl = "3XL"
    case xxxxl = "4XL"

    var id: String { rawValue }
}

// MARK: - Cup Size

enum CupSize: String, CaseIterable, Identifiable, Sendable {
    case aa = "AA"
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case dd = "DD"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"

    var id: String { rawValue }
}
