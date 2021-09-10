// author: Brandon Williams @mbrandonw
// source: https://github.com/pointfreeco/swift-composable-architecture/blob/0938b8a17b3be424a3de386dd44c2d7457d831a1/Sources/ComposableArchitecture/SwiftUI/Lifecycle.swift

import ComposableArchitecture

public enum LifecycleAction<Action> {
    case onAppear
    case onDisappear
    case action(Action)
}

extension LifecycleAction: Equatable where Action: Equatable {}

extension Reducer {
    public func lifecycle(
        onAppear: @escaping (Environment) -> Effect<Action, Never> = {_ in .none },
        onDisappear: @escaping (Environment) -> Effect<Never, Never> = {_ in .none }
    ) -> Reducer<State?, LifecycleAction<Action>, Environment> {

        return .init { state, lifecycleAction, environment in
            switch lifecycleAction {
            case .onAppear:
                return onAppear(environment).map(LifecycleAction.action)

            case .onDisappear:
                return onDisappear(environment).fireAndForget()

            case let .action(action):
                guard state != nil else {
                    return .none
                }

                return self.run(&state!, action, environment)
                    .map(LifecycleAction.action)
            }
        }
    }
}
