import Foundation

struct AppMessage {
    private let allMessages: [String] = {
        return [Constants.Messages.Hello,
                Constants.Messages.YoureBack,
                Constants.Messages.IsItColdOutside,
                Constants.Messages.AvengersAssemble,
                Constants.Messages.PowerAndResponsibility]
    }()

    func randomMessage() -> String {
        let randomIndex = Int.random(in: 0..<allMessages.count)

        return allMessages[randomIndex]
    }
}
