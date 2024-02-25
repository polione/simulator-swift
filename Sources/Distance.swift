import CryptoSwift
import Foundation
import PythonKit

func jensenshannon(df1: PythonObject, df2: PythonObject) -> Double {
  return Double(lib.mydistance(df1, df2))!
}

func hash(_ x: [UInt8]) -> Double {
  let a = Double(x.crc32() & 0xffff_ffff) / pow(2, 32)
  let b = a.normalize(min: 0, max: 1, from: 0.5, to: 1)
  return b
}

extension BinaryFloatingPoint {
  /// Returns normalized value for the range between a and b
  /// - Parameters:
  ///   - min: minimum of the range of the measurement
  ///   - max: maximum of the range of the measurement
  ///   - a: minimum of the range of the scale
  ///   - b: minimum of the range of the scale
  func normalize(min: Self, max: Self, from a: Self = 0, to b: Self = 1) -> Self {
    (b - a) * ((self - min) / (max - min)) + a
  }
}
