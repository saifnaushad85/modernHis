/**
 * @description       : Cotroller for AWS integraion
 * @author            : Naushad Ali
 * @group             : 
 * @last modified on  : 12-16-2022
 * @last modified by  : Naushad Ali
**/
public with sharing class PatientDocumentController 
{
   
     @AuraEnabled
    public static boolean uploadFileToAWS(Id parentId,
                                        String strfileName, String fileType,
                                        String fileContent){
        System.debug('parentId=' + parentId);
        System.debug('strfileName=' + strfileName);
        System.debug('fileType=' + fileType);
        HttpRequest req = new HttpRequest();

        Blob base64Content = EncodingUtil.base64Decode(EncodingUtil.urlDecode(fileContent, 'UTF-8'));
        String attachmentBody =  fileContent;           
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String dateString = Datetime.now().format('ddMMYYYYHHmmss');        
        String filename = dateString + '_' + parentId + '_' + strfileName;
                                            
        //NamedCredential named=[SELECT DeveloperName, Endpoint FROM NamedCredential where DeveloperName='AWSSignature'];
        
        //Old Code start
        //AWS specific information
        String key = 'AKIA4FGPX7YMBDYQ4RHV'; //AWS key
        String secret = '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'; //AWS Secret key
        String bucketname = 'hospitaldocuments2022'; //AWS bucket name
        String host = 's3.amazonaws.com:443'; //'s3.amazonaws.com:443'
       
        String method = 'PUT';
        String endPoint = 'https://' + bucketname + '.' + host + '/'+ filename;
        //old Code  end    
        
        //new code
         //String method = 'PUT';
         //String endPoint ='callout:S3HisUpload/';
                                            

        req.setMethod(method);
        req.setEndpoint(endPoint);

        system.debug('Endpoint='+endPoint+'callout:S3HisUpload/');
        //create header information
        req.setHeader('Host', bucketname + '.' + host);  //-- Commented
        req.setHeader('Access-Control-Allow-Origin', '*');
        req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'UTF-8');
        req.setHeader('Content-type', fileType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString); 
        req.setHeader('ACL', 'public-read');
        //store file as blob       
        req.setBodyAsBlob(base64Content);
        
        //prepare for signing information
        String stringToSign = 'PUT\n\n' +
        fileType + '\n' +
        formattedDateString + '\n' + '/' + bucketname + '/' + filename;

        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
        String signedKey  = EncodingUtil.base64Encode(mac);

        //assign Authorization information old code start
        String authHeader = 'AWS' + ' ' + key + ':' + signedKey;                    
        req.setHeader('Authorization',authHeader);
        //old Code End

        //finally send information to AWS        
        Http http = new Http();
        system.debug(req);
        HTTPResponse res = http.send(req);

        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());

        if(res.getStatusCode() == 200){
           // insertUploadedDocument (parentId,strfileName,endPoint);
           // system.debug(res.getStatusCode());
            return true;
        }
        return false;
    }




    @AuraEnabled
    public static string insertUploadedDocument(Id parentId, String fileName, String fileURL)
    {
        String uplaodStatus;
        try 
        {
        Attachment__c attachment = new Attachment__c();
        attachment.PatientDocument__c = parentId;
        attachment.FileURL__c = fileURL;
        attachment.File_Name__c =  fileName;
        insert attachment; 
        uplaodStatus='Inserted'+attachment.Id;
        } catch (Exception e) {
            uplaodStatus='Errror while Saving Record'+e.getMessage();
            throw new AuraHandledException(e.getMessage());

        }
        return uplaodStatus;

    }

    @AuraEnabled
    public static List<Attachment__c> displayUploadedDocuments(Id parentId )
    {
        
        List<Attachment__c> docList;
        try {

            docList=[select Id,File_Name__c,FileURL__c 
            from Attachment__c where PatientDocument__c=:parentId];
            
        } catch (Exception e) {
            docList=null;
            throw new AuraHandledException(e.getMessage());
        }
        return docList;
    }
}