import XCTest
@testable import ClothingSizeConverter

final class SizeConverterTests: XCTestCase {

    // MARK: - Women's Standard Conversions

    func testWomenDressUStoUK() {
        let result = SizeConverter.convert(value: 6, from: .usCA, to: .uk, gender: .women, category: .dress)
        XCTAssertEqual(result, 10)
    }

    func testWomenDressUStoEU() {
        let result = SizeConverter.convert(value: 6, from: .usCA, to: .eu, gender: .women, category: .dress)
        XCTAssertEqual(result, 38)
    }

    func testWomenDressEUtoUS() {
        let result = SizeConverter.convert(value: 38, from: .eu, to: .usCA, gender: .women, category: .dress)
        XCTAssertEqual(result, 6)
    }

    // MARK: - Men's Standard Conversions

    func testMenSuitUStoEU() {
        let result = SizeConverter.convert(value: 40, from: .usCA, to: .eu, gender: .men, category: .suit)
        XCTAssertEqual(result, 50)
    }

    func testMenTopUStoJP() {
        let result = SizeConverter.convert(value: 38, from: .usCA, to: .jp, gender: .men, category: .top)
        XCTAssertEqual(result, 5)
    }

    // MARK: - Shoes (Decimal Sizes)

    func testWomenShoesUStoEU() {
        let result = SizeConverter.convert(value: 7, from: .usCA, to: .eu, gender: .women, category: .shoes)
        XCTAssertEqual(result, 37)
    }

    func testWomenShoesHalfSize() {
        let result = SizeConverter.convert(value: 7.5, from: .usCA, to: .eu, gender: .women, category: .shoes)
        XCTAssertEqual(result, 37.5)
    }

    func testMenShoesUStoUK() {
        let result = SizeConverter.convert(value: 10, from: .usCA, to: .uk, gender: .men, category: .shoes)
        XCTAssertEqual(result, 9)
    }

    func testMenShoesSize16() {
        let result = SizeConverter.convert(value: 16, from: .usCA, to: .eu, gender: .men, category: .shoes)
        XCTAssertEqual(result, 49)
    }

    // MARK: - Bra Band

    func testBraBandUStoEU() {
        let result = SizeConverter.convert(value: 34, from: .usCA, to: .eu, gender: .women, category: .bra)
        XCTAssertEqual(result, 75)
    }

    func testBraBandEUtoUS() {
        let result = SizeConverter.convert(value: 75, from: .eu, to: .usCA, gender: .women, category: .bra)
        XCTAssertEqual(result, 34)
    }

    // MARK: - Men's Shirt

    func testMenShirtUStoEU() {
        let result = SizeConverter.convert(value: 15, from: .usCA, to: .eu, gender: .men, category: .shirt)
        XCTAssertEqual(result, 38)
    }

    // MARK: - Jeans

    func testWomenJeansUStoEU() {
        let result = SizeConverter.convert(value: 28, from: .usCA, to: .eu, gender: .women, category: .jeans)
        XCTAssertEqual(result, 36)
    }

    func testMenJeansUStoEU() {
        let result = SizeConverter.convert(value: 32, from: .usCA, to: .eu, gender: .men, category: .jeans)
        XCTAssertEqual(result, 48)
    }

    // MARK: - Round Trip (convert and back)

    func testRoundTripWomenDress() throws {
        let forward = try XCTUnwrap(
            SizeConverter.convert(value: 8, from: .usCA, to: .eu, gender: .women, category: .dress)
        )
        let back = SizeConverter.convert(value: forward, from: .eu, to: .usCA, gender: .women, category: .dress)
        XCTAssertEqual(back, 8)
    }

    func testRoundTripMenShoes() throws {
        let forward = try XCTUnwrap(
            SizeConverter.convert(value: 10, from: .usCA, to: .jp, gender: .men, category: .shoes)
        )
        let back = SizeConverter.convert(value: forward, from: .jp, to: .usCA, gender: .men, category: .shoes)
        XCTAssertEqual(back, 10)
    }

    // MARK: - Invalid Input

    func testInvalidSizeReturnsNil() {
        let result = SizeConverter.convert(value: 999, from: .usCA, to: .uk, gender: .women, category: .dress)
        XCTAssertNil(result)
    }

    func testNegativeSizeNotInTable() {
        let result = SizeConverter.convert(value: -99, from: .usCA, to: .uk, gender: .women, category: .dress)
        XCTAssertNil(result)
    }

    func testMenBraReturnsNil() {
        let result = SizeConverter.convert(value: 34, from: .usCA, to: .uk, gender: .men, category: .bra)
        XCTAssertNil(result)
    }

    func testWomenSuitReturnsNil() {
        let result = SizeConverter.convert(value: 40, from: .usCA, to: .uk, gender: .women, category: .suit)
        XCTAssertNil(result)
    }

    // MARK: - Letter Size Mapping

    func testWomenLetterM() {
        let value = SizeConverter.numericSize(for: .m, region: .usCA, gender: .women, category: .dress)
        XCTAssertEqual(value, 4)
    }

    func testMenLetterXL() {
        let value = SizeConverter.numericSize(for: .xl, region: .usCA, gender: .men, category: .top)
        XCTAssertEqual(value, 46)
    }

    func testLetterXXXS() {
        let value = SizeConverter.numericSize(for: .xxxs, region: .usCA, gender: .women, category: .dress)
        XCTAssertEqual(value, -4)
    }

    func testLetter4XL() {
        let value = SizeConverter.numericSize(for: .xxxxl, region: .usCA, gender: .women, category: .top)
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 24)
    }

    // MARK: - Format

    func testFormatInteger() {
        XCTAssertEqual(SizeConverter.formatSize(38.0), "38")
    }

    func testFormatDecimal() {
        XCTAssertEqual(SizeConverter.formatSize(7.5), "7.5")
    }

    func testFormatNegative() {
        XCTAssertEqual(SizeConverter.formatSize(-4.0), "-4")
    }

    // MARK: - Available Sizes

    func testAvailableSizesNotEmpty() {
        let sizes = SizeConverter.availableSizes(for: .usCA, gender: .women, category: .shoes)
        XCTAssertFalse(sizes.isEmpty)
        XCTAssertEqual(sizes.first, 4)
        XCTAssertEqual(sizes.last, 16)
    }

    func testAvailableSizesInvalidCombo() {
        let sizes = SizeConverter.availableSizes(for: .usCA, gender: .men, category: .bra)
        XCTAssertTrue(sizes.isEmpty)
    }

    // MARK: - All Regions Have Consistent Array Lengths

    func testWomenStandardArrayLengthsMatch() {
        let table = SizeData.womenStandard
        let expectedCount = table[.usCA]!.count
        for (region, sizes) in table {
            XCTAssertEqual(sizes.count, expectedCount, "Mismatched array length for \(region) in womenStandard")
        }
    }

    func testMenStandardArrayLengthsMatch() {
        let table = SizeData.menStandard
        let expectedCount = table[.usCA]!.count
        for (region, sizes) in table {
            XCTAssertEqual(sizes.count, expectedCount, "Mismatched array length for \(region) in menStandard")
        }
    }

    func testAllShoeTables16() {
        let wMax = SizeConverter.availableSizes(for: .usCA, gender: .women, category: .shoes).last
        let mMax = SizeConverter.availableSizes(for: .usCA, gender: .men, category: .shoes).last
        XCTAssertEqual(wMax, 16, "Women's shoes should go up to size 16")
        XCTAssertEqual(mMax, 16, "Men's shoes should go up to size 16")
    }
}
