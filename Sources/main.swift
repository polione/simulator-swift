//Read Experiment number, number of nodes and number of services, from command line
/// Experiment 1
import Algorithms
import ArgumentParser
import CryptoSwift
import Foundation
import PythonKit
import Rainbow

setupPythonEnvironment()

let pd = Python.import("pandas")
let np = Python.import("numpy")
let dataframe = pd.read_csv("Input/inmates_enriched_10k.csv")
let lib = Python.import("functions")

var EXPERIMENT_SEED: Int = 0
// Read Experiment number, number of nodes and number of services from command line
struct MyCLI: ParsableCommand {
  @Argument(help: "Experiment number")
  var experimentNumber: Int

  @Argument(help: "Number of nodes")
  var numberOfNodes: Int

  @Argument(help: "Number of services")
  var numberOfServices: Int

  func run() throws {
    let experimentRange = experimentNumber
    let nodesRange = 3...numberOfNodes
    let servicesRange = 2...numberOfServices

    EXPERIMENT_SEED = experimentRange

    print("Starting experiment with seed: \(EXPERIMENT_SEED)".yellow)

    for numberOfServices in servicesRange {
      for numberOfNodes in nodesRange {
        let nodes = Array(1...numberOfNodes * numberOfServices)
          .map { Service(id: $0) }
          .chunked(into: numberOfServices)

        print("Starting with \(numberOfNodes) nodes and \(numberOfServices) services".green)

        let sim = SimulationWindow(nodes: nodes, dataframe: dataframe)

        for windowSize in 1...numberOfNodes {
          print("w: \(windowSize): ", terminator: "")
          let result = sim.run(windowSize: windowSize)
          print("m: \(result.metric) | ma: \(result.metric_average) | %: \(result.percentage)")

          lib.store([
            "metric": result.metric,
            "experiment_id": Double(EXPERIMENT_SEED),
            "window_size": result.window_size,
            "number_of_nodes": Double(numberOfNodes),
            "number_of_services": Double(numberOfServices),
            "percentage": result.percentage,
            "execution_time": result.execution_time,
          ])
        }
      }
    }
  }

}

MyCLI.main()

///
/// Node 1       Node 2       Node 3
/// ------------------------------------
/// Service 1    Service 5    Service 9
/// Service 2    Service 6    Service 10
/// Service 3    Service 7    Service 11
/// Service 4    Service 8    Service 12
