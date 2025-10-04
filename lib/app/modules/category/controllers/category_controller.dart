import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/repositories/category_repository.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/e_service_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class CategoryController extends GetxController {
  final category = Category().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  final heroTag = ''.obs;

  ScrollController scrollController = ScrollController();

  CategoryController() {
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

// old one
  // @override
  // Future<void> onInit() async {
  //   category.value = Get.arguments as Category;
  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
  //       loadEServicesOfCategory(category.value.id, filter: selected.value);
  //     }
  //   });
  //   await refreshEServices();
  //   super.onInit();
  // }

  // code like EServiceController, EProviderController
  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    print("KYToito argmnts CategoryController ${arguments.toString()}");
    category.value = arguments['category'] as Category;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  // code like EServiceController, EProviderController
  @override
  void onReady() async {
    await refreshEServices();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    await getCategory();
    await loadEServicesOfCategory(category.value.id, filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  Future getCategory() async {
    try {
      category.value = await _categoryRepository.get(category.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory(String categoryId, {CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
          break;
        default:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
      }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
