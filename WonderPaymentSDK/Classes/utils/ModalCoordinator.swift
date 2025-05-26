//
//  ModalCoordinator.swift
//  Pods
//
//  Created by X on 2025/4/30.
//

final class ModalCoordinator {

    static let shared = ModalCoordinator()
    
    private var queue: [() -> Void] = []
    private var isProcessing: Bool = false

    private init() {}

    /// 入队一个模态操作（如 present 或 dismiss）
    func enqueue(_ action: @escaping () -> Void) {
        queue.append(action)
        processNextIfNeeded()
    }

    /// 当前操作完成后调用，用于执行下一个队列任务
    func finishCurrent() {
        isProcessing = false
        processNextIfNeeded()
    }

    /// 尝试执行队列中的下一个任务
    private func processNextIfNeeded() {
        guard !isProcessing, !queue.isEmpty else { return }
        isProcessing = true
        let next = queue.removeFirst()
        next()
    }
}

extension ModalCoordinator {
    func enqueueModal(_ action: @escaping (@escaping () -> Void) -> Void) {
        enqueue {
            action {
                ModalCoordinator.shared.finishCurrent()
            }
        }
    }
}
