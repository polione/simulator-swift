import Algorithms
import CryptoSwift
import Foundation
import PythonKit
import Rainbow

setupPythonEnvironment()

let pd = Python.import("pandas")
let df = pd.read_csv("Input/inmates_enriched_10k.csv")

let lib = Python.import("functions")

///
/// Node 1       Node 2       Node 3
/// ------------------------------------
/// Service 1    Service 5    Service 9
/// Service 2    Service 6    Service 10
/// Service 3    Service 7    Service 11
/// Service 4    Service 8    Service 12
///
var EXPERIMENT_SEED_START = 6
var EXPERIMENT_SEED = 0
for  x in EXPERIMENT_SEED_START...10 {
  EXPERIMENT_SEED = x
  let windowStartSize: Int = 1
  for numberOfServices in 2...7 {
    for numberOfNodes in 2...7 {
      let nodes = Array(1...numberOfNodes * numberOfServices)
        .map { Service(id: $0) }
        .chunked(into: numberOfServices)
      print("\nNodes: \(numberOfNodes)")
      print("Services: \(numberOfServices)")
      print("\nStarting simulation...\n")
      print("Nodes generated:", nodes)
      print("----")

      for windowSize in windowStartSize...numberOfNodes {
        print("Starting with window \(windowSize)".yellow)

        let dataframe = df  // We will use the original dataframe for the first window
        var services: [Service] = []
        var servicesSeconds: [[Service]] = []
        var result: Simulation.Result?

        for (index, window) in nodes.windows(ofCount: windowSize).enumerated() {
          print("Window at index: \(index)")
          // We will store the best result for the current window
          var currentBest: Simulation.Result?
          let currentDataframe = result?.dataframe ?? dataframe

          print("Running combinations...")
          let startTime = DispatchTime.now()
          for combination in generateCombinations(buckets: Array(window)) {
            let possibleBest = Simulation(df: currentDataframe, services: combination)
              .run(weights: services.flatMap { $0.weight })
            if let _currentBest = currentBest {
              currentBest = best(r1: _currentBest, r2: possibleBest)

            } else {
              currentBest = possibleBest
            }
          }
          let endTime = DispatchTime.now()
          let executionTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000.0
          currentBest!.executionTime = executionTime
          print("Done.")

          //print("Best found:".red, currentBest!.services, "metric:", currentBest!.metric, "percentage:", currentBest!.percentage, "execution time:", currentBest!.executionTime)
          lib.store([
            "metric": currentBest!.metric,
            "experiment_id": Double(EXPERIMENT_SEED),
            "window_size": Double(windowSize),
            "number_of_nodes": Double(numberOfNodes),
            "number_of_services": Double(numberOfServices),
            "percentage": currentBest!.percentage,
            "execution_time": currentBest!.executionTime,
          ])

          if index == nodes.windows(ofCount: windowSize).count - 1 {
            services += currentBest!.services
          } else {
            services.append(currentBest!.services.first!)

          }

          result = Simulation(df: dataframe, services: services).run()

          print(
            "Taking the first", result!.services, "metric:", result!.metric, "percentage:",
            result!.percentage)
          servicesSeconds.append(currentBest!.services)
          print("-")
        }

        print("Finished with window \(windowSize):".green, result!.services, result!.metric)
        print("----")
      }
    }
  }
}
