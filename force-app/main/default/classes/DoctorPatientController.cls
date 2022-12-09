public with sharing class DoctorPatientController {
    public DoctorPatientController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<DoctorList__c> getDoctorList(){

        return [select DoctorID__c,Name,Last_Name__c from DoctorList__c];
       
    }


    @AuraEnabled(cacheable=true)
    public static list<PAdmission__c> findPAdmissionByDoctorId(string DoctorId)
    {
        return [select Name,PA_Name__c from PAdmission__c where ReferedBy__c=:DoctorId];

    }
    
}