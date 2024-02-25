import Foundation
import PythonKit

struct Simulation {

  let df: PythonObject

  let services: [Service]

  init(df: PythonObject, services: [Service]) {
    self.df = df
    self.services = services
  }

  func run(choosed: [Service] = []) -> Result {
    // We find the weight of the combination of services
    var weights: [UInt8] = choosed.flatMap { $0.weight}
    var percentages: [Double] = []
    var output: PythonObject = df
    var metrics: [Double] = []

    for service in services {
      weights += service.weight
      let input = output;
      output = service.run(output, weight: hash(weights))
      metrics.append(jensenshannon(df1: input, df2: output))
      percentages.append(hash(weights))
    }
    
    return .init(
      services: self.services,
      metric: metrics.last!,
      metricAverage: metrics.average,
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
