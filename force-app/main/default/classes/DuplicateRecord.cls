public class DuplicateRecord {
    
    @InvocableMethod
    public static void getDuplicatList()
    {
        Map<String,String> Ids= new Map<String,String>();
        for(AggregateResult []  veh:[select count(ID),vehicalno__c from vehical__c group by vehicalno__c having count(Id)>1])
        {
            for(AggregateResult vehs:veh)
            {
            Ids.put(String.valueof(vehs.get('expr0')),String.valueOf(vehs.get('vehicalno__c')));
            }
        }
        
        
       // AggregateResult[] duplicaterecords=[select vehicalno__c,count(Name) from vehical__c
         //                                  group by vehicalno__c having  count(Name) >1];
        
        Map<String,String> mapvehIdName=new Map<String,String>();
        List<vehical__c > listtodelete=new List<vehical__c >();
        for(vehical__c  vehicle:[select Id,vehicalno__c from vehical__c  where vehicalno__c in : Ids.values()])
        {
            if(!mapvehIdName.containsKey(vehicle.vehicalno__c))
            {
                mapvehIdName.put(vehicle.vehicalno__c, vehicle.Id);
            }
            else
            {
                listtodelete.add(vehicle);
            }
            
        }
        //system.debug(duplicaterecords);
        
        //for(Vehical__c )
        //
        system.debug(mapvehIdName);
        system.debug(listtodelete);
    }
    
    //@InvocableMethod
    public static void dup2()
    {
        
    }

}