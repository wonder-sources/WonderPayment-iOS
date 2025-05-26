//
//  Future.swift
//  Pods
//
//  Created by X on 2025/4/14.
//

import Foundation

final class Future<T> {
    private var result: Result<T, Error>?
    private var successCallbacks: [(T) -> Void] = []
    private var failureCallbacks: [(Error) -> Void] = []

    init(_ executor: (_ resolve: @escaping (T) -> Void, _ reject: @escaping (Error) -> Void) -> Void) {
        executor(self.resolve, self.reject)
    }

    private func resolve(_ value: T) {
        if result == nil {
            result = .success(value)
            successCallbacks.forEach { $0(value) }
            clearCallbacks()
        }
    }

    private func reject(_ error: Error) {
        if result == nil {
            result = .failure(error)
            failureCallbacks.forEach { $0(error) }
            clearCallbacks()
        }
    }

    private func clearCallbacks() {
        successCallbacks.removeAll()
        failureCallbacks.removeAll()
    }

    @discardableResult
    func then<U>(_ transform: @escaping (T) throws -> Future<U>) -> Future<U> {
        return Future<U> { resolve, reject in
            self.onSuccess { value in
                do {
                    let nextFuture = try transform(value)
                    nextFuture.then(resolve).catch(reject)
                } catch {
                    reject(error)
                }
            }.onFailure { error in
                reject(error)
            }
        }
    }

    @discardableResult
    func then<U>(_ transform: @escaping (T) throws -> U) -> Future<U> {
        return Future<U> { resolve, reject in
            self.onSuccess { value in
                do {
                    let result = try transform(value)
                    resolve(result)
                } catch {
                    reject(error)
                }
            }.onFailure { error in
                reject(error)
            }
        }
    }

    @discardableResult
    func `catch`(_ handler: @escaping (Error) -> Void) -> Self {
        return self.onFailure(handler)
    }

    private func onSuccess(_ handler: @escaping (T) -> Void) -> Self {
        if case .success(let value)? = result {
            handler(value)
        } else {
            successCallbacks.append(handler)
        }
        return self
    }

    @discardableResult
    private func onFailure(_ handler: @escaping (Error) -> Void) -> Self {
        if case .failure(let error)? = result {
            handler(error)
        } else {
            failureCallbacks.append(handler)
        }
        return self
    }
}


extension Future {
    @discardableResult
    static func delay(_ seconds: TimeInterval, _ block: @escaping () throws -> T) -> Future<T> {
        return Future { resolve, reject in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                do {
                    let result = try block()
                    resolve(result)
                } catch {
                    reject(error)
                }
            }
        }
    }

    @discardableResult
    static func delay(_ seconds: TimeInterval) -> Future<Void> {
        return Future<Void> { resolve, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                resolve(())
            }
        }
    }
}


extension Future {
    @discardableResult
    func map<U>(_ transform: @escaping (T) throws -> U) -> Future<U> {
        return Future<U> { resolve, reject in
            self.then { value in
                do {
                    let transformed = try transform(value)
                    resolve(transformed)
                } catch {
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    @discardableResult
    func flatMap<U>(_ transform: @escaping (T) throws -> Future<U>) -> Future<U> {
        return Future<U> { resolve, reject in
            self.then { value in
                do {
                    let nextFuture = try transform(value)
                    nextFuture.then(resolve).catch(reject)
                } catch {
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
}

extension Future {
    static func value<U>(_ value: U) -> Future<U> {
        return Future<U> { resolve, reject in
            resolve(value)
        }
    }
}
