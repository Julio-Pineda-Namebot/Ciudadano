import "package:dartz/dartz.dart";
import "package:flutter_contacts_service/flutter_contacts_service.dart";
import "package:permission_handler/permission_handler.dart";

class ChatLocalSource {
  Future<Either<String, List<String>>> getPhoneContacts() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      return const Left("Permiso denegado");
    }

    if (status.isPermanentlyDenied) {
      return const Left("Permiso permanentemente denegado");
    }

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
