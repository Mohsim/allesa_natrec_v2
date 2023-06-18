class getWmsJournalCountingOnlyCLByAssignedToUserIdModel {
  String? iTEMID;
  String? iTEMNAME;
  String? iTEMGROUPID;
  String? gROUPNAME;
  String? iNVENTORYBY;
  String? tRXDATETIME;
  String? tRXUSERIDASSIGNED;
  String? tRXUSERIDASSIGNEDBY;
  int? qTYSCANNED;
  double? qTYDIFFERENCE;
  int? qTYONHAND;
  int? jOURNALID;
  String? bINLOCATION;

  getWmsJournalCountingOnlyCLByAssignedToUserIdModel(
      {this.iTEMID,
      this.iTEMNAME,
      this.iTEMGROUPID,
      this.gROUPNAME,
      this.iNVENTORYBY,
      this.tRXDATETIME,
      this.tRXUSERIDASSIGNED,
      this.tRXUSERIDASSIGNEDBY,
      this.qTYSCANNED,
      this.qTYDIFFERENCE,
      this.qTYONHAND,
      this.jOURNALID,
      this.bINLOCATION});

  getWmsJournalCountingOnlyCLByAssignedToUserIdModel.fromJson(
      Map<String, dynamic> json) {
    iTEMID = json['ITEMID'];
    iTEMNAME = json['ITEMNAME'];
    iTEMGROUPID = json['ITEMGROUPID'];
    gROUPNAME = json['GROUPNAME'];
    iNVENTORYBY = json['INVENTORYBY'];
    tRXDATETIME = json['TRXDATETIME'];
    tRXUSERIDASSIGNED = json['TRXUSERIDASSIGNED'];
    tRXUSERIDASSIGNEDBY = json['TRXUSERIDASSIGNEDBY'];
    qTYSCANNED = json['QTYSCANNED'];
    qTYDIFFERENCE = json['QTYDIFFERENCE'];
    qTYONHAND = json['QTYONHAND'];
    jOURNALID = json['JOURNALID'];
    bINLOCATION = json['BINLOCATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEMID'] = iTEMID;
    data['ITEMNAME'] = iTEMNAME;
    data['ITEMGROUPID'] = iTEMGROUPID;
    data['GROUPNAME'] = gROUPNAME;
    data['INVENTORYBY'] = iNVENTORYBY;
    data['TRXDATETIME'] = tRXDATETIME;
    data['TRXUSERIDASSIGNED'] = tRXUSERIDASSIGNED;
    data['TRXUSERIDASSIGNEDBY'] = tRXUSERIDASSIGNEDBY;
    data['QTYSCANNED'] = qTYSCANNED;
    data['QTYDIFFERENCE'] = qTYDIFFERENCE;
    data['QTYONHAND'] = qTYONHAND;
    data['JOURNALID'] = jOURNALID;
    data['BINLOCATION'] = bINLOCATION;
    return data;
  }
}
