

import Foundation
import NeedleFoundation

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class UseCaseDependencyeca02f9f14b46d7bef13Provider: UseCaseDependency {
    var loginRepository: LoginRepository {
        return repositoryComponent.loginRepository
    }
    private let repositoryComponent: RepositoryComponent
    init(repositoryComponent: RepositoryComponent) {
        self.repositoryComponent = repositoryComponent
    }
}
/// ^->RootComponent->RepositoryComponent->UseCaseComponent
private func factory4bd264da426f0f0f91de268771e90d305157e475(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UseCaseDependencyeca02f9f14b46d7bef13Provider(repositoryComponent: parent1(component) as! RepositoryComponent)
}
private class RepositoryDependency7488f146cdfa18e51394Provider: RepositoryDependency {
    var httpHandler: HTTPHandler {
        return rootComponent.httpHandler
    }
    var userDefaults: UserDefaults {
        return rootComponent.userDefaults
    }
    var tokenHolder: TokenHolder {
        return rootComponent.tokenHolder
    }
    var memberIdHolder: MemberIDHolder {
        return rootComponent.memberIdHolder
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->RepositoryComponent
private func factory89fed910da85ca3e434eb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RepositoryDependency7488f146cdfa18e51394Provider(rootComponent: parent1(component) as! RootComponent)
}
private class ViewDependency7e2be0e2453dfb7da242Provider: ViewDependency {
    var loginUseCase: LoginUseCase {
        return useCaseComponent.loginUseCase
    }
    private let useCaseComponent: UseCaseComponent
    init(useCaseComponent: UseCaseComponent) {
        self.useCaseComponent = useCaseComponent
    }
}
/// ^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent
private func factorybc1f70be8cdc74da692586232a38d99b994a7c3d(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ViewDependency7e2be0e2453dfb7da242Provider(useCaseComponent: parent1(component) as! UseCaseComponent)
}
private class ViewDependency2d05baf2a225739e88ddProvider: ViewDependency {
    var loginUseCase: LoginUseCase {
        return useCaseComponent.loginUseCase
    }
    private let useCaseComponent: UseCaseComponent
    init(useCaseComponent: UseCaseComponent) {
        self.useCaseComponent = useCaseComponent
    }
}
/// ^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->RootViewComponent
private func factoryb962e1f756407c56d5c947637391edf639535c30(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ViewDependency2d05baf2a225739e88ddProvider(useCaseComponent: parent2(component) as! UseCaseComponent)
}
private class ViewDependencya066cca12a017381e547Provider: ViewDependency {
    var loginUseCase: LoginUseCase {
        return useCaseComponent.loginUseCase
    }
    private let useCaseComponent: UseCaseComponent
    init(useCaseComponent: UseCaseComponent) {
        self.useCaseComponent = useCaseComponent
    }
}
/// ^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->LoginViewComponent
private func factorydf14166407f8267db8d447637391edf639535c30(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ViewDependencya066cca12a017381e547Provider(useCaseComponent: parent2(component) as! UseCaseComponent)
}
private class ViewDependency915e8bb5061576cf8943Provider: ViewDependency {
    var loginUseCase: LoginUseCase {
        return useCaseComponent.loginUseCase
    }
    private let useCaseComponent: UseCaseComponent
    init(useCaseComponent: UseCaseComponent) {
        self.useCaseComponent = useCaseComponent
    }
}
/// ^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->ProfileViewComponent
private func factorye1083ab469cee3a5626347637391edf639535c30(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ViewDependency915e8bb5061576cf8943Provider(useCaseComponent: parent2(component) as! UseCaseComponent)
}

#else
extension RootComponent: Registration {
    public func registerItems() {

        localTable["httpHandler-HTTPHandler"] = { [unowned self] in self.httpHandler as Any }
        localTable["userDefaults-UserDefaults"] = { [unowned self] in self.userDefaults as Any }
        localTable["tokenHolder-TokenHolder"] = { [unowned self] in self.tokenHolder as Any }
        localTable["memberIdHolder-MemberIDHolder"] = { [unowned self] in self.memberIdHolder as Any }
    }
}
extension UseCaseComponent: Registration {
    public func registerItems() {
        keyPathToName[\UseCaseDependency.loginRepository] = "loginRepository-LoginRepository"
        localTable["loginUseCase-LoginUseCase"] = { [unowned self] in self.loginUseCase as Any }
    }
}
extension RepositoryComponent: Registration {
    public func registerItems() {
        keyPathToName[\RepositoryDependency.httpHandler] = "httpHandler-HTTPHandler"
        keyPathToName[\RepositoryDependency.userDefaults] = "userDefaults-UserDefaults"
        keyPathToName[\RepositoryDependency.tokenHolder] = "tokenHolder-TokenHolder"
        keyPathToName[\RepositoryDependency.memberIdHolder] = "memberIdHolder-MemberIDHolder"
        localTable["loginRepository-LoginRepository"] = { [unowned self] in self.loginRepository as Any }
    }
}
extension ViewComponent: Registration {
    public func registerItems() {
        keyPathToName[\ViewDependency.loginUseCase] = "loginUseCase-LoginUseCase"

    }
}
extension RootViewComponent: Registration {
    public func registerItems() {
        keyPathToName[\ViewDependency.loginUseCase] = "loginUseCase-LoginUseCase"
    }
}
extension LoginViewComponent: Registration {
    public func registerItems() {
        keyPathToName[\ViewDependency.loginUseCase] = "loginUseCase-LoginUseCase"
    }
}
extension ProfileViewComponent: Registration {
    public func registerItems() {
        keyPathToName[\ViewDependency.loginUseCase] = "loginUseCase-LoginUseCase"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->RepositoryComponent->UseCaseComponent", factory4bd264da426f0f0f91de268771e90d305157e475)
    registerProviderFactory("^->RootComponent->RepositoryComponent", factory89fed910da85ca3e434eb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent", factorybc1f70be8cdc74da692586232a38d99b994a7c3d)
    registerProviderFactory("^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->RootViewComponent", factoryb962e1f756407c56d5c947637391edf639535c30)
    registerProviderFactory("^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->LoginViewComponent", factorydf14166407f8267db8d447637391edf639535c30)
    registerProviderFactory("^->RootComponent->RepositoryComponent->UseCaseComponent->ViewComponent->ProfileViewComponent", factorye1083ab469cee3a5626347637391edf639535c30)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
