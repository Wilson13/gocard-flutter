import 'dart:convert';

TransferResponse transferResponseFromJson(String str) => TransferResponse.fromJson(json.decode(str));

String transferResponseToJson(TransferResponse data) => json.encode(data.toJson());

class TransferResponse {
    String encodedKey;
    int transactionId;
    String parentAccountKey;
    String type;
    String comment;
    String creationDate;
    String entryDate;
    String amount;
    String interestAmount;
    String feesAmount;
    String overdraftAmount;
    String technicalOverdraftAmount;
    String fundsAmount;
    String feesPaid;
    String interestPaid;
    String technicalOverdraftInterestAmount;
    String fractionAmount;
    String preciseInterestAmount;
    String balance;
    Details details;
    String userKey;
    String branchKey;
    List<dynamic> savingsPredefinedFeeAmounts;
    String linkedSavingsTransactionKey;
    String productTypeKey;
    String currencyCode;
    String valueDate;
    String bookingDate;

    TransferResponse({
        this.encodedKey,
        this.transactionId,
        this.parentAccountKey,
        this.type,
        this.comment,
        this.creationDate,
        this.entryDate,
        this.amount,
        this.interestAmount,
        this.feesAmount,
        this.overdraftAmount,
        this.technicalOverdraftAmount,
        this.fundsAmount,
        this.feesPaid,
        this.interestPaid,
        this.technicalOverdraftInterestAmount,
        this.fractionAmount,
        this.preciseInterestAmount,
        this.balance,
        this.details,
        this.userKey,
        this.branchKey,
        this.savingsPredefinedFeeAmounts,
        this.linkedSavingsTransactionKey,
        this.productTypeKey,
        this.currencyCode,
        this.valueDate,
        this.bookingDate,
    });

    factory TransferResponse.fromJson(Map<String, dynamic> json) => TransferResponse(
        encodedKey: json["encodedKey"],
        transactionId: json["transactionId"],
        parentAccountKey: json["parentAccountKey"],
        type: json["type"],
        comment: json["comment"],
        creationDate: json["creationDate"],
        entryDate: json["entryDate"],
        amount: json["amount"],
        interestAmount: json["interestAmount"],
        feesAmount: json["feesAmount"],
        overdraftAmount: json["overdraftAmount"],
        technicalOverdraftAmount: json["technicalOverdraftAmount"],
        fundsAmount: json["fundsAmount"],
        feesPaid: json["feesPaid"],
        interestPaid: json["interestPaid"],
        technicalOverdraftInterestAmount: json["technicalOverdraftInterestAmount"],
        fractionAmount: json["fractionAmount"],
        preciseInterestAmount: json["preciseInterestAmount"],
        balance: json["balance"],
        details: Details.fromJson(json["details"]),
        userKey: json["userKey"],
        branchKey: json["branchKey"],
        savingsPredefinedFeeAmounts: List<dynamic>.from(json["savingsPredefinedFeeAmounts"].map((x) => x)),
        linkedSavingsTransactionKey: json["linkedSavingsTransactionKey"],
        productTypeKey: json["productTypeKey"],
        currencyCode: json["currencyCode"],
        valueDate: json["valueDate"],
        bookingDate: json["bookingDate"],
    );

    Map<String, dynamic> toJson() => {
        "encodedKey": encodedKey,
        "transactionId": transactionId,
        "parentAccountKey": parentAccountKey,
        "type": type,
        "comment": comment,
        "creationDate": creationDate,
        "entryDate": entryDate,
        "amount": amount,
        "interestAmount": interestAmount,
        "feesAmount": feesAmount,
        "overdraftAmount": overdraftAmount,
        "technicalOverdraftAmount": technicalOverdraftAmount,
        "fundsAmount": fundsAmount,
        "feesPaid": feesPaid,
        "interestPaid": interestPaid,
        "technicalOverdraftInterestAmount": technicalOverdraftInterestAmount,
        "fractionAmount": fractionAmount,
        "preciseInterestAmount": preciseInterestAmount,
        "balance": balance,
        "details": details.toJson(),
        "userKey": userKey,
        "branchKey": branchKey,
        "savingsPredefinedFeeAmounts": List<dynamic>.from(savingsPredefinedFeeAmounts.map((x) => x)),
        "linkedSavingsTransactionKey": linkedSavingsTransactionKey,
        "productTypeKey": productTypeKey,
        "currencyCode": currencyCode,
        "valueDate": valueDate,
        "bookingDate": bookingDate,
    };
}

class Details {
    String encodedKey;
    bool internalTransfer;

    Details({
        this.encodedKey,
        this.internalTransfer,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        encodedKey: json["encodedKey"],
        internalTransfer: json["internalTransfer"],
    );

    Map<String, dynamic> toJson() => {
        "encodedKey": encodedKey,
        "internalTransfer": internalTransfer,
    };
}
