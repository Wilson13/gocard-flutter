import 'dart:convert';

GetCaResponse getCaResponseFromJson(String str) => GetCaResponse.fromJson(json.decode(str));

String getCaResponseToJson(GetCaResponse data) => json.encode(data.toJson());

class GetCaResponse {
    String encodedKey;
    String id;
    String accountHolderKey;
    String accountHolderType;
    String name;
    String creationDate;
    String approvedDate;
    String activationDate;
    String lastModifiedDate;
    String lastInterestCalculationDate;
    String lastAccountAppraisalDate;
    String productTypeKey;
    String accountType;
    String accountState;
    String balance;
    String accruedInterest;
    String overdraftInterestAccrued;
    String technicalOverdraftInterestAccrued;
    String overdraftAmount;
    String technicalOverdraftAmount;
    InterestSettings interestSettings;
    InterestSettings overdraftInterestSettings;
    String interestDue;
    String technicalInterestDue;
    String feesDue;
    String overdraftLimit;
    bool allowOverdraft;
    String assignedBranchKey;
    String lockedBalance;
    String holdBalance;
    String interestPaymentPoint;
    String currencyCode;
    Currency currency;
    String availableBalance;

    GetCaResponse({
        this.encodedKey,
        this.id,
        this.accountHolderKey,
        this.accountHolderType,
        this.name,
        this.creationDate,
        this.approvedDate,
        this.activationDate,
        this.lastModifiedDate,
        this.lastInterestCalculationDate,
        this.lastAccountAppraisalDate,
        this.productTypeKey,
        this.accountType,
        this.accountState,
        this.balance,
        this.accruedInterest,
        this.overdraftInterestAccrued,
        this.technicalOverdraftInterestAccrued,
        this.overdraftAmount,
        this.technicalOverdraftAmount,
        this.interestSettings,
        this.overdraftInterestSettings,
        this.interestDue,
        this.technicalInterestDue,
        this.feesDue,
        this.overdraftLimit,
        this.allowOverdraft,
        this.assignedBranchKey,
        this.lockedBalance,
        this.holdBalance,
        this.interestPaymentPoint,
        this.currencyCode,
        this.currency,
        this.availableBalance,
    });

    factory GetCaResponse.fromJson(Map<String, dynamic> json) => GetCaResponse(
        encodedKey: json["encodedKey"],
        id: json["id"],
        accountHolderKey: json["accountHolderKey"],
        accountHolderType: json["accountHolderType"],
        name: json["name"],
        creationDate: json["creationDate"],
        approvedDate: json["approvedDate"],
        activationDate: json["activationDate"],
        lastModifiedDate: json["lastModifiedDate"],
        lastInterestCalculationDate: json["lastInterestCalculationDate"],
        lastAccountAppraisalDate: json["lastAccountAppraisalDate"],
        productTypeKey: json["productTypeKey"],
        accountType: json["accountType"],
        accountState: json["accountState"],
        balance: json["balance"],
        accruedInterest: json["accruedInterest"],
        overdraftInterestAccrued: json["overdraftInterestAccrued"],
        technicalOverdraftInterestAccrued: json["technicalOverdraftInterestAccrued"],
        overdraftAmount: json["overdraftAmount"],
        technicalOverdraftAmount: json["technicalOverdraftAmount"],
        interestSettings: InterestSettings.fromJson(json["interestSettings"]),
        overdraftInterestSettings: InterestSettings.fromJson(json["overdraftInterestSettings"]),
        interestDue: json["interestDue"],
        technicalInterestDue: json["technicalInterestDue"],
        feesDue: json["feesDue"],
        overdraftLimit: json["overdraftLimit"],
        allowOverdraft: json["allowOverdraft"],
        assignedBranchKey: json["assignedBranchKey"],
        lockedBalance: json["lockedBalance"],
        holdBalance: json["holdBalance"],
        interestPaymentPoint: json["interestPaymentPoint"],
        currencyCode: json["currencyCode"],
        currency: Currency.fromJson(json["currency"]),
        availableBalance: json["availableBalance"],
    );

