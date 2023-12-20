//
//  DCOrderItemModel.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/8.
//

import Foundation
public enum DCOrderStatus: Int {
    case unowned = 0
    case dataToCapture = 10
    case underReview = 30
    case rejected = 31
    case readyForWithdrawal = 32
    case inDisbursement = 50
    case changeBankCard = 36
    case refund = 60
    case delayed = 61
    case settled = 70
    case cancelled = 99
}
open class DCOrderItemModel: DCBaseModel,DCModelConvertible {
    public typealias ClassName = DCOrderItemModel
    var reductionAmount = ""
    var interestAmount = ""
    var shouldRepaymentAmount = ""
    var riskDate = ""
    var applyDate = ""
    var receiptAmount = ""
    var loanTerm = 0
    var alreadyRepaymentAmount = ""
    var repaymentDate = ""
    var penaltyDays = 0
    var loanAmount = ""
    var payoutDate = ""
    var taxAmount = ""
    var penaltyAmount = ""
    var orderStatus = 0
    var dueDate = ""
    var repaymentExtensionFeeAmount = ""
    var repayExtensionFeeAmount = ""
    var showTerm = ""
    var orderId = ""
    var feeAmount = ""
    var loanTermUnit = 0
    var totalRepaymentAmount = ""
    var loanDate = ""
    var repayDate = ""
    var productName = ""
    var productId = ""
    
    var orderStatusType:DCOrderStatus{
        get{
            if let status = DCOrderStatus.init(rawValue: orderStatus) {
                return status
            }
            return .unowned
        }
    }
}
