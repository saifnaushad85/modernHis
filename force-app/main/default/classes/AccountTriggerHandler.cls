public class AccountTriggerHandler {
    
    public static void upsertAccount(List<Account> acc)
    {
        
         List<Contact> conlist=new List<Contact>();
        for(Account a:acc)
        {
            Contact shiptoContact=new Contact();
            Contact billtoContact=new Contact();
            
            shiptoContact.AccountId=a.Id;
            shiptoContact.FirstName='ShipTo';
            billtoContact.AccountId=a.Id;
            billtoContact.FirstName='BillTo';
            conlist.add(shiptoContact);
            conlist.add(billtoContact);
           
        }
        insert conlist;
        }
    

}