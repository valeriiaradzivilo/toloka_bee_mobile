import '../../models/contact_info_model.dart';

abstract class ContactsDataSource {
  Future<ContactInfoModel> saveContact(final ContactInfoModel info);
  Future<void> updateContact(final ContactInfoModel info);
  Future<ContactInfoModel> getContactById(final String id);
  Future<ContactInfoModel?> getContactByUserId(final String userId);
  Future<void> deleteContactById(final String id);
}
