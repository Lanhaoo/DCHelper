//
//  DCLoanAmountModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
public class DCLoanAmountModel: DCBaseModel,DCModelConvertible{
    public typealias ClassName = DCLoanAmountModel
    var loanAmount = ""
    var termDetailList = [DCLoanTermModel]()
    var sortedList:[DCLoanTermModel]{
        get{
            let list = termDetailList.sorted { (item0:DCLoanTermModel,item1:DCLoanTermModel) in
                return item0.loanTerm.toIntValue < item1.loanTerm.toIntValue
            }
            return list
        }
    }
    var minLoanTerm:DCLoanTermModel{
        get{
            return sortedList.first ?? DCLoanTermModel()
        }
    }
    var isSelected = false
}

