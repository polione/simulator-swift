import CryptoSwift
import Foundation
import PythonKit

let lib = Python.import("mydistance")

func jensenshannon(df1: PythonObject, df2: PythonObject) -> Double {
  return Double(lib.mydistance(df1, df2))!
}

func hash(_ x: [UInt8]) -> Double {
  return Double(x.crc32() & 0xffff_ffff) / pow(2, 32)
}
