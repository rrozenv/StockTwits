
import Foundation
import RxSwift

/**
 Subscribers may choose to listen to notifications for any object they are interested in.
 */
public protocol ObjectNotificationProtocol {
    var objectNotifier$: PublishSubject<(object: Any, action: ObjectAction)> { get }
}

extension ObjectNotificationProtocol {
    public func objectModified$<T>(_ objectType: T.Type) -> Observable<T> {
        return objectNotifier$
            .filter { $0.action == .modified }
            .map { $0.object as? T }
            .filterNil()
    }
    
    public func objectCreated$<T>(_ objectType: T.Type) -> Observable<T> {
        return objectNotifier$
            .filter { $0.action == .created }
            .map { $0.object as? T }
            .filterNil()
    }
    
    public func objectDeleted$<T>(_ objectType: T.Type) -> Observable<T> {
        return objectNotifier$
            .filter { $0.action == .deleted }
            .map { $0.object as? T }
            .filterNil()
    }
}
