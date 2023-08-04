import '../domains/domains_map.dart';
import '../model/domain_model.dart';

class Disposable {
  Disposable._();

  static final Disposable instance = Disposable._();

  /// [hasValidEmail] Method Check the provide email is valid (means non Disposable) then it will return true else false
  ///
  /// Example:
  ///
  /// zain@gmail.com <- this is Valid email Domain
  ///
  /// zain@mailinator.com <- this is Disposable
  bool? hasValidEmail(String email) {
    const at = '@';
    final domainItem = _loadDomainItem();
    final model = DomainModel.fromJson(domainItem);

    if (!email.contains(at)) {
      return false;
    }

    var domainName = email.split(at).last;

    if ((model.domainItems ?? []).contains(domainName)) {
      return false;
    }
    return true;
  }

  static Map<String, dynamic> _loadDomainItem() {
    const Map<String, dynamic> domainData = DomainItems.items;
    return domainData;
  }
}
