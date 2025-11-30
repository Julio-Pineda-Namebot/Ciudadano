import "package:ciudadano/features/chats/domain/entities/contact_permission_status.dart";
import "package:dartz/dartz.dart";
import "package:permission_handler/permission_handler.dart";
import "package:flutter_contacts_service/flutter_contacts_service.dart";

class ChatLocalPermissionSource {
  Future<ContactPermissionStatus> requestPermission() async {
    final status = await Permission.contacts.request();

    if (status.isGranted) {
      return ContactPermissionStatus.granted;
    } else if (status.isPermanentlyDenied) {
      return ContactPermissionStatus.permanentlyDenied;
    } else {
      return ContactPermissionStatus.denied;
    }
  }

  Future<Either<String, List<String>>> getContactPhones() async {
    final contacts = await FlutterContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );

    List<String> phoneNumbers = [];

    for (final contact in contacts) {
      for (final phone in contact.phones ?? []) {
        phoneNumbers.add(phone.value.replaceAll(RegExp(r"\D"), ""));
      }
    }

    return Right(phoneNumbers);
  }
}
