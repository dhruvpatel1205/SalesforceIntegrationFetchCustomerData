@isTest
public with sharing class CustomerDataIntegrationTestClass {
    @isTest
    public static void CustomerDataIntegrationTestClass() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200,'OK','[{"name":"Test Account"}]'));
        Test.startTest();
        CustomerDataIntegrationClass customerDataIntegration = new CustomerDataIntegrationClass();
        customerDataIntegration.retrieveCustomerData();
        Test.stopTest();

        List<Account> accountCreated = [SELECT Name from Account];
        System.assertEquals(1, accountCreated.size(),'One Test Account should be created');
        System.assertEquals('Test Account', accountCreated[0].Name,'Account Name should be Test Account');
    }
    @isTest
    public static void testErrorHandling() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404,'Not Found',''));
        Test.startTest();
        CustomerDataIntegrationClass customerDataIntegration = new CustomerDataIntegrationClass();
        customerDataIntegration.retrieveCustomerData();
        Test.stopTest();
        List<Account> accountCreated = [SELECT Name FROM Account];
        System.assertEquals(0, accountCreated.size(), 'No accounts were created on Error 404');
    }
    @isTest
    public static void testExceptionHandling() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200,'OK','Invalid JSON'));
        Test.startTest();
        CustomerDataIntegrationClass customerDataIntegration = new CustomerDataIntegrationClass();
        customerDataIntegration.retrieveCustomerData();
        Test.stopTest();
        List<Account> accountCreated = [SELECT Name FROM Account];
        System.assertEquals(0, accountCreated.size(), 'No accounts were created on JSON error');
    }
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        Integer statusCode;
        String status;
        String responseBody;
        public MockHttpResponseGenerator(Integer statusCode, String status, String responseBody) {
            this.statusCode = statusCode;
            this.status = status;
            this.responseBody = responseBody;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setStatus(status);
            res.setBody(responseBody);
            res.setHeader('Content-Type', 'application/json');
            return res;
        }
    }
}