
import RxSwift
import RxCocoa

/**
Projects error emitted by observable into a seperate stream.
Use when the stream that emits an error should not terminate.
 */
public final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()
    
    public init() { }
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: onError).catchErrorReturnEmpty()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverIgnoreError()
    }
    
    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    public func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}
