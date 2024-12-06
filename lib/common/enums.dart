//A - Assigned Picklist, C - Closed, O - Open, All - To get all pick list without any filter
enum PickListStatusEnum { assigned, closed, open, all }

String getEnumLabel(PickListStatusEnum value) {
  switch (value) {
    case PickListStatusEnum.assigned:
      return 'Assigned';
    case PickListStatusEnum.closed:
      return 'Closed';
    case PickListStatusEnum.open:
      return 'Open';
    case PickListStatusEnum.all:
      return 'All';
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
