/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
  // TODO: Implement properties to match the JSON structure of the API response
  // Sample response:
  // {
  //   "base_code": "USD",
  //   "time_last_update_unix": 1740690001,
  //   "conversion_rates": {
  //     "EUR": 0.9488,
  //     "GBP": 0.8393,
  //     "JPY": 136.57,
  //     ...
  //   }
  // }

  // Add properties for base currency
  public String base_code;

  // Add property for time last updated
  public String time_last_update_unix;

  // Add property for rates (using a map)
  public Map<String, Decimal> conversion_rates;

  // Add property for external ID
  // This is an ID you will generate to uniquely identify the exchange rate record
  // This does not come from the API response
  public String externalId; //baseCurrency + '_' + targetCurrency

  /**
   * @description Converts the wrapper data to a list of Exchange_Rate__c records
   * @return List<Exchange_Rate__c> The list of exchange rate records
   */
  public static List<Exchange_Rate__c> toExchangeRates(
    ExchangeRateWrapper rateData
  ) {
    // TODO: Implement the method to convert the wrapper data to Exchange_Rate__c records
    // 1. Create a list to hold the Exchange_Rate__c records
    // 2. Iterate through the rates map
    // 3. For each rate, create an Exchange_Rate__c record
    // 4. Return the list of records

    List<Exchange_Rate__c> exLst = new List<Exchange_Rate__c>();

    for (String curr : rateData.conversion_rates.keySet()) {
      Exchange_Rate__c er = new Exchange_Rate__c();
      er.Base_Currency__c = rateData.base_code;
      er.Rate__c = rateData.conversion_rates.get(curr);
      er.Target_Currency__c = curr;
      er.External_Id__c = rateData.base_code + '_' + curr;
      DateTime dateTimeUpdatedValue = DateTime.newInstance(
        Long.ValueOf(rateData.time_last_update_unix)
      );
      er.Last_Updated__c = dateTimeUpdatedValue;
      exLst.add(er);
    }
    return exLst;
  }

  /**
   * @description Static method to parse the JSON response into the wrapper class
   * @param jsonResponse The JSON response from the API
   * @return ExchangeRateWrapper The parsed wrapper instance
   */
  public static ExchangeRateWrapper parse(String jsonResponse) {
    return (ExchangeRateWrapper) JSON.deserialize(
      jsonResponse,
      ExchangeRateWrapper.class
    );
  }
}
