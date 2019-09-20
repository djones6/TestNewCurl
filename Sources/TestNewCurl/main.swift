import KituraNet
import HeliumLogger
import LoggerAPI
import Dispatch

HeliumLogger.use(.debug)

let sema = DispatchSemaphore(value: 0)

let req = HTTP.request("http://anglesharp.azurewebsites.net/Chunked") { response in
    guard let response = response else {
        return Log.error("No response to request")
    }
    guard response.statusCode == .OK else {
        return Log.error("Response status was \(response.status)")
    }
    guard let string = try? response.readString() else {
        return Log.error("Response string couldn't be read")
    }
    Log.info("Response: \(string)")
    sema.signal()
}
req.end()

sema.wait()
