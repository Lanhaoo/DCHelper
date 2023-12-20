//
//  DCOrderListTypeModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/8.
//

import Foundation
open class DCOrderListTypeModel: NSObject {
    var text = ""
    var value = 0
    var isSelected = false
    convenience init(text:String,value:Int,isSelected:Bool) {
        self.init()
        self.text = text
        self.value = value
        self.isSelected = isSelected
    }
    static func generateList()->[DCOrderListTypeModel]{
        return [
            DCOrderListTypeModel.init(text: "Pendiente de pago", value: 20, isSelected: false),
            DCOrderListTypeModel.init(text: "Presentar la solicitud", value: 10, isSelected: true),
            DCOrderListTypeModel.init(text: "Procesando", value: 30, isSelected: false),
            DCOrderListTypeModel.init(text: "Terminado", value: 40, isSelected: false)
        ]
    }
}
