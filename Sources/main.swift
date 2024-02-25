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
let NODES_RANGE: ClosedRange<Int> = 3...4
let SERVICES_RANGE: ClosedRange<Int> = 3...3
let EXPERIMENT_RANGE: ClosedRange<Int> = 1...10

var EXPERIMENT_SEED = 0
for x in EXPERIMENT_RANGE {
  EXPERIMENT_SEED = x

  print("Starting experiment with seed: \(EXPERIMENT_SEED)".yellow)

  for numberOfNodes in NODES_RANGE {

    for numberOfServices in SERVICES_RANGE {

      let nodes = Array(1...numberOfNodes * numberOfServices)
        .map { Service(id: $0) }
        .chunked(into: numberOfServices)

      print("Starting with \(numberOfNodes) nodes and \(numberOfServices) services".green)

      let sim = SimulationWindow(
        nodes: nodes,
        numberOfNodes: numberOfNodes,
        numberOfServices: numberOfServices,
        dataframe: df
      )

      for windowSize in 1...numberOfNodes {
        print("w: \(windowSize): ", terminator: "")
        let result = sim.run(windowSize: windowSize)
        print("m: \(result.metric) | ma: \(result.metric_average) | %: \(result.percentage))")

        lib.store([
          "metric": result.metric,
          "experiment_id": result.experiment_id,
          "window_size": result.window_size,
          "number_of_nodes": result.number_of_nodes,
          "number_of_services": result.number_of_services,
          "percentage": result.percentage,
          "execution_time": result.execution_time,
        ])
      }
    }
  }
}
