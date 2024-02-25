import PythonKit
import Foundation

struct Simulation {

  let df: PythonObject

  let services: [Service]

  init(df: PythonObject, services: [Service]) {
    self.df = df
    self.services = services
  }

  func run(weights: [UInt8]=[]) -> Result {


    var weights: [UInt8] = weights
    var metrics: [Double] = []
    var percentages: [Double] = []

    var df = self.df
    for s in self.services {
      weights += s.weight
      let output = s.run(df, weight: hash(weights))
      metrics.append(jensenshannon(df1: df, df2: output))
      percentages.append(hash(weights))
      df = output
    }

    return .init(
      services: self.services,
      metric: metrics.average,
      percentage: percentages.reduce(1.0, { $0 * $1 }),
      dataframe: df
    )
  }

  struct Result {
    let services: [Service]
    let metric: Double
    let percentage: Double
    let dataframe: PythonObject
    var executionTime: Double = 0.0
  }
}

func best(r1: Simulation.Result, r2: Simulation.Result) -> Simulation.Result {
  if r1.metric < r2.metric {
    return r1
  } else {
    return r2
  }
}
