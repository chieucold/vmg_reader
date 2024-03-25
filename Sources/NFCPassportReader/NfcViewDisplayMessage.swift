import Foundation

@available(iOS 13, macOS 10.15, *)
public enum NfcViewDisplayMessage {
    case requestPresentEid
    case authenticatingWithPassport(Int)
    case readingDataGroupProgress(DataGroupId, Int)
    case error(NfcEIdReaderError)
    case successfulRead
}

@available(iOS 13, macOS 10.15, *)
extension NfcViewDisplayMessage {
    public var description: String {
        switch self {
            case .requestPresentEid:
                return "Put the iPhone near the eID card"
            case .authenticatingWithPassport(let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "Login to eID card..." + "\n\n\(progressString)"
            case .readingDataGroupProgress(let dataGroup, let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "READ" + " \(dataGroup).....\n\n\(progressString)"
            case .error(let tagError):
                switch tagError {
                    case NfcEIdReaderError.TagNotValid:
                        return "eID card not valid"
                    case NfcEIdReaderError.MoreThanOneTagFound:
                        return "There are more than one eID card near iPhone. Only one accept at a time."
                    case NfcEIdReaderError.ConnectionError:
                        return "Connecting error. Please try again."
                    case NfcEIdReaderError.InvalidMRZKey:
                        return "MRZ is invalid"
                    case NfcEIdReaderError.ResponseError(let description, let sw1, let sw2):
                        return "Error during reading eID card" + " \(description) - (0x\(sw1), 0x\(sw2)"
                    default:
                        return "Error during reading eID card. Please try again."
                }
            case .successfulRead:
                return "eID card reading successfully."
        }
    }
    
    func handleProgress(percentualProgress: Int) -> String {
        let p = (percentualProgress/20)
        let full = String(repeating: "🟢 ", count: p)
        let empty = String(repeating: "⚪️ ", count: 5-p)
        return "\(full)\(empty)"
    }
}
