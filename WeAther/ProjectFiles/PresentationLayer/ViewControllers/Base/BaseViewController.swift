//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import UIKit

class BaseViewController: UIViewController {
    private var vwLoader = LoaderView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Activity loader methods
extension BaseViewController {
    /// This function is used to show loader and message.
    /// - Parameter message: The message to be displayed.
    func showLoading(message: String) {
        DispatchQueue.main.async {
            self.vwLoader.labelProgress.text = ""
            self.view.isUserInteractionEnabled = false
            self.vwLoader.startLoading(text: message)
            guard let mainWindow = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
            mainWindow.addSubview(self.vwLoader)
            self.vwLoader.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                self.vwLoader.topAnchor.constraint(equalTo: mainWindow.topAnchor, constant: 0),
                self.vwLoader.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: 0),
                self.vwLoader.leftAnchor.constraint(equalTo: mainWindow.leftAnchor, constant: 0),
                self.vwLoader.rightAnchor.constraint(equalTo: mainWindow.rightAnchor, constant: 0)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    /// This function is used to show loader and message.
    func hideLoading() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.vwLoader.removeFromSuperview()
            self.vwLoader.stopLoading()
        }
    }
}
