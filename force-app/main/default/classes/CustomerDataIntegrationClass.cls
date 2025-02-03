public with sharing class CustomerDataIntegrationClass {
    public void retrieveCustomerData() {
        try{
            String endPointUrl = 'https://dd7be6f0a74f4918b79285ded41fcce6.api.mockbin.io/';

            //create HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPointUrl);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(60000);

            Http http = new Http();
            HttpResponse res = http.send(req);

            //process Response
            if(res.getStatusCode() == 200){
                String response = res.getBody();
                
                List<CustomerData> customers = (List<CustomerData>) JSON.deserialize(responseBody, List<CustomerData>.class);
                List<Account> accDataToUpsert = new List<Account>();
                for(CustomerData customer : customers){
                    Account acc = new Account();
                    acc.Name = customer.name;
                    accDataToUpsert.add(acc);
                }
                insert accDataToUpsert;
            } else {
                System.debug('Error: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }
    public class CustomerData {
        public String name;
    }
}