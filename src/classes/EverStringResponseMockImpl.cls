@isTest
global class EverStringResponseMockImpl implements HttpCalloutMock {    
    global HttpResponse respond(HTTPRequest req) {        
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"status":200,"errorMessage":null}');
        return res;
    }
}