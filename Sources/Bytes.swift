extension Double {
   var bytes: [UInt8] {
       withUnsafeBytes(of: self, Array.init)
   }
}