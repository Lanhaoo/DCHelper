//
//  DCWaitingView.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/20.
//

import Foundation
import UIKit
import SnapKit
public class DCWaitingView: UIView {
    
    public convenience init() {
        self.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.color = .white
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: scaleSize(70), height: scaleSize(70)))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        let textLabel = UILabel.init(mediumFontSize: 18, textColor: "#ffffff")
        textLabel.text = """
        Se está sometiendo su solicitud, esperecon paciencia por favor
        """
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(scaleSize(350))
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(scaleSize(30))
        }
    }
    
}
