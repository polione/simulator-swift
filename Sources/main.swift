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
let numberOfServices = 12
let numberOfNodes = 4
let nodes = Array(1...numberOfServices)
  .map { Service(id: $0) }
  .chunked(into: numberOfServices / numberOfNodes)

print("\nNodes: \(numberOfNodes)")
print("Services: \(numberOfServices)")
print("\nStarting simulation...\n")
print("Nodes generated:", nodes)
print("----")

for windowSize in 2...numberOfNodes {
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
      let possibleBest = Simulation(df: currentDataframe, services: combination).run()
      if let _currentBest = currentBest {
        currentBest = best(r1: _currentBest, r2: possibleBest)
      } else {
        currentBest = possibleBest
      }
    }
    print("Done.")

    print("Best found:".red, currentBest!.services, "metric:", currentBest!.metric)

    if index == nodes.windows(ofCount: windowSize).count - 1 {
      services += currentBest!.services
    } else {
      if !servicesSeconds.isEmpty && servicesSeconds.last!.last != currentBest!.services.first {
        print("Difference found \(servicesSeconds.last!) != \(currentBest!.services)".yellow)
        
        var currentServices = currentBest!.services
        currentServices.removeFirst()

        print("Checking \(servicesSeconds.last!.last!)".yellow, terminator: "")
        let option1 = Simulation(df: dataframe, services: services + [servicesSeconds.last!.last!] + currentServices).run()
        print(option1.services, option1.metric)

        print("Checking \(currentBest!.services.first!)".yellow, terminator: "")
        let option2 = Simulation(df: dataframe, services: services + [currentBest!.services.first!] + currentServices).run()
        print(option2.services, option2.metric)

        if option1.metric < option2.metric {
          print("Best is \(servicesSeconds.last!.last!)".green)
          services.append(servicesSeconds.last!.last!)
        } else {
          print("Best is \(currentBest!.services.first!)".green)
          services.append(currentBest!.services.first!)
        }
      } else {
        services.append(currentBest!.services.first!)
      }
    }

    result = Simulation(df: dataframe, services: services).run()

    print("Taking the first", result!.services,  "metric:", result!.metric)
    servicesSeconds.append(currentBest!.services)
    print("-")
  }

  print("Finished with window \(windowSize):".green, result!.services, result!.metric)
  print("----")
}
