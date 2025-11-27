import 'package:taskflow_app/config/app_config.dart';

class Endpoints {
  static String get baseUrl => AppConfig.instance.apiBaseUrl;
  static String get token => AppConfig.instance.tokenEndpoint;
  static String get companyIdEndpoint => AppConfig.instance.companyIdEndpoint;

  // Combined endpoint with company ID
  static String get baseUrlWithCompany => '$baseUrl$companyIdEndpoint';

  static String get usersEndpoint => '/resources';
  static String get productsEndpoint => '/items2';
  static String get productsInTaskEndpoint => '/serviceLines';
  static String get tasksEndpoint => '/serviceHeaders';
  static String get imagesEndpoint => '/attachments';
  static String get taskLinesEndpoint => '/serviceItemLines';
  static String get commentsEndpoint => '/serviceCommentLines';
  static String get collaborationsEndpoint => '/serviceHeaderTimesheets';
  static String get locationsEndpoint => '/locations';
  static String get transferHeadersEndpoint => '/transferHeaders';
  static String get transferLinesEndpoint => '/transferLines';
  static String get transferReceiptLinesEndpoint => '/transferReceiptLines';

  // New V2 Image endpoints for two-step upload/retrieval process
  static String get attachmentsV2Endpoint => '/attachmentsV2';
  static String attachmentsV2FileContentEndpoint(String systemId) =>
      '/attachmentsV2($systemId)/fileContent';
  static String tenantMediasFileContentEndpoint(String documentReferenceID) =>
      '/tenantMedias($documentReferenceID)/fileContent';
}
