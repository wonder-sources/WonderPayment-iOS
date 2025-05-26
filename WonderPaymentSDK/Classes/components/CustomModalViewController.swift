//
//  Untitled.swift
//  Pods
//
//  Created by X on 2025/4/27.
//

import UIKit

class CustomModalViewController: UIViewController {

    var contentView: UIView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }
            if let newView = contentView {
                containerView.addSubview(newView)
            }
        }
    }
    var isModal: Bool = true // 决定点击遮罩时是否关闭

    // MARK: - Private Properties
    private let backgroundView = UIView()
    private let containerView = UIView()

    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .clear
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // ✅ 加一个手势，点击遮罩时触发
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        backgroundView.addGestureRecognizer(tapGesture)

        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.contentView?.center = self.containerView.center
        }
    }

    // MARK: - Public Methods
    func showWith(animated: Bool) {
        ModalCoordinator.shared.enqueueModal { done in
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            topViewController?.present(self, animated: animated)
            done()
        }
    }

    func hideWith(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        ModalCoordinator.shared.enqueueModal { done in
            self.dismiss(animated: animated) {
                completion?(true)
                done()
            }
        }
    }
    
    @discardableResult
    func hideWith(animated: Bool) -> Future<Bool> {
        return Future<Bool> { resolve, reject in
            hideWith(animated: animated) { completed in
                resolve(completed)
            }
        }
    }

    // MARK: - Actions
    @objc private func handleBackgroundTap() {
        if !isModal {
            hideWith(animated: true)
        }
    }
}


