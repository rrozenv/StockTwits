
import Foundation
import RxSwift
import Domain

/**
 Wrapper around saving/fetching codeable objects from the file system.
 */
public class FileSystemCache: StorageType {
    
    // MARK: - Storage Error
    public enum StorageError<T>: Error {
        case saveFailed(T.Type)
        case fetchFailed(T.Type)
    }

    // MARK: - Directory
    public enum Directory: String, Codable {
        case documents
        case caches
    }
    
    // MARK: - Properties
    public let directory: Directory
    
    // MARK: - Initialization
    public init(directory: Directory = .documents) {
        self.directory = directory
    }
    
    /// Saves an object in a file either the documents or caches directory.
    /// The file name will be generated from the objects type: "\(T.self).type".
    ///
    /// - Parameter object: Object to save.
    /// - Returns: Observable of type T. Will emit error if saving to directory failed.
    public func save<T>(object: T) -> Observable<T> where T: Encodable {
        return Observable.create { (observer) -> Disposable in
            
            let url = self
                .getURL(for: self.directory)
                .appendingPathComponent("\(T.self).type", isDirectory: false)
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(object)
                
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                
                FileManager.default.createFile(atPath: url.path,
                                               contents: data,
                                               attributes: nil)
                
                Log.i("Successfully saved \(T.self) to storage")
                observer.onNext(object)
                observer.onCompleted()
            } catch {
                Log.i("Failed to save \(T.self) to storage")
                observer.onError(StorageError.saveFailed(T.self))
            }
            
            return Disposables.create()
        }
    }
    
    /// Fetches specified object from either documents or caches directory.
    ///
    /// - Parameter objectType: The object type to fetch.
    /// - Returns: The fetched object. Will error if fetching failed.
    public func fetch<T>(_ objectType: T.Type) -> Observable<T> where T: Decodable {
        return Observable<T>.create { (observer) -> Disposable in
            let url = self
                .getURL(for: self.directory)
                .appendingPathComponent("\(T.self).type", isDirectory: false)
            
            guard FileManager.default.fileExists(atPath: url.path) else {
                Log.i("File does not exist for \(T.self) storage")
                observer.onCompleted()
                return Disposables.create()
            }
            
            guard let data = FileManager.default.contents(atPath: url.path) else {
                Log.i("Failed to fetch \(T.self) from storage")
                observer.onCompleted()
                return Disposables.create()
            }
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(objectType, from: data)
                Log.i("Successfully fetched \(T.self) from storage")
                observer.onNext(model)
            } catch {
                Log.e("Failed to fetch \(T.self) from storage")
                observer.onError(StorageError.fetchFailed(T.self))
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    /// Clears the directory used in initalization.
    public func clear() {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

// MARK: - Helper methods.
extension FileSystemCache {
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    public func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// Returns URL constructed from specified directory
    private func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
}
