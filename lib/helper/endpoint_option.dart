import 'package:restaurant_app/helper/base_request.dart';

class EndpointOption extends BaseRequest {
  EndpointOption({required this.url, this.id, this.query});

  String url;
  String? id;
  String? query;

  @override
  getData() {
    String _data = url;

    if (id != null) {
      _data += "/" + id.toString();
    }

    if (query != null) {
      _data += "?q=" + query.toString();
    }

    return Uri.parse(_data);
  }

  @override
  getId() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
