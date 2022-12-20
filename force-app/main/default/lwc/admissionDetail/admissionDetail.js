import { LightningElement,api,wire,track } from 'lwc';
import getAdmissionListByName from '@salesforce/apex/AddmissionController.getAdmissionListByName';
import { getDataConnectorSourceFields } from 'lightning/analyticsWaveApi';

export default class AdmissionDetail extends LightningElement {

    @track admissionList;
    @track error;
    @track searchStr='';
    @track columns = [
        { label: 'Bed No', fieldName: 'Bedno__c', type: 'text' },
        { label: 'Patient Name', fieldName: 'PA_Name__c', type: 'text' },
        { label: 'Age', fieldName: 'PAge__c', type: 'Number' },
        { label: 'Date of Birth', fieldName: 'PDOB__c', type: 'Date' },
        { label: 'Gender', fieldName: 'PGender__c', type: 'Number' },
        { label: 'Phone No', fieldName: 'PPhoneNo__c', type: 'Number' },
        { label: 'Priscribed Doctor', fieldName: 'ReferedBy__r_Name', type: 'text' },
      
    ];

    @wire(getAdmissionListByName,{ pName: '$searchStr' }) 
    addmissionRecord({ error, data })
     {
            if(data)
            {
                let addParseData = JSON.parse(JSON.stringify(data))
                addParseData.forEach(add => {
                    if (add.ReferedBy__r.Name) { 
                        add.ReferedBy__r_Name = add.ReferedBy__r.Name;
                    }
                    
                });
                this.admissionList = addParseData;

                //this.admissionList = data;
            }
            else if (error) { 
                
                this.error = error;
            }

        }
       
    
   



}