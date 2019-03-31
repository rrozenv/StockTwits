
import RxSwift
import RxCocoa

/**
Helper operaters on ObservableType.
 */
extension ObservableType {
    
    public func catchErrorReturnEmpty() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    public func catchErrorMap(to error: Error) -> Observable<E> {
        return catchError { _ in
            return .error(error)
        }
    }
    
    public func asDriverIgnoreError() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}

/**
 Helper operaters on SharedSequenceConvertibleType.
 */
extension SharedSequenceConvertibleType {
    
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
}

/**
Maps a netowrk data response to an expected codeable object.
 */
extension ObservableType {
    
    public func mapObject<T: Codable, E: Error & Codable>(type: T.Type, errorType: E.Type? = nil) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1,
                let statusCode = responseTuple?.0.statusCode else {
                    return Observable.error(NetworkError.serverFailed)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard 200..<300 ~= statusCode else {
                guard let errorType = errorType else {
                    return Observable.error(NetworkError.serverError(nil, statusCode))
                }
                let error = try? decoder.decode(errorType, from: jsonData)
                return Observable.error(NetworkError.serverError(error, statusCode))
            }
            
            do {
                let object = try decoder.decode(T.self, from: jsonData)
                return Observable.just(object)
            } catch {
                return Observable.error(NetworkError.decodingError(String(describing: T.self)))
            }
        }
    }
    
    public func mapArray<T: Codable, E: Error & Codable>(type: T.Type, errorType: E.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1,
                let statusCode = responseTuple?.0.statusCode else {
                    return Observable.error(NetworkError.serverFailed)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard 200..<300 ~= statusCode else {
                let error = try? decoder.decode(errorType, from: jsonData)
                return Observable.error(NetworkError.serverError(error, statusCode))
            }
            
            do {
                let objects = try decoder.decode([T].self, from: jsonData)
                return Observable.just(objects)
            } catch {
                return Observable.error(NetworkError.decodingError(String(describing: T.self)))
            }
        }
    }
    
}
