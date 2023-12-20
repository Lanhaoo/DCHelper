//
//  DCTapGestureRecognizer.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//

import UIKit

public class DCTapGestureRecognizer: UITapGestureRecognizer {
    private var tapAction: (() -> Void)?
    convenience init(tapAction: (() -> Void)?) {
        self.init()
        self.numberOfTapsRequired = 1
        self.numberOfTouchesRequired = 1
        self.tapAction = tapAction
        self.addTarget(self, action: #selector(handleTap(_:)))
    }
    @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        tapAction?()
    }
}
