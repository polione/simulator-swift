extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}

func generateCombinations<T>(buckets: [[T]]) -> [[T]] {
  guard let firstBucket = buckets.first else { return [] }
  if buckets.count == 1 { return firstBucket.map { [$0] } }

  let remainingBuckets = Array(buckets.dropFirst())
  let combinationsOfRemainder = generateCombinations(buckets: remainingBuckets)

  return firstBucket.flatMap { item in
    combinationsOfRemainder.map { [item] + $0 }
  }
}
