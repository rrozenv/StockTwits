
import RxSwift
import Domain

public protocol ApplicationsUseCase {
    func fetchApplications() -> Observable<[Application]> 
}
