import PythonKit

func setupPythonEnvironment() {
  let os = Python.import("os")
  let sys = Python.import("sys")
  sys.path.append("\(os.getcwd())/venv/lib/python3.11/site-packages")
  sys.path.append("\(os.getcwd())")
}
