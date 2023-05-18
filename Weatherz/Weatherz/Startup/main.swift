import UIKit

let isTestTarget = NSClassFromString("XCTestCase") != nil

let appDelegateClass = isTestTarget ? NSStringFromClass(MockAppDelegate.self) : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
