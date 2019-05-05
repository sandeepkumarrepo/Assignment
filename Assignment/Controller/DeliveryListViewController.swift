//
//  DeliveryListViewController.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import Toast_Swift
import Reachability

class DeliveryListViewController: UIViewController {
    
    // Variables
    @objc public var viewModel: (NSObject & DeliveryListViewModelInterface) = DeliveryListViewModel()
    var listView: DeliveryListView?
    var deliveryItemsObserver: NSKeyValueObservation?
    var errorMessageObserver: NSKeyValueObservation?
    var firstTimeRequestObserver: NSKeyValueObservation?
    var loadMoreRequestObserver: NSKeyValueObservation?
    var pullToRefreshRequestObserver: NSKeyValueObservation?
    
    // MARK: View life cycle
    override func loadView() {
        let backgroundView: UIView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.groupTableViewBackground
        self.view = backgroundView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addKeyValueObserver()
        viewModel.populateData()
    }
    
    deinit {
        deliveryItemsObserver?.invalidate()
        deliveryItemsObserver = nil
        errorMessageObserver?.invalidate()
        errorMessageObserver = nil
        firstTimeRequestObserver?.invalidate()
        firstTimeRequestObserver = nil
        loadMoreRequestObserver?.invalidate()
        loadMoreRequestObserver = nil
        pullToRefreshRequestObserver?.invalidate()
        pullToRefreshRequestObserver = nil
    }
    
    // MARK: Methods
    func setupUI() {
        // Title
        self.title = LocalizationConstant.listViewTitle
        
        self.listView = DeliveryListView()
        guard listView != nil else {
            return
        }
        self.listView?.controllerDelegate = self
        self.listView?.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(listView!)
        self.view.fullViewConstraints(listView!)
    }
    
    @objc func retryAgain() {
        DispatchQueue.main.async {[weak self] in
            self?.viewModel.populateData()
        }
    }
    
    func fetchLoadMoreData() {
        self.viewModel.loadMoreData()
    }
    
    func showError(message: String) {
        if self.viewModel.deliveryItems.isEmpty {
            self.listView?.showRetryButton()
        }
        self.listView?.showMessage(message: message)
    }
    
    func deliveriesUpdated() {
        self.listView?.updateView()
    }
    
    @objc func navigate(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: key-value observer
extension DeliveryListViewController {
    private func deliveryItemsObserverWrapper<T: NSObject & DeliveryListViewModelInterface>(_ vm: T) -> NSKeyValueObservation {
        return vm.observe(\.deliveryItems, options: .new, changeHandler: { [weak self] (model, value) in
            if self?.viewModel.deliveryItems.isEmpty ?? true {
                return
            }
            self?.deliveriesUpdated()
        })
    }
    
    private func errorMessageObserverWrapper<T: NSObject & DeliveryListViewModelInterface>(_ vm: T) -> NSKeyValueObservation {
        return vm.observe(\.errorMessage, options: .new, changeHandler: {[weak self] (model, value) in
            guard let _ = value.newValue else {
                return
            }
            self?.showError(message: self?.viewModel.errorMessage ?? LocalizationConstant.failMessage )
        })
    }
    
    private func firstTimeRequestObserverWrapper<T: NSObject & DeliveryListViewModelInterface>(_ vm: T) -> NSKeyValueObservation {
        return vm.observe(\.isFirstTimeRequest, options: [.old, .new], changeHandler: { [weak self] (model, value) in
            DispatchQueue.main.async { [weak self] in
                if value.newValue == true {
                    // request started
                    self?.listView?.showActivityView()
                } else {
                    // request stopped
                    if self?.viewModel.deliveryItems.isEmpty ?? true {
                        self?.listView?.showRetryButton()
                    } else {
                        self?.listView?.updateView()
                    }
                }
            }
        })
    }

    private func loadMoreRequestObserverWrapper<T: NSObject & DeliveryListViewModelInterface>(_ vm: T) -> NSKeyValueObservation {
        return vm.observe(\.isLoadMoreRequest, options: [.old, .new], changeHandler: { [weak self] (model, value) in
            DispatchQueue.main.async { [weak self] in
                if value.newValue == true {
                    // request started
                    self?.listView?.setupFooter(true)
                } else {
                    // request stopped
                    self?.listView?.setupFooter(false)
                }
            }
        })
    }
    
    private func pullToRefreshRequestObserverWrapper<T: NSObject & DeliveryListViewModelInterface>(_ vm: T) -> NSKeyValueObservation {
        return vm.observe(\.isPullToRefreshRequest, options: [.old, .new], changeHandler: { [weak self] (model, value) in
            DispatchQueue.main.async { [weak self] in
                if value.newValue == true {
                    // request started
                    self?.listView?.pullToRefreshStarted()
                } else {
                    // request stopped
                    self?.listView?.pullToRefreshFinished()
                }
            }
        })
    }
    
    func addKeyValueObserver() {
        deliveryItemsObserver = deliveryItemsObserverWrapper(viewModel)
        errorMessageObserver = errorMessageObserverWrapper(viewModel)
        firstTimeRequestObserver = firstTimeRequestObserverWrapper(viewModel)
        loadMoreRequestObserver = loadMoreRequestObserverWrapper(viewModel)
        pullToRefreshRequestObserver = pullToRefreshRequestObserverWrapper(viewModel)
    }
}

// MARK: Pull to refresh
extension DeliveryListViewController {
    @objc func pullToRefresh() {
        // Get data from server
        self.viewModel.fetchDeliveriesWithPullToRefresh { (done, error) in

        }
    }
}
