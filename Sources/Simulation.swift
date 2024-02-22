import PythonKit
import Foundation

struct Simulation {

  let df: PythonObject

  let services: [Service]

  init(df: PythonObject, services: [Service]) {
    self.df = df
    self.services = services
  }

  func run(weights: [UInt8]) -> Result {
    let startTime = DispatchTime.now()

    var weights: [UInt8] = weights
    var metrics: [Double] = []
    var percentages: [Double] = []
    var executionTime: Double = 0.0

    var df = self.df
    for s in self.services {
      weights += s.weight
      let output = s.run(df, weight: hash(weights))
      metrics.append(jensenshannon(df1: df, df2: output))
      percentages.append(hash(weight))
      df = output
    }

    let endTime = DispatchTime.now()
    executionTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000.0

    return .init(
      services: self.services,
      metric: metrics.average,
      percentage: percentages.reduce(1.0, { $0 * $1 }),
      dataframe: df,
      executionTime: executionTime
    )
  }

  struct Result {
    let services: [Service]
    let metric: Double
    let percentage: Double
    let dataframe: PythonObject
    let executionTime: Double
  }
}

func best(r1: Simulation.Result, r2: Simulation.Result) -> Simulation.Result {
  if r1.metric < r2.metric {
    return r1
  } else {
    return r2
  }
}
