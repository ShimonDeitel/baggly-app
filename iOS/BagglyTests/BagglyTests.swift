import XCTest
@testable import Baggly

@MainActor
final class BagglyTests: XCTestCase {

    func makeEntry(_ text: String) -> LogEntry {
        LogEntry(primaryText: text)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(makeEntry("Test Entry"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        store.add(makeEntry("ToDelete"))
        let entry = store.entries.first!
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testFreeLimitBlocksAddWhenNotPro() {
        let store = Store()
        store.isProUnlocked = false
        for i in 0..<(Store.freeLimit + 5) {
            store.add(makeEntry("Entry \(i)"))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlockAllowsMoreThanLimit() {
        let store = Store()
        store.isProUnlocked = true
        let before = store.entries.count
        for i in 0..<10 {
            store.add(makeEntry("Pro Entry \(i)"))
        }
        XCTAssertEqual(store.entries.count, before + 10)
    }

    func testCanAddMoreReflectsLimit() {
        let store = Store()
        store.isProUnlocked = false
        store.entries = []
        for i in 0..<Store.freeLimit {
            store.add(makeEntry("E\(i)"))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testUpdateModifiesExistingEntry() {
        let store = Store()
        store.add(makeEntry("Original"))
        var entry = store.entries.first!
        entry.primaryText = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.primaryText, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = Store()
        store.entries = []
        store.add(makeEntry("A"))
        store.add(makeEntry("B"))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
    }
}
