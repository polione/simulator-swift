import Foundation
import PythonKit

struct Simulation {
  let df: PythonObject
  let original: PythonObject
  let choosed: [Service]
  let weights: [UInt8]

  init(df: PythonObject, choosed: [Service], original: PythonObject) {
    self.df = df
    self.choosed = choosed
    self.original = original
    self.weights = choosed.flatMap { $0.weight }
  }

  func run(services: [Service]) -> Result {
    var weights = self.weights
    var percentages: [Double] = []
    var output: PythonObject = df
    // var metrics: [Double] = []

    for service in services {
      weights += service.weight
      let n = hash(weights)
      // let input = output;
      output = service.run(output, weight: n)
      // metrics.append(jensenshannon(df1: input, df2: output))
      percentages.append(n)
    }

    return .init(
      services: services,
      metric: jensenshannon(df1: original, df2: output),
      metricAverage: 0.0,
      percentage: percentages.reduce(1.0, { $0 * $1 }),
      dataframe: output
    )
  }

  struct Result {
    let services: [Service]
    let metric: Double
    let metricAverage: Double
    let percentage: Double
    let dataframe: PythonObject
  }
}

func best(r1: Simulation.Result, r2: Simulation.Result) -> Simulation.Result {
  if r1.metric < r2.metric {
    return r1
  } else {
    return r2
  }
}
