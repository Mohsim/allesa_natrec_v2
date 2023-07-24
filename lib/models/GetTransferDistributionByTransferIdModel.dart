class GetTransferDistributionByTransferIdModel {
  String? tRANSFERID;
  int? tRANSFERSTATUS;
  String? iNVENTLOCATIONIDFROM;
  String? iNVENTLOCATIONIDTO;
  String? iTEMID;
  String? iNVENTDIMID;
  int? qTYTRANSFER;
  int? qTYREMAINRECEIVE;
  String? cREATEDDATETIME;

  GetTransferDistributionByTransferIdModel(
      {this.tRANSFERID,
      this.tRANSFERSTATUS,
      this.iNVENTLOCATIONIDFROM,
      this.iNVENTLOCATIONIDTO,
      this.iTEMID,
      this.iNVENTDIMID,
      this.qTYTRANSFER,
      this.qTYREMAINRECEIVE,
      this.cREATEDDATETIME});

  GetTransferDistributionByTransferIdModel.fromJson(Map<String, dynamic> json) {
    tRANSFERID = json['TRANSFERID'];
    tRANSFERSTATUS = json['TRANSFERSTATUS'];
    iNVENTLOCATIONIDFROM = json['INVENTLOCATIONIDFROM'];
    iNVENTLOCATIONIDTO = json['INVENTLOCATIONIDTO'];
    iTEMID = json['ITEMID'];
    iNVENTDIMID = json['INVENTDIMID'];
    qTYTRANSFER = json['QTYTRANSFER'];
    qTYREMAINRECEIVE = json['QTYREMAINRECEIVE'];
    cREATEDDATETIME = json['CREATEDDATETIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TRANSFERID'] = tRANSFERID;
    data['TRANSFERSTATUS'] = tRANSFERSTATUS;
    data['INVENTLOCATIONIDFROM'] = iNVENTLOCATIONIDFROM;
    data['INVENTLOCATIONIDTO'] = iNVENTLOCATIONIDTO;
    data['ITEMID'] = iTEMID;
    data['INVENTDIMID'] = iNVENTDIMID;
    data['QTYTRANSFER'] = qTYTRANSFER;
    data['QTYREMAINRECEIVE'] = qTYREMAINRECEIVE;
    data['CREATEDDATETIME'] = cREATEDDATETIME;
    return data;
  }
}
