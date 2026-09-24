import Flutter
import ParakeySDK
import UIKit

public enum Parakey {
  public static func initialize() {
    ParakeySDK.Parakey.shared.initialize()
  }
}

public class ParakeySdkFlutterPlugin: NSObject, FlutterPlugin, ParakeyHostApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    ParakeyHostApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: ParakeySdkFlutterPlugin()
    )
  }

  @MainActor
  func configure(tokenBundle: String) async throws {
    try await complete { ParakeySDK.Parakey.shared.configure(tokenBundle: tokenBundle, completion: $0) }
  }

  @MainActor
  func deconfigure() async throws {
    ParakeySDK.Parakey.shared.deconfigure()
  }

  @MainActor
  func showScan() async throws {
    try await complete { ParakeySDK.Parakey.shared.showScan(completion: $0) }
  }

  @MainActor
  func unlock(deviceId: String) async throws {
    try await complete { ParakeySDK.Parakey.shared.unlock(deviceID: deviceId, completion: $0) }
  }

  func setTheme(theme: ThemeMessage) throws {
    ParakeySDK.Parakey.shared.theme(
      action: dynamicColor(light: theme.actionLight, dark: theme.actionDark),
      title: dynamicColor(light: theme.titleLight, dark: theme.titleDark)
    )
  }

  @MainActor
  private func complete(
    _ call: (@escaping (Error?) -> Void) -> Void
  ) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      call { error in
        if let error {
          continuation.resume(throwing: PigeonError(error))
        } else {
          continuation.resume()
        }
      }
    }
  }
}

extension PigeonError {
  fileprivate convenience init(_ error: any Error) {
    self.init(
      code: (error as? any ParakeyError)?.id ?? String(describing: error),
      message: nil,
      details: nil
    )
  }
}

private func dynamicColor(light: Int64?, dark: Int64?) -> UIColor? {
  let light = light.map(UIColor.init(argb:))
  let dark = dark.map(UIColor.init(argb:))

  guard let light, let dark else { return light ?? dark }
  return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
}

extension UIColor {
  fileprivate convenience init(argb: Int64) {
    let value = UInt64(bitPattern: argb)
    self.init(
      red: component(value, shift: 16),
      green: component(value, shift: 8),
      blue: component(value, shift: 0),
      alpha: component(value, shift: 24)
    )

    func component(_ value: UInt64, shift: Int) -> CGFloat {
      CGFloat((value >> shift) & 0xFF) / 255
    }
  }
}
