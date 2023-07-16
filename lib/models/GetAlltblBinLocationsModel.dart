class GetAlltblBinLocationsModel {
  String? groupWarehouse;
  String? zones;
  String? binNumber;
  String? zoneType;
  num? binHeight;
  num? binRow;
  num? binWidth;
  num? binTotalSize;
  String? binType;

  GetAlltblBinLocationsModel(
      {this.groupWarehouse,
      this.zones,
      this.binNumber,
      this.zoneType,
      this.binHeight,
      this.binRow,
      this.binWidth,
      this.binTotalSize,
      this.binType});

  GetAlltblBinLocationsModel.fromJson(Map<String, dynamic> json) {
    groupWarehouse = json['GroupWarehouse'];
    zones = json['Zones'];
    binNumber = json['BinNumber'];
    zoneType = json['ZoneType'];
    binHeight = json['BinHeight'];
    binRow = json['BinRow'];
    binWidth = json['BinWidth'];
    binTotalSize = json['BinTotalSize'];
    binType = json['BinType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GroupWarehouse'] = groupWarehouse;
    data['Zones'] = zones;
    data['BinNumber'] = binNumber;
    data['ZoneType'] = zoneType;
    data['BinHeight'] = binHeight;
    data['BinRow'] = binRow;
    data['BinWidth'] = binWidth;
    data['BinTotalSize'] = binTotalSize;
    data['BinType'] = binType;
    return data;
  }
}
