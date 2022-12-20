@isTest
private class PatientDocumentControllerTest {
    
    private static Id patientId;
    private static string FileUrl;
    private static string FileName;
    private static Blob filecontent;
    
    @testSetup static void setUpData()
    {
          PatientDocment__c patientdocument=new PatientDocment__c(Patient_Name__c='Test Patient',Name='Test Patient');
          insert patientdocument;
          Attachment__c  attachment=new Attachment__c();
          attachment.PatientDocument__c=patientdocument.Id;
          attachment.FileURL__c = 'https://hospitaldocuments2022.s3.amazonaws.com:443/16122022051916_a1i2v00000DRIHwAAP_image001.png';
          attachment.File_Name__c =  'TestDocument';
          insert attachment;
          patientId=patientdocument.Id;
    }
    
    
    
    
    private static testMethod void uploadFileToAWSTest()
    {
       
       
        Test.setMock(HttpCalloutMock.Class, new AwsBucketMock());
        try
        {
        PatientDocumentController.uploadFileToAWS(patientId, FileName,'jpeg', '');
       }
        catch(Exception Ex)
        {
            system.debug(Ex.getMessage());
            
        }
            
    }
    
    private static testMethod void insertUploadedDocumentTest()
    {
        
        Attachment__c attachdoc=[select PatientDocument__c,FileURL__c,File_Name__c from Attachment__c ];
        
        try
        {
        //Attachment__c  attachment=new Attachment__c();
        Test.startTest();
        String strresult= PatientDocumentController.insertUploadedDocument(attachdoc.PatientDocument__c,
                                                                           attachdoc.FileURL__c,attachdoc.File_Name__c);
        String strresulterror= PatientDocumentController.insertUploadedDocument('','','');
        Test.stopTest();
        //system.Assert('Inserted'+strresult);
        }
         
        catch(Exception ex)
        {
            // throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    private static testMethod void displayUploadedDocumentsTEST()
    {
        List<Attachment__c> attachemts= [select Id,PatientDocument__c,File_Name__c,FileURL__c 
            from Attachment__c limit 1];
        Test.startTest();
        PatientDocumentController.displayUploadedDocuments(attachemts[0].PatientDocument__c);
        Test.stopTest();
    }

}