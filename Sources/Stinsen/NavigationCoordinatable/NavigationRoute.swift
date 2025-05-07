import Foundation
import SwiftUI

protocol NavigationOutputable {
    func using(coordinator: Any, input: Any) -> ViewPresentable
}

public protocol RouteType {
    
}

public struct RootSwitch: RouteType {

}

public struct Presentation: RouteType {
    let type: PresentationType
}

public struct Transition<T: NavigationCoordinatable, U: RouteType, Input, Output: ViewPresentable>: NavigationOutputable {
    let type: U
    let closure: ((T) -> ((Input) -> Output))
    var screenName: String

    func using(coordinator: Any, input: Any) -> ViewPresentable {
        if Input.self == Void.self {
            return closure(coordinator as! T)(() as! Input)
        } else {
            return closure(coordinator as! T)(input as! Input)
        }
    }
}

@propertyWrapper public class NavigationRoute<T: NavigationCoordinatable, U: RouteType, Input, Output: ViewPresentable> {
    
    public var wrappedValue: Transition<T, U, Input, Output>
    
    init(standard: Transition<T, U, Input, Output>) {
        self.wrappedValue = standard
    }
}

// 1. Input == Void, Output == AnyView, Presentation
extension NavigationRoute where T: NavigationCoordinatable, Input == Void, Output == AnyView, U == Presentation {
    public convenience init<ViewOutput: View>(
        wrappedValue: @escaping ((T) -> (() -> ViewOutput)),
        _ presentation: PresentationType,
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: Presentation(type: presentation),
            closure: { coordinator in
                return { _ in AnyView(wrappedValue(coordinator)()) }
            },
            screenName: screenName
        ))
    }
}

// 2. Any Input, Output == AnyView, Presentation
extension NavigationRoute where T: NavigationCoordinatable, Output == AnyView, U == Presentation {
    public convenience init<ViewOutput: View>(
        wrappedValue: @escaping ((T) -> ((Input) -> ViewOutput)),
        _ presentation: PresentationType,
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: Presentation(type: presentation),
            closure: { coordinator in { input in AnyView(wrappedValue(coordinator)(input)) } },
            screenName: screenName
        ))
    }
}

// 3. Input == Void, Output: Coordinatable, Presentation
extension NavigationRoute where T: NavigationCoordinatable, Input == Void, Output: Coordinatable, U == Presentation {
    public convenience init(
        wrappedValue: @escaping ((T) -> (() -> Output)),
        _ presentation: PresentationType,
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: Presentation(type: presentation),
            closure: { coordinator in { _ in wrappedValue(coordinator)() } },
            screenName: screenName
        ))
    }
}

// 4. Any Input, Output: Coordinatable, Presentation
extension NavigationRoute where T: NavigationCoordinatable, Output: Coordinatable, U == Presentation {
    public convenience init(
        wrappedValue: @escaping ((T) -> ((Input) -> Output)),
        _ presentation: PresentationType,
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: Presentation(type: presentation),
            closure: { coordinator in { input in wrappedValue(coordinator)(input) } },
            screenName: screenName
        ))
    }
}

// 5. Input == Void, Output == AnyView, RootSwitch
extension NavigationRoute where T: NavigationCoordinatable, Input == Void, Output == AnyView, U == RootSwitch {
    public convenience init<ViewOutput: View>(
        wrappedValue: @escaping ((T) -> (() -> ViewOutput)),
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: RootSwitch(),
            closure: { coordinator in { _ in AnyView(wrappedValue(coordinator)()) } },
            screenName: screenName
        ))
    }
}

// 6. Any Input, Output == AnyView, RootSwitch
extension NavigationRoute where T: NavigationCoordinatable, Output == AnyView, U == RootSwitch {
    public convenience init<ViewOutput: View>(
        wrappedValue: @escaping ((T) -> ((Input) -> ViewOutput)),
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: RootSwitch(),
            closure: { coordinator in { input in AnyView(wrappedValue(coordinator)(input)) } },
            screenName: screenName
        ))
    }
}

// 7. Input == Void, Output: Coordinatable, RootSwitch
extension NavigationRoute where T: NavigationCoordinatable, Input == Void, Output: Coordinatable, U == RootSwitch {
    public convenience init(
        wrappedValue: @escaping ((T) -> (() -> Output)),
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: RootSwitch(),
            closure: { coordinator in { _ in wrappedValue(coordinator)() } },
            screenName: screenName
        ))
    }
}

// 8. Any Input, Output: Coordinatable, RootSwitch
extension NavigationRoute where T: NavigationCoordinatable, Output: Coordinatable, U == RootSwitch {
    public convenience init(
        wrappedValue: @escaping ((T) -> ((Input) -> Output)),
        _ screenName: String
    ) {
        self.init(standard: Transition(
            type: RootSwitch(),
            closure: { coordinator in { input in wrappedValue(coordinator)(input) } },
            screenName: screenName
        ))
    }
}
