
import RxSwift
import RxCocoa

// Some code originally from here: https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L42-L62
// Credit to Artsy and @ashfurrow

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public extension SharedSequenceConvertibleType where E: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     
     - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
     */
    
    public func filterNil() -> SharedSequence<SharingStrategy,E.Wrapped> {
        return flatMap { element -> SharedSequence<SharingStrategy,E.Wrapped> in
            guard let value = element.value else {
                return SharedSequence<SharingStrategy,E.Wrapped>.empty()
            }
            return SharedSequence<SharingStrategy,E.Wrapped>.just(value)
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     
     - parameter valueOnNil: value to use when `nil` is encountered.
     
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    public func replaceNilWith(_ valueOnNil: E.Wrapped) -> SharedSequence<SharingStrategy,E.Wrapped> {
        return map { element -> E.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     
     - parameter handler: `nil` handler function that returns `Driver` of non-`nil` elements.
     
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    public func catchOnNil(_ handler: @escaping () -> SharedSequence<SharingStrategy,E.Wrapped>) -> SharedSequence<SharingStrategy,E.Wrapped> {
        return flatMap { element -> SharedSequence<SharingStrategy,E.Wrapped> in
            guard let value = element.value else {
                return handler()
            }
            return SharedSequence<SharingStrategy,E.Wrapped>.just(value)
        }
    }
}


public extension ObservableType where E: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    public func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
    
    /**
     
     Filters out `nil` elements. Similar to `filterNil`, but keeps the elements of the observable
     wrapped in Optionals. This is often useful for binding to a UIBindingObserver with an optional type.
     
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    public func filterNilKeepOptional() -> Observable<E> {
        return self.filter { element -> Bool in
            return element.value != nil
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     
     - parameter valueOnNil: value to use when `nil` is encountered.
     
     - returns: `Observable` of the source `Observable`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    public func replaceNilWith(_ valueOnNil: E.Wrapped) -> Observable<E.Wrapped> {
        return self.map { element -> E.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     
     - parameter handler: `nil` handler throwing function that returns `Observable` of non-`nil` elements.
     
     - returns: `Observable` of the source `Observable`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    public func catchOnNil(_ handler: @escaping () throws -> Observable<E.Wrapped>) -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return try handler()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
    
}
