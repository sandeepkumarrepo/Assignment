//
//  ViewController+Delegate-DataSource.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
import UIKit

let cellIdentifier = "resuableIdentifier"
let someOffset: CGFloat = 170.0

extension DeliveryListView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerDelegate?.viewModel.deliveryItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CustomTableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomTableViewCell
        if cell == nil {
            cell = CustomTableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .gray
        }
        
        guard self.controllerDelegate?.viewModel.deliveryItems.count ?? 0 > indexPath.row else {
            return cell ?? UITableViewCell()
        }
        let record: DeliveryItemModel? = self.controllerDelegate?.viewModel.deliveryItems[indexPath.row] ?? nil
        cell?.deliveryModel = record
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= self.controllerDelegate?.viewModel.deliveryItems.count ?? 0 {
            // Index out of bound if in case
            return
        }
        
        // Valid index
        let detailVC = DetailViewController()
        let selectedRowModel: DeliveryItemModel? = self.controllerDelegate?.viewModel.deliveryItems[indexPath.row] ?? nil
        if selectedRowModel != nil {
            let detailViewModel = DetailViewModel(model: selectedRowModel!)
            detailVC.viewModel = detailViewModel
        }
        self.controllerDelegate?.navigate(controller: detailVC)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let yOffset = CGFloat((self.deliveryTableView?.contentOffset.y)!)
        let tableHeight = (self.deliveryTableView?.frame.size.height)!
        let contentsHeight = (self.deliveryTableView?.contentSize.height)!
        
        if (yOffset + tableHeight) >= (contentsHeight - someOffset) {
            self.fetchNextPageDetails()
        }
    }
}
