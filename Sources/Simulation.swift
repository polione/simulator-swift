import PythonKit

struct Simulation {

  let df: PythonObject

  let services: [Service]

  init(df: PythonObject, services: [Service]) {
    self.df = df
    self.services = services
  }

  func run(weights: [UInt8] = []) -> Result {
    var metrics: [Double] = []
    var weights = weights

    var df = self.df
    for s in self.services {
      weights += s.weight
      let output = s.run(df, weight: hash(weights))
      metrics.append(jensenshannon(df1: df, df2: output))
      df = output
    }

    return .init(
      services: self.services,
      metric: metrics.last!,
      dataframe: df
    )
  }

  struct Result {
    let services: [Service]
    let metric: Double
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
