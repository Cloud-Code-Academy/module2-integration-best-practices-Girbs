/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {
  // The named credential to use for the callout
  private static final String NAMED_CREDENTIAL =
    'ExchangeRate_API' + '/latest/USD';

  // The base currency to use for exchange rates
  private static final String BASE_CURRENCY = 'USD';

  /**
   * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
   * @return ExchangeRateWrapper containing the response data
   */
  public static ExchangeRateWrapper getLatestRates() {
    // TODO: Implement the method to make a callout to the Exchange Rate API
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:' + NAMED_CREDENTIAL);
    req.setMethod('GET');
    Http http = new Http();
    HttpResponse res = http.send(req);
    if (res.getStatusCode() == 200) {
      return ExchangeRateWrapper.parse(res.getBody());
    }
    return null;
  }

  /**
   * @description Processes the exchange rate data and creates or updates records
   * @param rateData The wrapper containing exchange rate data
   * @return List<Exchange_Rate__c> The list of records created or updated
   */
  public static List<Exchange_Rate__c> processRates(
    ExchangeRateWrapper rateData
  ) {
    // TODO: Implement the method to process rates and create/update records
    List<Exchange_Rate__c> exRateLst = new List<Exchange_Rate__c>();

    if (rateData != null) {
      exRateLst = ExchangeRateWrapper.toExchangeRates(rateData);

      if (exRateLst.size() > 0) {
        try {
          upsert exRateLst;
        } catch (Exception e) {
          System.debug('Should have thrown an exception');
        }
      }
    }
    return exRateLst; // Replace with actual implementation
  }

  /**
   * @description Combines getting and processing rates into a single operation
   * @return List<Exchange_Rate__c> The list of records created or updated
   */
  public static List<Exchange_Rate__c> updateExchangeRates() {
    // TODO: Implement the method to get and process rates
    // 1. Call getLatestRates to retrieve the data
    // 2. Call processRates to create/update records
    // 3. Return the processed records
    List<Exchange_Rate__c> exRateLst = new List<Exchange_Rate__c>();
    if (getLatestRates() != null) {
      exRateLst = ExchangeRateWrapper.toExchangeRates(getLatestRates());
      if (exRateLst.size() > 0) {
        try {
          upsert exRateLst;
        } catch (Exception e) {
          System.debug('Should have thrown an exception');
        }
      }
    }
    return exRateLst;
  }
}
