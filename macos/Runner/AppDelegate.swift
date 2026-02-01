import Cocoa
import FlutterMacOS
import AVFoundation
import Speech

@main
class AppDelegate: FlutterAppDelegate {
  
  private var permissionChannel: FlutterMethodChannel?

  // MARK: - Existing Flutter behavior (keep)

  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(
    _ app: NSApplication
  ) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
    
    // Setup permission channel
    permissionChannel = FlutterMethodChannel(
      name: "com.hexmac/permissions",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    permissionChannel?.setMethodCallHandler { [weak self] (call, result) in
      self?.handleMethodCall(call, result: result)
    }
  }
  
  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkMicrophonePermission":
      checkMicrophonePermission(result: result)
    case "requestMicrophonePermission":
      requestMicrophonePermission(result: result)
    case "checkSpeechRecognitionPermission":
      checkSpeechRecognitionPermission(result: result)
    case "requestSpeechRecognitionPermission":
      requestSpeechRecognitionPermission(result: result)
    case "requestAllPermissions":
      requestAllPermissions(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - Microphone Permission
  
  private func checkMicrophonePermission(result: @escaping FlutterResult) {
    let status = AVCaptureDevice.authorizationStatus(for: .audio)
    switch status {
    case .authorized:
      result("authorized")
    case .denied, .restricted:
      result("denied")
    case .notDetermined:
      result("notDetermined")
    @unknown default:
      result("notDetermined")
    }
  }
  
  private func requestMicrophonePermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .audio) { granted in
      DispatchQueue.main.async {
        result(granted ? "authorized" : "denied")
      }
    }
  }
  
  // MARK: - Speech Recognition Permission
  
  private func checkSpeechRecognitionPermission(result: @escaping FlutterResult) {
    let status = SFSpeechRecognizer.authorizationStatus()
    switch status {
    case .authorized:
      result("authorized")
    case .denied, .restricted:
      result("denied")
    case .notDetermined:
      result("notDetermined")
    @unknown default:
      result("notDetermined")
    }
  }
  
  private func requestSpeechRecognitionPermission(result: @escaping FlutterResult) {
    SFSpeechRecognizer.requestAuthorization { status in
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          result("authorized")
        case .denied, .restricted:
          result("denied")
        case .notDetermined:
          result("notDetermined")
        @unknown default:
          result("notDetermined")
        }
      }
    }
  }
  
  // MARK: - Request All Permissions
  
  private func requestAllPermissions(result: @escaping FlutterResult) {
    // First request microphone
    AVCaptureDevice.requestAccess(for: .audio) { micGranted in
      // Then request speech recognition
      SFSpeechRecognizer.requestAuthorization { speechStatus in
        DispatchQueue.main.async {
          let bothGranted = micGranted && (speechStatus == .authorized)
          result([
            "microphone": micGranted ? "authorized" : "denied",
            "speechRecognition": speechStatus == .authorized ? "authorized" : "denied",
            "allGranted": bothGranted
          ])
        }
      }
    }
  }
}
