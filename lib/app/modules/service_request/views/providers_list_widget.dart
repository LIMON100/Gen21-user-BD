import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/provider_model.dart';

// import '../../../models/providers_model.dart';
import '../../../models/providers_model.dart';
import '../../../routes/app_routes.dart';
import '../../category/widgets/services_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/RequestController.dart';

class ProvidersListWidget extends StatelessWidget {
  final Data data;
  final int serviceIndex;
  final RequestController _requestController = Get.put(RequestController());

  ProvidersListWidget({Key key, Data this.data, this.serviceIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("sdnfjnsall ${data.toString()}");
    return Container(
        color: Colors.grey.withOpacity(.15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.only(bottom: 15, top: 15),
            child: Text("${data.name.en}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                )),
          ),
          data.eProvider.length > 0
              ? Container(
                  height: 355,
                  color: Get.theme.primaryColor.withOpacity(.50),
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.eProvider.length,
                      itemBuilder: (_, itemIndex) {
                        var _provider = data.eProvider[itemIndex];
                        return GestureDetector(
                          onTap: () {
                            // Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _service, 'heroTag': 'recommended_carousel'});
                            print("ksajfjja clicked: serviceIndex: $serviceIndex index: $itemIndex _provider.id: ${_provider.id} name: ${_requestController.providersData[serviceIndex].name.en}");
                            // _requestController.providersData[serviceIndex].selectedIndex.value = "$index";
                            _requestController.updateSelectProviders(serviceIndex, itemIndex, _requestController.providersData[serviceIndex].name.en, "${_provider.id}");
                            // _requestController.update();

                          },
                          child: Container(
                            width: 180,
                            margin: EdgeInsetsDirectional.only(end: 20, start: itemIndex == 0 ? 20 : 0, top: 20, bottom: 10),
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                            ),
                            child: Column(
                              //alignment: AlignmentDirectional.topStart,
                              children: [
                                Stack(
                                  children: [
                                    Hero(
                                      tag: 'recommended_carousel' + "_service.id",
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: _provider.media.length > 0 ? _provider.media[0].url : "https://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg",
                                          placeholder: (context, url) => Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 100,
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                        ),
                                      ),
                                    ),
                                    Obx(() {
                                      print("sdjfnkja Obx() called serviceIndex: $serviceIndex index: $itemIndex selected: ${_requestController.providersData[serviceIndex].selectedIndex.value}");
                                      return "$itemIndex" == _requestController.providersData[serviceIndex].selectedIndex.value
                                          ? Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: BoxDecoration(shape: BoxShape.circle, color: Get.theme.colorScheme.secondary),
                                                padding: EdgeInsets.all(3),
                                                margin: EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                              ))
                                          : Container();
                                    }),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                  height: 125,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        _provider.name.en ?? '',
                                        maxLines: 2,
                                        style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                                      ),
                                      Wrap(
                                        children: Ui.getStarsList(_provider.rate??0.00),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes.E_PROVIDER_NEW, arguments: {'eProviderId': _provider.id, 'heroTag': 'e_service_details'});
                                            },

                                            child: Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                                child: Text(
                                                  "See details",
                                                  style: TextStyle(color: Colors.black),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text("No Provider Found For This Service", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal)),
                ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 5),
            // margin: EdgeInsets.only(top: 15),
          )
        ]));
    // });
  }
}
