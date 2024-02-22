import Algorithms
import CryptoSwift
import Foundation
import PythonKit
import Rainbow

setupPythonEnvironment()

let pd = Python.import("pandas")
let df = pd.read_csv("Input/inmates_enriched_10k.csv")

///
/// Node 1       Node 2       Node 3
/// ------------------------------------
/// Service 1    Service 5    Service 9
/// Service 2    Service 6    Service 10
/// Service 3    Service 7    Service 11
/// Service 4    Service 8    Service 12
///
let numberOfServices = 16
let numberOfNodes = 4
let windowStartSize: Int = 2
let nodes = Array(1...numberOfServices)
  .map { Service(id: $0) }
  .chunked(into: numberOfServices / numberOfNodes)

print("\nNodes: \(numberOfNodes)")
print("Services: \(numberOfServices)")
print("\nStarting simulation...\n")
print("Nodes generated:", nodes)
print("----")

for windowSize in windowStartSize...numberOfNodes {
  print("Starting with window \(windowSize)".yellow)

  var dataframe = df  // We will use the original dataframe for the first window
  var services: [Service] = []
  var servicesSeconds: [[Service]] = []
  var result: Simulation.Result?

  for (index, window) in nodes.windows(ofCount: windowSize).enumerated() {
    print("Window at index: \(index)")
    // We will store the best result for the current window
    var currentBest: Simulation.Result?
    var currentDataframe = result?.dataframe ?? dataframe

    print("Running combinations...")
    for combination in generateCombinations(buckets: Array(window)) {
     //print(combination.map { $0.id })
      let possibleBest = Simulation(df: currentDataframe, services: combination).run()

      if let _currentBest = currentBest {
        currentBest = best(r1: _currentBest, r2: possibleBest)

      } else {
        currentBest = possibleBest
      }
    }
    print("Done.")

    print("Best found:".red, currentBest!.services, "metric:", currentBest!.metric, "percentage:", currentBest!.percentage, "execution time:", currentBest!.executionTime)

    if index == nodes.windows(ofCount: windowSize).count - 1 {
      services += currentBest!.services
    } else {
        services.append(currentBest!.services.first!)

    }

    result = Simulation(df: dataframe, services: services).run()

    print("Taking the first", result!.services,  "metric:", result!.metric, "percentage:", result!.percentage)
    servicesSeconds.append(currentBest!.services)
    print("-")
  }

  print("Finished with window \(windowSize):".green, result!.services, result!.metric)
  print("----")
}
