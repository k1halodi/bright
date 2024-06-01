// ignore_for_file: file_names

class Company {
  final String _companyName;
  final String _companyWebsite;
  final String _industry;
  final List<String> _services;
  final String _overview;
  final String _companyPic;

  Company({
    required String companyName,
    required String companyWebsite,
    required String industry,
    List<String> services = const [],
    String overview = '',
    String companyPic = '',
  })  : _companyName = companyName,
        _companyWebsite = companyWebsite,
        _industry = industry,
        _services = services,
        _overview = overview,
        _companyPic = companyPic;

  String get companyName => _companyName;
  String get companyWebsite => _companyWebsite;
  String get industry => _industry;
  List<String> get services => _services;
  String get overview => _overview;
  String get companyPic => _companyPic;
}
