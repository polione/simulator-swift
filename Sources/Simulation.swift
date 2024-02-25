import Foundation
import PythonKit

struct Simulation {
  let dataframe: PythonObject
  let original: PythonObject
  let choosed: [Service]
  let weights: [UInt8]

  init(dataframe: PythonObject, choosed: [Service] = [], original: PythonObject) {
    self.dataframe = dataframe
    self.choosed = choosed
    self.original = original
    self.weights = choosed.flatMap { $0.weight }
  }

  func run(services: [Service]) -> Result {
    var weights = self.weights
    var output = self.dataframe

    for service in services {
      weights += service.weight
      output = service.run(output, weight: hash(weights))
    }

    var percentage: Double = 1.0
    var allWeights: [UInt8] = []
    for s in choosed + services {
      allWeights += s.weight
      percentage = percentage * hash(allWeights)
    }

    return .init(
      services: services,
      metric: jensenshannon(df1: original, df2: output),
      metricAverage: 0.0,
      percentage: percentage,
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
