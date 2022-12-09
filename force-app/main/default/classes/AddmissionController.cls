public class AddmissionController {
    
    @AuraEnabled(Cacheable=true)
    public static List<PAdmission__c> getAdmissionList()
    {
        return [select Id,PA_Name__c,Name,Patient_Email__c,PaymentStatus__c,PDOB__c,
                 BedNo__c,PGender__c,ReferedBy__c from PAdmission__c ];
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<PAdmission__c> getAdmissionListByName(string PName)
    {
        return [select Id,PA_Name__c,Name,Patient_Email__c,PaymentStatus__c,PDOB__c,
                 BedNo__c,PGender__c,ReferedBy__c from PAdmission__c  where PA_Name__c=:PName ];
    }
    
    @AuraEnabled
    public static PAdmission__c createAddmission(PAdmission__c AdmissionObj)
    {
        try
        {
			insert   AdmissionObj ;
            return AdmissionObj;
        }
        catch(Exception ex)
        {
            throw new AuraHandledException(ex.getMessage());
        }
    }


    @AuraEnabled(Cacheable=true)
    public static Integer TotalRecords()
    {
        return [select count() from PAdmission__c];
    }

    @AuraEnabled(Cacheable=true)
    public static List<PAdmission__c> getAdmissionByPage(Integer v_Offset,Integer v_pagesize)
    {
        return [select Id,PA_Name__c,Name,Patient_Email__c,PaymentStatus__c,PDOB__c,
                 BedNo__c,PGender__c,ReferedBy__c from PAdmission__c limit: v_pagesize OFFSET : v_Offset ];
    }
    

    @AuraEnabled
    public static Integer getNext(Integer v_OffSet, Integer v_pageSize)
    {
       if(v_OffSet==null)
       {
        v_OffSet=2;
       }
       else 
       {
        v_OffSet= 4;

       }
        return v_OffSet;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPrevious(Integer v_OffSet, Integer v_pageSize)
    {
        Integer offset1=v_OffSet;
        Integer pagesize=v_pageSize;
        Integer NewOffSet=Integer.valueOf(offset1)+ Integer.valueOf(pagesize);
       
        //v_OffSet-=v_pageSize;
        return NewOffSet;
    }

    

}