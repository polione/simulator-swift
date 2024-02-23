import PythonKit

struct Service: CustomStringConvertible, Equatable {

  var id: Int

  var metric: Double = 0.0

  var percentage: Double?

  var seed: Double

  var description: String {
    return "S" + String(format: "%02d", id)
  }

  var weight: [UInt8] {
    return seed.bytes
  }

  init(id: Int, random: Bool = true) {
    self.id = id
    self.seed = random ? Double.random(in: 0...1) : 1.0
  }

  func run(_ input: PythonObject, weight: Double) -> PythonObject {
    return input.sample(frac: weight, random_state: EXPERIMENT_SEED)
  }

  static func == (lhs: Service, rhs: Service) -> Bool {
    return lhs.id == rhs.id
  }
}
