@isTest
private class DoctorController_TESt {
    
    @isTest 
    private static void doctorList_Test()
    {
        try
        {
    List<DoctorList__c> docs=new List<DoctorList__c>();
    DoctorList__c newdoc=new DoctorList__c(Name='Adesh',Last_Name__c='Kumar');
    DoctorList__c newdoc1= new DoctorList__c(Last_Name__c='New Kumar');
    //docs.add(newdoc);
    insert newdoc;
    insert newdoc1;
    Test.startTest();
    List<DoctorList__c> doclist=DoctorController.doctorList('Ad');
    List<DoctorList__c> doclist1=DoctorController.doctorList('Ram');
    Test.stopTest();
    System.assertEquals('Adesh',docList[0].Name);      
    system.assertEquals(0,doclist1.size());
    }
        
    catch(Exception ex)
    {
        system.debug('Error is'+ex.getMessage());
    }
        
    }
    
    

}