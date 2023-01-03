@istest
public class PatientPrescriptionControllerTEST {
    
    
    @testSetup static void setUpdata()
    {
      
        PerscriptionMaster__c perMaster= new PerscriptionMaster__c(PerscriptionName__c='Dolo-500',PerCode__c='D-100',PerRate__c=100.20);
        Database.SaveResult dsr;
        dsr=Database.insert(PerMaster,false);
        DoctorList__c docList=new DoctorList__c(Name='Dr.KC',Last_Name__c='Singh');
        insert docList;
        
        PAdmission__c patObj = new PAdmission__c(PA_Name__c='TestPatient',PPhoneNo__c='12345',ReferedBy__c=docList.id);
        insert patObj;
        
        PAdmission__c patObj1 = new PAdmission__c(PA_Name__c='TestPatient1',PPhoneNo__c='123456',ReferedBy__c=docList.id);
        insert patObj1;
        
         PAdmission__c patObj2 = new PAdmission__c(PA_Name__c='TestPatient3',PPhoneNo__c='1234567',ReferedBy__c=docList.id);
        insert patObj2;
        
        P_Persciption__c  patperscription=new P_Persciption__c(
            Name='TestPersciption',PatientID__c=patObj.Id,PreferedBy__c=patObj.ReferedBy__c,
                                                            PerQty__c=2,Pat_Perscription__c=perMaster.Id);
        
        insert patperscription;
        
         P_Persciption__c  patperscription1=new P_Persciption__c(
            Name='TestPersciption1',PatientID__c=patObj.Id,PreferedBy__c=patObj.ReferedBy__c,
                                                            PerQty__c=2,Pat_Perscription__c=perMaster.Id);
        
        insert patperscription1;
        
        //Second Patient Perscirption
        P_Persciption__c  patperscription21=new P_Persciption__c(
            Name='TestPersciption',PatientID__c=patObj1.Id,PreferedBy__c=patObj.ReferedBy__c,
                                                            PerQty__c=2,Pat_Perscription__c=perMaster.Id);
        
        insert patperscription21;
        
         P_Persciption__c  patperscription22=new P_Persciption__c(
            Name='TestPersciption1',PatientID__c=patObj1.Id,PreferedBy__c=patObj.ReferedBy__c,
                                                            PerQty__c=2,Pat_Perscription__c=perMaster.Id);
        
        insert patperscription22;
        
        
        

        
    }
    
    
    private static testMethod void getPrescriptionMasterTest()
    {
         List<PerscriptionMaster__c> perMasList=new List<PerscriptionMaster__c>();
        List<PerscriptionMaster__c> perMasListall=new List<PerscriptionMaster__c>();
         Test.startTest();
         perMasList= PatientPrescriptionController.getPrescriptionMaster('Dol');
         perMasListall= PatientPrescriptionController.getPrescriptionMaster('');
          Test.stopTest();
         system.assertNotEquals(0, perMasList.size());
         system.assertNotEquals(0, perMasListall.size());
        
    }
    
    private static testMethod void updatePatientAmtTest()
    {
        List<PAdmission__c> patientList= [select Id from PAdmission__c];
        //List<P_Persciption__c> persAmt= [select PatientID__c,PerAmt__c from P_Persciption__c];
        
        system.debug(patientList.size());
        //system.debug(persAmt);
        List<Id>  pateientIds =new List<Id>();
        for(PAdmission__c pa:patientList)
        {
            pateientIds.add(pa.Id);
        }
        //List<Id> patientIds=new list<Id>();
       // patientIds=[select Id from PAdmission__c where PA_Name__c=:'TestPatient'];
        Test.startTest();
        PatientPrescriptionController.updatePatientAmt(pateientIds);
       // update patientList;
        Test.stopTest();
        
    }
    
    private static testMethod void updatePatientAmtwithAggregateTest()
    {
        
        List<PAdmission__c> patientList= [select Id from PAdmission__c];
       List<Id>  pateientIds =new  List<Id>();
        for(PAdmission__c pa:patientList)
        {
            pateientIds.add(pa.Id);
        }
        
          
       // patientIds=[select Id from PAdmission__c where PA_Name__c=:'TestPatient'];
        Test.startTest();
        PatientPrescriptionController.updatePatientAmtwithAggregate(pateientIds);
        //update patientList;
        Test.stopTest();
    }
    
