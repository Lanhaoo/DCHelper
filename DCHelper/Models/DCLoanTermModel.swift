//
//  DCLoanTermModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/7.
//

import Foundation
open class DCLoanTermModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCLoanTermModel
    var loanTerm = ""
    var showTerm = ""
    var feeAmount = ""
    var taxAmount = ""
    var repaymentAmount = ""
    var borrowingDate = ""
    var repaymentDate = ""
    var arrivalAmount = ""
    var interestAmount = ""
}
