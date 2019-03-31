
import RxSwift

public protocol ApplicationsUseCase {
    func fetchApplications() -> Observable<[Application]> 
}
