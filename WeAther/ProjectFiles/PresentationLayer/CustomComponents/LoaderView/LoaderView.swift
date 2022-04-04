//
//  LoaderView.swift
//  FeedNow Customer
//
//  Created by IOS on 02/12/17.
//  Copyright © 2017 Ankush Chakraborty. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {
    @IBOutlet var vwActivity: NVActivityIndicatorView!
    @IBOutlet var labelProgress: UILabel!
    @IBOutlet var vwContainer: UIView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        vwContainer.frame = frame
        self.addSubview(vwContainer)    // adding the top level view to the view hierarchy
    }
    func startLoading(text: String) {
        vwActivity.startAnimating()
        labelProgress.text = text
    }
    func stopLoading() {
        vwActivity.stopAnimating()
    }
}
