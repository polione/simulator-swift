import PythonKit

struct Simulation {

  let df: PythonObject

  let services: [Service]

  init(df: PythonObject, services: [Service]) {
    self.df = df
    self.services = services
  }

  func run() -> Result {
    var weight: [UInt8] = []
    var metrics: [Double] = []

    var df = self.df
    for s in self.services {
      weight += s.weight
      let output = s.run(df, weight: hash(weight))
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


//  if let _lastBest = lastResult, let _currentBest = currentBest, let _lastDf = lastDf {
//    print("Checking last: ", _lastBest.services, _currentBest.services)
//    if _lastBest.services.last == _currentBest.services.first {
//      print("We have the service in common, we can go to the next window")
//    } else {
//      print("We don't have the service in common")
//
//      var lastBestServices  = _lastBest.services
//      let sa = lastBestServices.removeLast()
//      print("Last services: \(lastBestServices)")
//
//      var currentServices  = _currentBest.services
//      let sb = currentServices.removeFirst()
//      print("Current services: \(currentServices)")
//
//      currentBest = Simulation.Result.best(
//        lhs: Simulation(df: lastDf, services: lastBestServices + [sa] + currentServices).run(),
//        rhs: Simulation(df: lastDf, services: lastBestServices + [sb] + currentServices).run()
//      )
//
//      currentBest = Simulation.Result(
//        services: [Service], 
//        metric: Double, 
//        df: PythonObject
//      )
//
//      print("New best: \(currentBest!.services)")
//    }
//  }