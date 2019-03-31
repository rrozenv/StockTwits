
import RxSwift

public protocol UsersUseCase {
    func fetchCurrentUser() -> Observable<User>
    func fetchUsers() -> Observable<UserEnvelope>
}


