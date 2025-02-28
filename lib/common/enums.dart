enum PickListStatusEnumForAdmin { assigned, closed, open, all }

enum PickListStatusEnumForUser { notPicked, picked, all }

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
