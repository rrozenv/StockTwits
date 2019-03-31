
import Domain

/// Error that can be decoded from server response.
public struct ApiError: Error, Codable { }

///  Error for failed network request.
public enum NetworkError: Error {
    case serverFailed
    case serverError(Error?, Int)
    case decodingError(String)
}

