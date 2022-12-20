@isTest
global class ParkServiceMock implements WebServiceMock {
    
    global void doinvoke(
    	   Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType)
    {
        // start - specify the response you want to send
        ParkService.byCountryResponse response_x =  new ParkService.byCountryResponse();
        response_x.return_x =new List<String>{'Yesomite','Sequala','Creater Lake'};
        // end
        response.put('response_x', response_x);
    }

}