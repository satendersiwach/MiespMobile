import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scanner/common/enums.dart';
import 'package:scanner/models/user_model.dart';
import 'package:scanner/models/pick_list_item_detail_model.dart';
import 'package:scanner/services/api_exception.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:scanner/services/pick_list_service.dart';
import 'package:scanner/theme/custom_snack_bar.dart';

class PickListItemController extends GetxController {
  final List<int> pickListIds;

  PickListItemController({required this.pickListIds});

  final pickListItems = <PickListItemDetailModel>[].obs;
  final isLoading = true.obs;
  final pickListStatusEnum = PickListStatusEnum.notPicked.obs;
  final queryText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchItems() is called from the screen's initState after setting the status filter.
  }

  Future<void> fetchItems() async {
    pickListItems.clear();
    isLoading.value = true;
    try {
      final items = await PickListService.getListingItems(
        status: pickListStatusEnum.value == PickListStatusEnum.picked ? 'Y' : 'N',
        search: queryText.value,
        pickListId: pickListIds,
      );
      pickListItems.assignAll(items);
    } on ApiException catch (e) {
      CustomSnackBar.errorSnackBar(e.validationError ?? e.message);
    } catch (e) {
      CustomSnackBar.errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatusFilter(PickListStatusEnum status) {
    pickListStatusEnum.value = status;
    fetchItems();
  }

  void updateQuery(String query) {
    queryText.value = query;
  }

  Future<void> pickByBarcode(String barCode) async {
    if (await AuthService.isInternetAvailable()) {
      final user = UserModel.getLoginCustomer();
      debugPrint('pickByBarcode => barcode: "$barCode", user: "${user.username}"');
      try {
        await PickListService.pickByBarcode(
          barcode: barCode,
          user: user.username ?? '',
        );
        CustomSnackBar.successSnackBar('Picked successfully');
        fetchItems();
      } on ApiException catch (e) {
        CustomSnackBar.errorSnackBar(e.validationError ?? e.message);
      } catch (e) {
        CustomSnackBar.errorSnackBar(e.toString());
      }
    } else {
      CustomSnackBar.errorSnackBar('No internet connection');
    }
  }
}
