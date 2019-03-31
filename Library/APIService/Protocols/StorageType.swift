
import RxSwift

public protocol StorageType: Codable {
    func save<T: Encodable>(object: T) -> Observable<T>
    func fetch<T: Decodable>(_ objectType: T.Type) -> Observable<T>
    func clear()
}




