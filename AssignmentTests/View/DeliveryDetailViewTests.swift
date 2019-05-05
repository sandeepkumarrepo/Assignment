//
//  DeliveryDetailViewTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 27/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
import MapKit
@testable import Assignment

class DeliveryDetailViewTests: XCTestCase {
    let detailView = DeliveryDetailView()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCTAssertNotNil(detailView.mapView)
        XCTAssertNotNil(detailView.bottomDetailView)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMapViewAnnotation() {
        let mapView = detailView.mapView
        let annotationView = detailView.mapView(mapView, viewFor: MKPointAnnotation())
        XCTAssertNotNil(annotationView)
    }
    
    func testMapViewDelegate() {
        XCTAssertTrue(detailView.conforms(to: MKMapViewDelegate.self))
    }
    
    func testAddAnnotation() {
        detailView.addAnnotation(title: "test", lattitude: 22.0202, longitude: 122.2200)
        XCTAssertNotNil(detailView.pinAnnotation)
    }
    
    func testRemoveAnnotation() {
        detailView.removeMapViewPinAnnotation()
        XCTAssertEqual(detailView.mapView.annotations.count, 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
