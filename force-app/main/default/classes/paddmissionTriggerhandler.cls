/**
 * @description       : Handler for Padmisiion
 * @author            : Naushad Ali
 * @group             : 
 * @last modified on  : 12-06-2022
 * @last modified by  : Naushad Ali
**/
public without sharing class paddmissionTriggerhandler {
    public paddmissionTriggerhandler() {

    }
    /*This Method Created for('');
    Author by: Naushad Ali
    Created Date by: 06-12-2022 
    Modified by: 
    Modified Date: 
    User Story/Jira Ticket by: HEAL-4 */
    //@Testvisible
    public  void onBeforeinsert(List<PAdmission__c> addList)
    {
        for(PAdmission__c adlist:addList)
        {
            List<PAdmission__c> dupAdd=[Select Id,PA_Name__c,PPhoneNo__c from PAdmission__c where PA_Name__c=: adlist.PA_Name__c 
            and PPhoneNo__c=:adlist.PPhoneNo__c]; 

            if(dupAdd.size()>0)
            {
               adlist.PA_Name__c.addError('Patient is already admiitted');
               //system.debug('Patient is already admiitted');
            }

        }

    }

}