    private static testMethod void insertPerscriptionTEST()
    { 
         P_Persciption__c patPerciption= [SELECT Name,Pat_Perscription__c,PerQty__c,PerAmt__c, P_Type__c,PatientID__c, PreferedBy__c
                                          FROM P_Persciption__c limit 1];
         
         List<P_Persciption__c> newperList= new List<P_Persciption__c>();
         List<P_Persciption__c> blankperList=null;
         for(Integer count=0;count<5;count++)
         {
             P_Persciption__c perscription =new P_Persciption__c();
             perscription.Name=patPerciption.Name+count;
             perscription.Pat_Perscription__c=patPerciption.Pat_Perscription__c;
             perscription.PerQty__c=count;
             perscription.PatientID__c=patPerciption.PatientID__c;
             perscription.PreferedBy__c=patPerciption.PreferedBy__c;
             newperList.add(perscription);
         }
        
         boolean successresult;
         boolean falseresult;
         
         try
         {
         Test.startTest();
         successresult=PatientPrescriptionController.insertPerscription(newperList);
         falseresult=PatientPrescriptionController.insertPerscription(blankperList);
      
         Test.stopTest();
         system.assertEquals(true, successresult);
         system.assertEquals(false, falseresult);
        
         }
        catch(Exception ex)
        {
            system.assertEquals(ex.getMessage(), ex.getMessage());
            
        }
        
     
        
    }
    
    
    private static testMethod void upsertPatientPerscirptionTest()
    {
        PAdmission__c patientDetail=[select Id from PAdmission__c where PA_Name__c=:'TestPatient' limit 1];
        List<P_Persciption__c> patperList=[SELECT Name,Pat_Perscription__c,PerQty__c,PerAmt__c, P_Type__c,PatientID__c, PreferedBy__c
                                          FROM P_Persciption__c where PatientID__c=:patientDetail.Id ];
        for(P_Persciption__c per:patperList)
        {
            per.PerQty__c++;
            
        }
        
         P_Persciption__c perscription =new P_Persciption__c();
         perscription.Name=patperList[0].Name;
         perscription.Pat_Perscription__c=patperList[0].Pat_Perscription__c;
         perscription.PerQty__c=10;
         perscription.PatientID__c=patperList[0].PatientID__c;
         perscription.PreferedBy__c=patperList[0].PreferedBy__c;
         P_Persciption__c perscriptionblank=new P_Persciption__c();
        
        patperList.add(perscription);
        patperlist.add(perscriptionblank);
        boolean result;
       try
       {
        Test.startTest();
         PatientPrescriptionController.mimicException=true;
        result=PatientPrescriptionController.upsertPatientPerscirption(patperList);
        Test.stopTest();
        system.assertEquals(true,result);
       }
       catch(Exception ex)
       {
           system.assertEquals(false, result);
           system.assertEquals('Error in list', ex.getMessage());
          
       }
    }
    
    private static testMethod void getPatientPrescriptionbyIdTEST()
    {
        PAdmission__c patientDetail=[select Id from PAdmission__c where PA_Name__c=:'TestPatient' limit 1];
        List<P_Persciption__c> patperList=[SELECT Name,Pat_Perscription__c,PerQty__c,PerAmt__c, P_Type__c,PatientID__c, PreferedBy__c
                                          FROM P_Persciption__c where PatientID__c=:patientDetail.Id ];
        Test.startTest();
        List<P_Persciption__c> expectedList= PatientPrescriptionController.getPatientPrescriptionbyId(patientDetail.Id);
        Test.stopTest();
        system.assertEquals(patperList.size(), expectedList.size());
        
    }
    
    private static testMethod void deletePatientPerscirptionTEST()
    {
        PAdmission__c patientDetail=[select Id from PAdmission__c where PA_Name__c=:'TestPatient' limit 1];
        List<P_Persciption__c> patperList=[SELECT Id,Name,Pat_Perscription__c,PerQty__c,PerAmt__c, P_Type__c,PatientID__c, PreferedBy__c
                                          FROM P_Persciption__c where PatientID__c=:patientDetail.Id ];
        List<P_Persciption__c> patListblank=new List<P_Persciption__c>();
        boolean delResult;
        boolean errorResult;
        Test.startTest();
        try
        {
        delResult = PatientPrescriptionController.deletePatientPerscirption(patperList);
        errorResult = PatientPrescriptionController.deletePatientPerscirption(patListblank);
        }
        catch(DMLException ex)
        {
            System.assertEquals(ex.getMessage(), ex.getMessage());
        }
        Test.stopTest();
       
        
        system.assertEquals(true, delResult);
        system.assertEquals(false, errorResult);
        
    }

}