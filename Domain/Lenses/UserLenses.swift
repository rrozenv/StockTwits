
import Prelude

extension User {
    public enum lens {
        public static let id = Lens<User, String>(
            view: { $0.id },
            set: { User(id: $0, name: $1.name) }
        )
        
        public static let name = Lens<User, String>(
            view: { $0.name },
            set: { User(id: $1.id, name: $0) }
        )
    }
}
