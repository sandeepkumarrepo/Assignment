//
//  DeliveryListView.swift
//  Assignment
//
//  Created by Sandeep Kumar on 25/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import Reachability
import Toast_Swift

let kRetryButtonWidth = 150
let kRetryButtonHeight = 60
let kActivityViewWidth = 100
let kActivityViewHeight = 44
let kRefreshViewWidth = 100
let kRefreshViewHeight = 44
let kXZero = 0
let kYZero = 0

class DeliveryListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var deliveryTableView: UITableView?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: kXZero, y: kYZero, width: kActivityViewWidth, height: kActivityViewHeight))
    var retryButton: UIButton = UIButton(type: .roundedRect)
    var refreshControlView: UIRefreshControl?
    weak var controllerDelegate: DeliveryListViewController?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeViews()
    }
    
    // MARK: Methods
    func initializeViews() {
        self.setupUI()
    }
    
    func setupUI() {
        // tableview
        deliveryTableView = UITableView()
        deliveryTableView?.delegate = self
        deliveryTableView?.dataSource = self
        deliveryTableView?.estimatedRowHeight = 120
        deliveryTableView?.rowHeight = UITableView.automaticDimension
        
        guard deliveryTableView != nil else {
            return
        }
        
        self.addSubview(deliveryTableView!)
        self.fullViewConstraints(self.deliveryTableView!)
        self.deliveryTableView?.isHidden = true
        
        // Button
        retryButton.frame = CGRect(x: kXZero, y: kYZero, width: kRetryButtonWidth, height: kRetryButtonHeight)
        retryButton.setTitle(LocalizationConstant.retryButtonTitle, for: .normal)
        retryButton.layer.borderColor = UIColor.blue.cgColor
        retryButton.layer.borderWidth = 0.8
        retryButton.addTarget(self, action: #selector(retryAgain), for: .touchUpInside)
        self.addSubview(retryButton)
        retryButton.center = self.center
        retryButton.isHidden = true
        
        // Activity view
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.red
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        
        // pull to refresh
        self.setupPullToRefreshView()
    }
    
    func setupPullToRefreshView() {
        guard deliveryTableView != nil else {
            return
        }
        
        // Refresh view
        refreshControlView = UIRefreshControl(frame: CGRect(x: kXZero, y: kYZero, width: kRefreshViewWidth, height: kRefreshViewHeight))
        refreshControlView?.tintColor = UIColor.red
        refreshControlView?.attributedTitle = NSAttributedString(string: LocalizationConstant.pullToRefreshText)
        refreshControlView?.addTarget(self, action: #selector(DeliveryListView.pullToRefresh), for: .valueChanged)
        guard refreshControlView != nil else {
            return
        }
        
        self.deliveryTableView?.addSubview(refreshControlView!)
    }
    
    @objc func updateView() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.retryButton.isHidden = true
            self?.deliveryTableView?.isHidden = false
            self?.deliveryTableView?.reloadData()
            self?.setupFooter(false)
        }
    }
    
    func showActivityView() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.center = self?.center ?? CGPoint.zero
            self?.activityIndicator.startAnimating()
            self?.retryButton.isHidden = true
        }
    }
}

// MARK: Pull to refresh
extension DeliveryListView {
    @objc func pullToRefresh() {
        self.controllerDelegate?.pullToRefresh()
    }
    
    func pullToRefreshFinished() {
        DispatchQueue.main.async {[weak self] in
            self?.refreshControlView?.endRefreshing()
            self?.refreshControlView?.attributedTitle = NSAttributedString(string: LocalizationConstant.pullToRefreshText)
        }
    }
    
    func pullToRefreshStarted() {
        DispatchQueue.main.async {[weak self] in
            self?.refreshControlView?.attributedTitle = NSAttributedString(string: LocalizationConstant.refreshing)
        }
    }
    
    func isPullToRefresh() -> Bool {
        return refreshControlView?.isRefreshing ?? false
    }
}

// MARK: Error Messages
extension DeliveryListView {
    func showMessage(message: String = LocalizationConstant.failMessage) {
        DispatchQueue.main.async {[weak self] in
            var style = ToastStyle()
            style.messageColor = UIColor.white
            style.backgroundColor = AppTheme.Color.appToastMessageBackgroundColor
            self?.makeToast(message, duration: 4.0, position: .top, style: style)
            self?.setupFooter(false)
            self?.hideAllActivityView()
        }
    }
    
    private func hideAllActivityView() {
        self.activityIndicator.stopAnimating()
        self.refreshControlView?.endRefreshing()
    }
}

// MARK: Pagination
extension DeliveryListView {
    func setupFooter(_ hasNextPage: Bool) {
        if hasNextPage {
            let view = UIActivityIndicatorView(frame: CGRect(x: kXZero, y: kYZero, width: kActivityViewWidth, height: kActivityViewHeight))
            view.style = .whiteLarge
            view.color = .red
            view.startAnimating()
            self.deliveryTableView?.tableFooterView = view
        } else {
            self.deliveryTableView?.tableFooterView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.deliveryTableView?.bounds.width ?? 0, height: 8))
        }
    }
    
    func fetchNextPageDetails() {
        self.controllerDelegate?.fetchLoadMoreData()
    }
}

// MARK: Retry
extension DeliveryListView {
    func showRetryButton() {
        DispatchQueue.main.async {[weak self] in
            self?.deliveryTableView?.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.retryButton.center = self?.center ?? CGPoint.zero
            self?.retryButton.isHidden = false
        }
    }
    
    @objc func retryAgain() {
        DispatchQueue.main.async {[weak self] in
            self?.controllerDelegate?.retryAgain()
        }
    }
}
