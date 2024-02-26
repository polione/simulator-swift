import Foundation
import PythonKit

struct SimulationWindow {

  let nodes: [[Service]]

  let dataframe: PythonObject

  func run(windowSize: Int) -> SimulationWindow.Result {

    var choosedServices: [Service] = []
    var result: Simulation.Result?
    let startTime = DispatchTime.now()

    // we move the window through the nodes
    for (index, window) in nodes.windows(ofCount: windowSize).enumerated() {
      var currentBest: Simulation.Result?

      let sim = Simulation(
        dataframe: result?.dataframe ?? dataframe,
        choosed: choosedServices,
        original: dataframe
      )

      for combination in generateCombinations(buckets: Array(window)) {
        let possibleBest = sim.run(services: combination)

        // print("weight:", choosedServices, combination, hash((choosedServices + combination).flatMap { $0.weight }))
        // print(choosedServices, combination, possibleBest.metric)

        if let _currentBest = currentBest {
          // print("best:", _currentBest.metric, possibleBest.metric)
          currentBest = best(r1: _currentBest, r2: possibleBest)
          // print("best:", _currentBest.metric, possibleBest.metric, currentBest!.metric)
        } else {
          currentBest = possibleBest
        }
      }

      // print("current best:", choosedServices, currentBest!.metric, currentBest!.services)
      if index == nodes.windows(ofCount: windowSize).count - 1 {
        choosedServices += currentBest!.services
      } else {
        choosedServices.append(currentBest!.services.first!)
      }
    
      result = Simulation(dataframe: dataframe, original: dataframe).run(services: choosedServices)
      // print("fine:", choosedServices, result!.metric)
    }

    print("\(result!.services)".red)

    let endTime = DispatchTime.now()
    let executionTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000.0

    return .init(
      metric: result!.metric,
      metric_average: result!.metricAverage,
      window_size: Double(windowSize),
      percentage: result!.percentage,
      execution_time: executionTime
    )
  }

  struct Result {
    let metric: Double
    let metric_average: Double
    let window_size: Double
    let percentage: Double
    let execution_time: Double
  }
}
