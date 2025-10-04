import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';

class MessagesController extends GetxController {
  final uploading = false.obs;
  var message = Message([]).obs;
  ChatRepository _chatRepository;
  NotificationRepository _notificationRepository;
  AuthService _authService;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = false.obs;
  final isDone = false.obs;
  ScrollController scrollController = ScrollController();
  final chatTextController = TextEditingController();
  var isHaveToShowProgressView = false.obs;

  MessagesController() {
    _chatRepository = new ChatRepository();
    _notificationRepository = new NotificationRepository();
    _authService = Get.find<AuthService>();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Pet Car Company'));
    print("fdafgagtaf onInit() called");
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        await listenForMessages();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    print("fdafgagtaf onClose() called");
    chatTextController.dispose();
  }

  Future createMessage(Message _message) async {
    print("fdafgagtaf createMessage() called");

    _message.users.insert(0, _authService.user.value);
    _message.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    _message.readByUsers = [_authService.user.value.id];

    message.value = _message;

    _chatRepository.createMessage(_message).then((value) {
      listenForChats();
    });
  }

  Future deleteMessage(Message _message) async {
    print("fdafgagtaf deleteMessage() called");

    messages.remove(_message);
    await _chatRepository.deleteMessage(_message);
  }

  Future refreshMessages({showProgressView = false}) async {
    print("nsjkdnkjfsan refreshMessages() settinging: $showProgressView");
    update();
    isHaveToShowProgressView.value = showProgressView;
    messages.clear();
    lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();
    print("nsjkdnkjfsan refreshMessages() settinging showProgressView = false");

    isHaveToShowProgressView.value = false;
    update();
  }

  Future<List<Message>> getUserAndProviderMessageId(String providerId) async {
    print("fdafgagtafppp getUserAndProviderMessages() called providerId:$providerId  _authService.user.value.id: ${_authService.user.value.id}");
    var completer = Completer<List<Message>>();
    var messages2 = <Message>[].obs;
    Stream<QuerySnapshot> _userMessages2 = await _chatRepository.getUserMessagesForId(_authService.user.value.id);
     _userMessages2.listen((QuerySnapshot query)  {
      print("sndnfdsnjsd query.toString(): ${query.toString()}");

      if (query.docs.isNotEmpty) {
        printWrapped("fdafgagtaf test query.docs: ${query.docs.toString()}");

        query.docs.forEach((element) {
          messages2.add(Message.fromDocumentSnapshot(element));
        });

        printWrapped("sndnfdsnjsd 1 messages2.length: ${messages2.length} ${messages2.toString()}");

        if (messages2.length > 0) {
          messages2.removeWhere((element) => !element.visibleToUsers.contains(providerId));
        }

        printWrapped("sndnfdsnjsd 2 messages2.length: ${messages2.length} ${messages2.toString()}");

      } else {
        printWrapped("sndnfdsnjsd query empty");
      }
      completer.complete(messages2);
    });

    printWrapped("fdafgagtaf returning messages2 ${messages2.toString()}");
    // return messages2;
    return completer.future;
  }

  Future listenForMessages() async {
    // messages.clear();
    print("hfha87ew listenForMessages() called");
    isLoading.value = true;

    isDone.value = false;
    Stream<QuerySnapshot> _userMessages;
    if (lastDocument.value == null) {
      _userMessages = _chatRepository.getUserMessages(_authService.user.value.id);
      printWrapped("hfha87ew 1 _userMessages.length ${_userMessages.length}");
      // _userMessages.forEach((element) {
      //   printWrapped("hfha87ew element.toString(): ${element.toString()}");
      // });

    } else {
      _userMessages = _chatRepository.getUserMessagesStartAt(_authService.user.value.id, lastDocument.value);
      printWrapped("hfha87ew 2 _userMessages ${_userMessages.toString()}");
    }
    _userMessages.listen((QuerySnapshot query) {
      printWrapped("hfha87ew query ${query.toString()}");
      messages.clear();
      if (query.docs.isNotEmpty) {
        printWrapped("hfha87ew query.docs: ${query.docs.toString()}");
        query.docs.forEach((element) {
          printWrapped("hfha87ew element: ${element.toString()}");
          messages.add(Message.fromDocumentSnapshot(element));
        });

        printWrapped("hfha87ew messages.length: ${messages.length} messages: ${messages.toString()}");

        lastDocument.value = query.docs.last;

        printWrapped("hfha87ew lastDocument.valuetoString ${lastDocument.value.toString()}");
      } else {
        print("hfha87ew in else: done");
        isDone.value = true;
      }

    });
    isLoading.value = false;
  }

  listenForChats() async {
    print("sjfsdkafds listenForChats() called");
    print("sjfsdkafds message.value in listenForChats(): ${ message.value.toString()}");
    chats.clear();
    message.value = await _chatRepository.getMessage(message.value);
    print("sjfsdkafds message.value in listenForChats(): ${ message.value.toString()}");
    message.value.readByUsers.add(_authService.user.value.id);
    print("sjfsdkafds in listenForChats() messages.length: ${ messages.length} messages.value  after readByUsers: ${ messages.toString()}");

    _chatRepository.getChats(message.value).listen((event) {
      chats.assignAll(event);
      print("sjfsdkafds chats.length: ${chats.length}");
    });

    print("sjfsdkafds in listenForChats() messages.length: ${ messages.length} messages.value  after getChats: ${ messages.toString()}");

  }

  addMessage(Message _message, String text) {
    print("fdafgagtafppp addMessage() called");

    Chat _chat = new Chat(text, DateTime.now().millisecondsSinceEpoch, _authService.user.value.id, _authService.user.value);
    if (_message.id == null) {
      _message.id = UniqueKey().toString();
      createMessage(_message);
    }
    _message.lastMessage = text;
    _message.lastMessageTime = _chat.time;
    _message.readByUsers = [_authService.user.value.id];
    uploading.value = false;
    _chatRepository.addMessage(_message, _chat).then((value) {}).then((value) {
      List<User> _users = [];
      _users.addAll(_message.users);
      _users.removeWhere((element) => element.id == _authService.user.value.id);
      _notificationRepository.sendNotification(_users, _authService.user.value, "App\\Notifications\\NewMessage", text.contains("https://firebasestorage.googleapis.com/")? "Image Attached": text, _message.id);
    });
  }

  Future getImage(ImageSource source) async {
    print("fdafgagtaf getImage() called");

    ImagePicker imagePicker = ImagePicker();
    XFile pickedFile;

    pickedFile = await imagePicker.pickImage(source: source);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      try {
        uploading.value = true;
        return await _chatRepository.uploadFile(imageFile);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }
  }
  //
  //
  // String getChatName(Message message){
  //   var userNames = <String>[];
  //   message.users.forEach((element) {
  //     if(element.id != _authService.user.value.id){
  //       userNames.add(element.name);
  //     }
  //   });
  //   String chatName = userNames.join(', ');
  //   return chatName;
  // }
}
