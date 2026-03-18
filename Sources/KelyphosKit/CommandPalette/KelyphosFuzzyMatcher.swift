// KelyphosFuzzyMatcher.swift - Fuzzy string matching for the command palette

import Foundation

/// Result of a fuzzy match, including score and matched character indices.
public struct KelyphosFuzzyMatch: Sendable {
    /// Higher is better. Factors: consecutive matches, word-start bonuses, case-exact.
    public let score: Int
    /// Indices into the candidate string where query characters matched.
    public let matchedIndices: [String.Index]
}

/// Fuzzy string matcher for filtering command palette candidates.
///
/// Algorithm: for each query character, find the next occurrence in the candidate.
/// Score bonuses for consecutive matches, word-start positions, and exact case.
/// Returns nil if the query doesn't match.
public enum KelyphosFuzzyMatcher {

    /// Match `query` against `candidate`. Returns nil if no match.
    public static func match(query: String, in candidate: String) -> KelyphosFuzzyMatch? {
        guard !query.isEmpty else {
            return KelyphosFuzzyMatch(score: 0, matchedIndices: [])
        }

        let candidateLower = candidate.lowercased()
        let queryLower = query.lowercased()
        // Convert query to Array for O(1) indexed access (avoids O(n) String.index(offsetBy:))
        let queryChars = Array(query)

        var matchedIndices: [String.Index] = []
        matchedIndices.reserveCapacity(queryLower.count)
        var score = 0
        var searchStart = candidateLower.startIndex
        var previousMatchIndex: String.Index?
        var queryCharIndex = 0

        for qChar in queryLower {
            guard let range = candidateLower[searchStart...].range(of: String(qChar)) else {
                return nil
            }

            let matchIndex = range.lowerBound
            matchedIndices.append(matchIndex)

            // Consecutive match bonus
            if let prev = previousMatchIndex,
               candidateLower.index(after: prev) == matchIndex {
                score += 5
            }

            // Word-start bonus (first char or preceded by separator)
            if matchIndex == candidateLower.startIndex {
                score += 10
            } else {
                let prevChar = candidateLower[candidateLower.index(before: matchIndex)]
                if prevChar == " " || prevChar == "-" || prevChar == "_" || prevChar == "." {
                    score += 8
                }
            }

            // Case-exact bonus (O(1) via Array index)
            let candidateOrigChar = candidate[matchIndex]
            if candidateOrigChar == queryChars[queryCharIndex] {
                score += 1
            }

            // Base point per match
            score += 1

            previousMatchIndex = matchIndex
            searchStart = candidateLower.index(after: matchIndex)
            queryCharIndex += 1
        }

        // Penalty for unmatched tail length (prefer shorter candidates)
        let tailLength = candidateLower.distance(from: searchStart, to: candidateLower.endIndex)
        score -= tailLength / 4

        return KelyphosFuzzyMatch(score: max(score, 1), matchedIndices: matchedIndices)
    }

    /// Filter and sort items by fuzzy match score.
    public static func filter<T>(
        _ items: [T],
        query: String,
        keyPath: KeyPath<T, String>
    ) -> [(item: T, match: KelyphosFuzzyMatch)] {
        guard !query.isEmpty else {
            return items.map { ($0, KelyphosFuzzyMatch(score: 0, matchedIndices: [])) }
        }
        return items
            .compactMap { item -> (T, KelyphosFuzzyMatch)? in
                guard let m = match(query: query, in: item[keyPath: keyPath]) else { return nil }
                return (item, m)
            }
            .sorted { $0.1.score > $1.1.score }
    }
}
