enum PickListStatusEnumForAdmin { assigned, closed, open, all }

enum PickListStatusEnumForUser { notPicked, picked, all }
enum InventoryStatusEnum { all, onlyInInventory, onlyInSAP, quantityMismatch }

enum PickListStatusEnum { notPicked, picked }

String getEnumLabel(var value) {
  switch (value) {
    case PickListStatusEnumForAdmin.assigned:
      return 'Assigned';
    case PickListStatusEnumForAdmin.closed:
      return 'Closed';
    case PickListStatusEnumForAdmin.open:
      return 'Open';
    case PickListStatusEnumForAdmin.all || PickListStatusEnumForUser.all:
      return 'All';
    case PickListStatusEnumForUser.notPicked || PickListStatusEnum.notPicked:
      return 'Not Picked';
    case PickListStatusEnumForUser.picked || PickListStatusEnum.picked:
      return 'Picked';
    default:
      return '';
  }
}

enum Mode { add, update, remove }

String getModeLabel(Mode value) {
  switch (value) {
    case Mode.add:
      return 'Add';
    case Mode.update:
      return 'Update';
    case Mode.remove:
      return 'Remove';
    default:
      return '';
  }
}

String getPickListStatusFromEnum({required var pickListStatusEnum}) {
  if (pickListStatusEnum == PickListStatusEnumForAdmin.assigned ||
      pickListStatusEnum == PickListStatusEnumForUser.notPicked) {
    return 'A';
  }
  if (pickListStatusEnum == PickListStatusEnumForAdmin.closed) {
    return 'C';
  }
  if (pickListStatusEnum == PickListStatusEnumForAdmin.open) {
    return 'O';
  }
  if (pickListStatusEnum == PickListStatusEnumForUser.picked) {
    return 'P';
  }
  if (pickListStatusEnum == PickListStatusEnumForAdmin.all ||
      pickListStatusEnum == PickListStatusEnumForUser.all) {
    return 'All';
  } else {
    return '';
  }
}

String getInventoryStatus({required InventoryStatusEnum pickListStatusEnum}) {
  if (pickListStatusEnum == InventoryStatusEnum.onlyInInventory) {
    return 'OnlyInInventory';
  }
  if (pickListStatusEnum == InventoryStatusEnum.onlyInSAP) {
    return 'OnlyInSAP';
  }
  if (pickListStatusEnum == InventoryStatusEnum.quantityMismatch) {
    return 'QuantityMismatch';
  } else {
    return 'All';
  }
}
