//
//  DCLoanProductModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public class DCLoanProductModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCLoanProductModel
    var amountDetailList = [DCLoanAmountModel]()
    var productId = ""
    var productLogo = ""
    var productName = ""
    var bankCardList = [DCUserBankCardModel]()
    var sortedList:[DCLoanAmountModel]{
        get{
            let list = amountDetailList.sorted { (item0:DCLoanAmountModel,item1:DCLoanAmountModel) in
                return item0.loanAmount.toIntValue > item1.loanAmount.toIntValue
            }
            if list.count > 0{
                list[0].isSelected = true
            }
            return list
        }
    }
    var maxAmount:DCLoanAmountModel{
        get{
            return sortedList.first ?? DCLoanAmountModel()
        }
    }
}