    Map<String, dynamic> toJson() => {
        "encodedKey": encodedKey,
        "id": id,
        "accountHolderKey": accountHolderKey,
        "accountHolderType": accountHolderType,
        "name": name,
        "creationDate": creationDate,
        "approvedDate": approvedDate,
        "activationDate": activationDate,
        "lastModifiedDate": lastModifiedDate,
        "lastInterestCalculationDate": lastInterestCalculationDate,
        "lastAccountAppraisalDate": lastAccountAppraisalDate,
        "productTypeKey": productTypeKey,
        "accountType": accountType,
        "accountState": accountState,
        "balance": balance,
        "accruedInterest": accruedInterest,
        "overdraftInterestAccrued": overdraftInterestAccrued,
        "technicalOverdraftInterestAccrued": technicalOverdraftInterestAccrued,
        "overdraftAmount": overdraftAmount,
        "technicalOverdraftAmount": technicalOverdraftAmount,
        "interestSettings": interestSettings.toJson(),
        "overdraftInterestSettings": overdraftInterestSettings.toJson(),
        "interestDue": interestDue,
        "technicalInterestDue": technicalInterestDue,
        "feesDue": feesDue,
        "overdraftLimit": overdraftLimit,
        "allowOverdraft": allowOverdraft,
        "assignedBranchKey": assignedBranchKey,
        "lockedBalance": lockedBalance,
        "holdBalance": holdBalance,
        "interestPaymentPoint": interestPaymentPoint,
        "currencyCode": currencyCode,
        "currency": currency.toJson(),
        "availableBalance": availableBalance,
    };
}

class Currency {
    String code;
    String name;
    String symbol;
    int digitsAfterDecimal;
    String currencySymbolPosition;
    bool isBaseCurrency;
    String creationDate;
    String lastModifiedDate;

    Currency({
        this.code,
        this.name,
        this.symbol,
        this.digitsAfterDecimal,
        this.currencySymbolPosition,
        this.isBaseCurrency,
        this.creationDate,
        this.lastModifiedDate,
    });

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: json["code"],
        name: json["name"],
        symbol: json["symbol"],
        digitsAfterDecimal: json["digitsAfterDecimal"],
        currencySymbolPosition: json["currencySymbolPosition"],
        isBaseCurrency: json["isBaseCurrency"],
        creationDate: json["creationDate"],
        lastModifiedDate: json["lastModifiedDate"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "symbol": symbol,
        "digitsAfterDecimal": digitsAfterDecimal,
        "currencySymbolPosition": currencySymbolPosition,
        "isBaseCurrency": isBaseCurrency,
        "creationDate": creationDate,
        "lastModifiedDate": lastModifiedDate,
    };
}

class InterestSettings {
    String interestRate;
    String encodedKey;
    String interestChargeFrequency;
    int interestChargeFrequencyCount;
    String interestRateSource;
    String interestRateTerms;
    List<dynamic> interestRateTiers;
    bool accrueInterestAfterMaturity;

    InterestSettings({
        this.interestRate,
        this.encodedKey,
        this.interestChargeFrequency,
        this.interestChargeFrequencyCount,
        this.interestRateSource,
        this.interestRateTerms,
        this.interestRateTiers,
        this.accrueInterestAfterMaturity,
    });

    factory InterestSettings.fromJson(Map<String, dynamic> json) => InterestSettings(
        interestRate: json["interestRate"],
        encodedKey: json["encodedKey"],
        interestChargeFrequency: json["interestChargeFrequency"],
        interestChargeFrequencyCount: json["interestChargeFrequencyCount"],
        interestRateSource: json["interestRateSource"],
        interestRateTerms: json["interestRateTerms"],
        interestRateTiers: List<dynamic>.from(json["interestRateTiers"].map((x) => x)),
        accrueInterestAfterMaturity: json["accrueInterestAfterMaturity"],
    );

    Map<String, dynamic> toJson() => {
        "interestRate": interestRate,
        "encodedKey": encodedKey,
        "interestChargeFrequency": interestChargeFrequency,
        "interestChargeFrequencyCount": interestChargeFrequencyCount,
        "interestRateSource": interestRateSource,
        "interestRateTerms": interestRateTerms,
        "interestRateTiers": List<dynamic>.from(interestRateTiers.map((x) => x)),
        "accrueInterestAfterMaturity": accrueInterestAfterMaturity,
    };
}
