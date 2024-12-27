class DropdownItemModel {
  final String name;
  final String id;
  final List<String> employeesDeviceTokens;
  bool isSelected;

  DropdownItemModel(this.employeesDeviceTokens,
      {required this.name, this.isSelected = false, required this.id});
}
