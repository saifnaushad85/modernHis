@isTest
public class padmissiontri_test {
    
    @testSetup static void setupmethod()
    {
        String PName='Ramesh Kumar';
        String Phone='1235456';
        PAdmission__c padd=new PAdmission__c();
        padd.PA_Name__c=PName;
        padd.ReferedBy__c='a0W2v00001GhxZVEAZ';
        padd.PPhoneNo__c=Phone;
        insert padd;
    }
    
    public static testMethod void Testpadmissiontri_test()
    {
        string addError;
        String PName='Ramesh Kumar';
        String Phone='1235456';
        List<PAdmission__c> dupAdd1=[select Id,PA_Name__C,PPhoneNo__c from PAdmission__c];
        system.debug(dupAdd1.size());
        PAdmission__c padd=new PAdmission__c();
        padd.PA_Name__c=PName;
        padd.ReferedBy__c='a0W2v00001GhxZVEAZ';
        padd.PPhoneNo__c=Phone;
       
        if(dupAdd1.size() < 1)
        {
            
            system.assertEquals(0, dupAdd1.size());
            Test.startTest();
            insert padd; 
            //system.debug('Record Inserted');
            Test.stopTest();
        }
        else
        {
            addError='Existing';
            //system.debug('Duplicate Exists');
        }
        
       System.assertEquals('Existing', addError);
      
        
    }

}