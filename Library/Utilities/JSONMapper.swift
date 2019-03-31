
import Foundation

public enum JSONMapperError: Error {
    case fileNotFound(String)
    case couldNotDecodeObject(Error)
}

/**
Maps .json file to expected object type.
 */
public class JSONMapper {
    
    public static func create<T: Decodable>(_ object: T.Type, from file: String) throws -> T {
        do {
            let response = try JSONSerialization.data(withJSONObject: try jsonDict(for: file), options: [])
            return try JSONDecoder().decode(T.self, from: response)
        } catch let error {
            throw JSONMapperError.couldNotDecodeObject(error)
        }
    }
    
    public static func createArray<T: Decodable>(_ object: T.Type, from file: String) throws -> [T] {
        do {
            let response = try JSONSerialization.data(withJSONObject: try jsonDict(for: file), options: [])
            return try JSONDecoder().decode([T].self, from: response)
        } catch let error {
            throw JSONMapperError.couldNotDecodeObject(error)
        }
    }
    
    private static func jsonDict(for path: String) throws -> Any {
        if let path = Bundle.main.path(forResource: path, ofType: "json") {
            return try String(contentsOfFile: path, encoding: .utf8).toJSON() ?? [:]
        }
        
        throw JSONMapperError.fileNotFound(path)
    }
    
}

extension String {
    /**
     Converts string to JSON.
     */
    public func toJSON() -> Any? {
        guard let data = data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
