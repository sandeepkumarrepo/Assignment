//
//  DetailViewController.swift
//  Assignment
//
//  Created by Sandeep Kumar on 16/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    // Variables
    @objc var viewModel: DetailViewModel = DetailViewModel()
    var detailView = DeliveryDetailView()
    var viewModelObserver: NSKeyValueObservation?
    
    // MARK: View life cycle
    override func loadView() {
        let backgroundView: UIView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.white
        self.view = backgroundView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizationConstant.detailViewTitle
        self.initialiseView()
        self.showInfoOnMap()
        self.addObserver()
    }
    
    deinit {
        viewModelObserver?.invalidate()
        viewModelObserver = nil
    }
    
    // MARK: Methods
    private func initialiseView() {
        self.view.addSubview(detailView)
        self.view.fullViewConstraints(detailView)
    }
    
    func addAnnotation(title: String, lattitude: Double, longitude: Double) {
        self.detailView.addAnnotation(title: title, lattitude: lattitude, longitude: longitude)
    }
}

extension DetailViewController: DeliveryDetailViewInterface {
    
    func showInfoOnMap() {
        self.showPin(lat: self.viewModel.model?.location?.lat ?? 0.0, long: self.viewModel.model?.location?.lng ?? 0.0, address: self.viewModel.model?.location?.address)
        self.refreshUI(description: self.viewModel.model?.descriptionText, imageUrl: self.viewModel.model?.imageUrl)
    }
    
    func showPin(lat: Double, long: Double, address: String?) {
        self.detailView.removeMapViewPinAnnotation()
        self.addAnnotation(title: address ?? "", lattitude: lat, longitude: long)
    }
    
    func refreshUI(description: String?, imageUrl: String?) {
        self.detailView.setBottomViewDetails(descriptionText: description ?? "", imageUrl: imageUrl ?? "")
    }
}

// Key-Value observer
extension DetailViewController {
    func addObserver() {
        viewModelObserver = viewModel.observe(\.model, options: .new, changeHandler: { [weak self] (detailModel, value) in
            guard let _ = value.newValue else {
                return
            }
            
            DispatchQueue.main.async {
                self?.showInfoOnMap()
            }
        })
    }
}
