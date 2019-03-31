
import RxSwift
import Domain

public protocol UsersUseCase {
    func fetchCurrentUser() -> Observable<User>
    func fetchUsers() -> Observable<UserEnvelope>
}


