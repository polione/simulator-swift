import Foundation
import PythonKit

struct SimulationWindow {

  let nodes: [[Service]]

  let numberOfNodes: Int

  let numberOfServices: Int

  let dataframe: PythonObject

  func run(windowSize: Int) -> SimulationWindow.Result {

    var choosedServices: [Service] = []
    var result: Simulation.Result?
    let startTime = DispatchTime.now()

    // we move the window through the nodes
    for (index, window) in nodes.windows(ofCount: windowSize).enumerated() {
      var currentBest: Simulation.Result?
      
      let sim = Simulation(
        df: result?.dataframe ?? dataframe, 
        choosed: choosedServices, 
        original: self.dataframe
      );

      for combination in generateCombinations(buckets: Array(window)) {
        let possibleBest = sim.run(services: combination)

        if let _currentBest = currentBest {
          currentBest = best(r1: _currentBest, r2: possibleBest)
        } else {
          currentBest = possibleBest
        }
      }

      if index == nodes.windows(ofCount: windowSize).count - 1 {
        choosedServices += currentBest!.services
      } else {
        choosedServices.append(currentBest!.services.first!)
      }

      result = Simulation(df: self.dataframe, choosed: [], original: self.dataframe).run(services: choosedServices)
    }

    print("\(result!.services)".red)

    let endTime = DispatchTime.now()
    let executionTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000.0

    return .init(
      metric: result!.metric,
      metric_average: result!.metricAverage,
      experiment_id: Double(EXPERIMENT_SEED),
      window_size: Double(windowSize),
      number_of_nodes: Double(numberOfNodes),
      number_of_services: Double(numberOfServices),
      percentage: result!.percentage,
      execution_time: executionTime
    )
  }

  struct Result {
    let metric: Double
    let metric_average: Double
    let experiment_id: Double
    let window_size: Double
    let number_of_nodes: Double
    let number_of_services: Double
    let percentage: Double
    let execution_time: Double
  }
}
