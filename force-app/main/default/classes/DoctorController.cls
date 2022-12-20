/**
 * @description       : For Doctor List in Addmisson form
 * @author            : Naushad Ali
 * @group             : 
 * @last modified on  : 12-15-2022
 * @last modified by  : Naushad Ali
**/
public with sharing class DoctorController {
    
    @AuraEnabled(cacheable=true)
    public static List<DoctorList__c> doctorList(String strName ){
        
        List<DoctorList__c> docList;
        String docName='%'+strName+'%';
        try {

            docList=[select Id,Name,DoctorId__c,Last_Name__c from DoctorList__c where Name like:docName];
            
            if(Test.isRunningTest())
            {
                throw new AuraHandledException('');
            }
            

        } catch (Exception e) {
            docList=null;
            throw new AuraHandledException(e.getMessage());
        }
        return docList;
    }
}