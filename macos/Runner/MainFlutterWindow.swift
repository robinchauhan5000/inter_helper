import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Make window always stay on top
    self.level = .floating
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    
    // Add glass/frosted background effect
    self.isOpaque = false
    self.backgroundColor = .clear
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    
    // Add visual effect view (frosted glass)
    // let visualEffectView = NSVisualEffectView(frame: self.contentView!.bounds)
    // visualEffectView.autoresizingMask = [.width, .height]
    // visualEffectView.material = .hudWindow
    // visualEffectView.state = .active
    // visualEffectView.blendingMode = .behindWindow
    
    // self.contentView?.addSubview(visualEffectView, positioned: .below, relativeTo: nil)

    let channel = FlutterMethodChannel(
      name: "interx/screen_capture",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        return result(FlutterError(code: "NO_WINDOW", message: nil, details: nil))
      }

      switch call.method {
      case "setHidden":
        guard let isHidden = call.arguments as? Bool else {
          return result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
        }
        DispatchQueue.main.async {
          self.sharingType = isHidden ? .none : .readOnly
          result(nil)
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
