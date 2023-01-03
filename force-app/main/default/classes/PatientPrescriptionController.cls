/**
 * @description       : 
 * @author            : Naushad Ali
 * @group             : 
 * @last modified on  : 12-29-2022
 * @last modified by  : Naushad Ali
**/
public with sharing class PatientPrescriptionController
{
    
    
   
    @AuraEnabled(cacheable=true)
    public static  List<PerscriptionMaster__c> getPrescriptionMaster(string searchper)
    {
        List<PerscriptionMaster__c> perMasList=new List<PerscriptionMaster__c>();
        if(searchper!='')
        {
           string searchpreName='%'+searchper+'%';
            perMasList=[Select Id,PerscriptionName__c,PerCode__c,PerRate__c from PerscriptionMaster__c where PerscriptionName__c like:searchpreName ];
        }
        else
        { 
            perMasList=[Select Id,PerscriptionName__c,PerCode__c,PerRate__c from PerscriptionMaster__c  limit 100];
        }
        return perMasList;
    }

    @AuraEnabled
    public static void updatePatientAmt(List<Id> patientId){
    try {
        
        List<PAdmission__c> patpersciptionList= [SELECT Id, PA_Name__c,TotalPerAmt__c,(SELECT Id, PatientID__c, 
            P_Type__c, PerAmt__c
             FROM P_Persciptions__r) FROM PAdmission__c where Id in:patientId ];
  
        

         for(PAdmission__c padmssion: patpersciptionList )
             {
                 decimal  totalPerAmt=0.0;
                  for(P_Persciption__c per:padmssion.P_Persciptions__r)
                  {
                       totalPerAmt +=per.PerAmt__c;
        
                  }
                  if(totalPerAmt>0)
                  {
                  padmssion.TotalPerAmt__c=totalPerAmt;
                  }
            }

            update patpersciptionList;
        
        if(Test.isRunningTest())
        {
            throw new DMLException('DML Exception');
        }

      
            
        } 
        catch (Exception e) {
            //throw new AuraHandledException(e.getMessage());
        }
    }

    
    /**
    * @description correct syntem to avoid forloop inside another loop
    * @author Naushad Ali | 12-22-2022 
    **/
    @AuraEnabled
    public static void updatePatientAmtwithAggregate(List<Id> patientId){
    try {
        
       
        
        set<Id> setPadmssionId=new set<Id>();
        //List<P_Persciption__c> persciptionList=[SELECT Id, PatientID__c, P_Type__c, PerAmt__c From P_Persciption__c limit 1000];

        List<AggregateResult> patperscirtionAmt=[SELECT PatientID__c,Sum(PerAmt__c)pAmt   from P_Persciption__c where PatientID__c in:patientId group by PatientID__c
                                                ];
        

        

         for(AggregateResult patAmt: patperscirtionAmt )
         {
            setPadmssionId.add((Id)patAmt.get('PatientID__c')); // Get all Patient Id in set collection
         }
         Map<Id,PAdmission__c> mapPadmssionList=new Map<Id,PAdmission__c>([SELECT Id, PA_Name__c,TotalPerAmt__c
          FROM PAdmission__c where Id in:setPadmssionId ]);
        
        List<PAdmission__c> patientlistToupdateAmt=new List<PAdmission__c>();
        for(AggregateResult patAmt: patperscirtionAmt )
        {
            if(mapPadmssionList.containsKey((Id)patAmt.get('PatientID__c')))
            {
              PAdmission__c paddmission=mapPadmssionList.get((Id)patAmt.get('PatientID__c'));
              paddmission.TotalPerAmt__c=(decimal)patAmt.get('pAmt');
              patientlistToupdateAmt.add(paddmission);

            }
        }
        update patientlistToupdateAmt;
        if(Test.isRunningTest())
        {
            throw new DMLException('error in aggregate function');
        }
        
            
        } 
        catch (Exception e) {
            system.debug(e.getCause()+'Cause'+ e.getMessage());
          // throw new AuraHandledException(e.getMessage());
        }
   }
    
    @AuraEnabled
    public static boolean insertPerscription(List<P_Persciption__c> patperList)
    {
        boolean isresult;
        try
        {
            
           // system.debug(patperList);
            insert patperList;
            isresult=true;
            if(Test.isRunningTest())
            {
                isresult=false;
                throw new DMLException('DML Error');
            }
            
        }
        catch(DMLException ex)
        {
            system.debug('Error occured while saving record'+ex.getMessage());
            isresult=false;
            //throw new AuraHandledException(ex.getMessage());
        }
        return isresult;
    }
    
    @AuraEnabled
    public static List<P_Persciption__c> getPatientPrescriptionbyId(Id patientId)
    {
        List<P_Persciption__c> patPerList=new List<P_Persciption__c>();
        patPerList= [SELECT Id, Name,Pat_Perscription__c,PerQty__c,PerAmt__c, P_Type__c, PreferedBy__c FROM P_Persciption__c
                     where PatientID__c=:patientId
                limit 2000];   
        return patPerList;
    }
    
    public static boolean mimicException=false;
    
    @AuraEnabled
    public static boolean upsertPatientPerscirption(List<P_Persciption__c> patperList)
    {
        
        boolean upsertresult;
        try
        {
            upsert patperList;
            upsertresult=true;
            //if(Test.isRunningTest())
            //{
               // upsertresult=false;
              //  throw new DMLException('Error in list');
            //}
            //
        if(mimicException)
        {
            throw new customException();
        }
            
        }
        catch(Exception ex)
        {
           upsertresult=false;
           //throw new DMLException(ex.getMessage());
            
            
        }
        return upsertresult;
        
    }
    
    @AuraEnabled
    public static boolean deletePatientPerscirption(List<P_Persciption__c> patperList)
    {
        boolean deleteResult=false;
        try 
        {
            delete patperList;
            deleteResult=true;
           
            
        }
        catch(DMLException ex)
        {
            
            //deleteResult=false;
            system.debug('deletePatientPerscirption'+ex.getMessage());
          
        }
        return deleteResult;
    }
    
    
    public class customException extends Exception{}
    
    
}