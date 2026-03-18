// KelyphosFuzzyMatcherTests.swift

import Testing
@testable import KelyphosKit

@Suite("KelyphosFuzzyMatcher")
struct KelyphosFuzzyMatcherTests {

    @Test func emptyQueryMatchesAll() {
        let result = KelyphosFuzzyMatcher.match(query: "", in: "anything")
        #expect(result != nil)
        #expect(result?.score == 0)
        #expect(result?.matchedIndices.isEmpty == true)
    }

    @Test func exactMatchScoresHighest() {
        let exact = KelyphosFuzzyMatcher.match(query: "Open File", in: "Open File")
        let partial = KelyphosFuzzyMatcher.match(query: "Open File", in: "Open File Dialog Extended")
        #expect(exact != nil)
        #expect(partial != nil)
        #expect(exact!.score > partial!.score)
    }

    @Test func noMatchReturnsNil() {
        let result = KelyphosFuzzyMatcher.match(query: "xyz", in: "abc")
        #expect(result == nil)
    }

    @Test func caseInsensitiveMatching() {
        let result = KelyphosFuzzyMatcher.match(query: "open", in: "Open File")
        #expect(result != nil)
    }

    @Test func caseExactBonus() {
        let exact = KelyphosFuzzyMatcher.match(query: "Open", in: "Open File")
        let lower = KelyphosFuzzyMatcher.match(query: "open", in: "Open File")
        #expect(exact != nil)
        #expect(lower != nil)
        // Case-exact match should score slightly higher
        #expect(exact!.score >= lower!.score)
    }

    @Test func consecutiveMatchBonus() {
        let consecutive = KelyphosFuzzyMatcher.match(query: "op", in: "open")
        let scattered = KelyphosFuzzyMatcher.match(query: "oe", in: "open")
        #expect(consecutive != nil)
        #expect(scattered != nil)
        #expect(consecutive!.score > scattered!.score)
    }

    @Test func wordStartBonus() {
        let wordStart = KelyphosFuzzyMatcher.match(query: "of", in: "Open File")
        let midWord = KelyphosFuzzyMatcher.match(query: "pe", in: "Open File")
        #expect(wordStart != nil)
        #expect(midWord != nil)
        // Word-start match should score higher
        #expect(wordStart!.score > midWord!.score)
    }

    @Test func filterSortsByScore() {
        let items = ["Toggle Navigator", "Open File", "Toggle Inspector"]
        let results = KelyphosFuzzyMatcher.filter(items, query: "tog", keyPath: \.self)
        #expect(results.count == 2)
        #expect(results[0].item.contains("Toggle"))
        #expect(results[1].item.contains("Toggle"))
    }

    @Test func filterReturnsAllOnEmptyQuery() {
        let items = ["A", "B", "C"]
        let results = KelyphosFuzzyMatcher.filter(items, query: "", keyPath: \.self)
        #expect(results.count == 3)
    }

    @Test func matchedIndicesAreCorrect() {
        let result = KelyphosFuzzyMatcher.match(query: "of", in: "Open File")
        #expect(result != nil)
        #expect(result!.matchedIndices.count == 2)
    }

    @Test func separatorBonusOnDotSeparated() {
        let dotStart = KelyphosFuzzyMatcher.match(query: "sf", in: "some.file")
        let noSep = KelyphosFuzzyMatcher.match(query: "sf", in: "superfine")
        #expect(dotStart != nil)
        #expect(noSep != nil)
        #expect(dotStart!.score > noSep!.score)
    }

    @Test func shortCandidatesPreferred() {
        let short = KelyphosFuzzyMatcher.match(query: "op", in: "open")
        let long = KelyphosFuzzyMatcher.match(query: "op", in: "open a very long description here")
        #expect(short != nil)
        #expect(long != nil)
        #expect(short!.score > long!.score)
    }
}
