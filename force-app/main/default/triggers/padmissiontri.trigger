/**
 * @description       : 
 * @author            : Naushad Ali
 * @group             : 
 * @last modified on  : 12-06-2022
 * @last modified by  : Naushad Ali
**/
trigger padmissiontri on PAdmission__c (before insert) {

    paddmissionTriggerhandler padtrihand=new paddmissionTriggerhandler();

    if(trigger.isBefore || (trigger.isInsert && trigger.isUpdate))
    {

        padtrihand.onBeforeinsert(Trigger.new);
        system.debug('Addmission is already Exits');
    }

}