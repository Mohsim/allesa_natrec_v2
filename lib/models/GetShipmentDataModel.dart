class GetShipmentDataModel {
  int? sHIPMENTSTATUS;
  String? sHIPMENTID;
  String? eNTITY;
  String? cONTAINERID;
  String? aRRIVALWAREHOUSE;
  String? iTEMNAME;
  int? qTY;
  String? iTEMID;
  String? pURCHID;
  int? cLASSIFICATION;

  GetShipmentDataModel(
      {this.sHIPMENTSTATUS,
      this.sHIPMENTID,
      this.eNTITY,
      this.cONTAINERID,
      this.aRRIVALWAREHOUSE,
      this.iTEMNAME,
      this.qTY,
      this.iTEMID,
      this.pURCHID,
      this.cLASSIFICATION});

  GetShipmentDataModel.fromJson(Map<String, dynamic> json) {
    sHIPMENTSTATUS = json['SHIPMENTSTATUS'];
    sHIPMENTID = json['SHIPMENTID'];
    eNTITY = json['ENTITY'];
    cONTAINERID = json['CONTAINERID'];
    aRRIVALWAREHOUSE = json['ARRIVALWAREHOUSE'];
    iTEMNAME = json['ITEMNAME'];
    qTY = json['QTY'];
    iTEMID = json['ITEMID'];
    pURCHID = json['PURCHID'];
    cLASSIFICATION = json['CLASSIFICATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SHIPMENTSTATUS'] = sHIPMENTSTATUS;
    data['SHIPMENTID'] = sHIPMENTID;
    data['ENTITY'] = eNTITY;
    data['CONTAINERID'] = cONTAINERID;
    data['ARRIVALWAREHOUSE'] = aRRIVALWAREHOUSE;
    data['ITEMNAME'] = iTEMNAME;
    data['QTY'] = qTY;
    data['ITEMID'] = iTEMID;
    data['PURCHID'] = pURCHID;
    data['CLASSIFICATION'] = cLASSIFICATION;
    return data;
  }
}
