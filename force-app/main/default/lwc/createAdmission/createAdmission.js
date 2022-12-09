import { LightningElement,wire,track } from 'lwc';
import createAdmission from '@salesforce/apex/AddmissionController.createAddmission';
import PADMISSION_OBJECT from '@salesforce/schema/PAdmission__c';
import BEDNO from '@salesforce/schema/PAdmission__c.BedNo__c';
import PName from '@salesforce/schema/PAdmission__c.PA_Name__c';
import PAGE from '@salesforce/schema/PAdmission__c.PAge__c';
import PEMAIL from '@salesforce/schema/PAdmission__c.Patient_Email__c';
import PAYSTATUS from '@salesforce/schema/PAdmission__c.PaymentStatus__c';
import PDOB from '@salesforce/schema/PAdmission__c.PDOB__c';
import PGENDER from '@salesforce/schema/PAdmission__c.PGender__c';
import DoctorPreredBy from '@salesforce/schema/PAdmission__c.ReferedBy__c';
import PHONENo from '@salesforce/schema/PAdmission__c.PPhoneNo__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CreateAdmission extends LightningElement {

    admission = {};
    @track admisionId;
    
    @track admissionRecord = {
        BedNo__c: BEDNO,
        PA_Name__c: PName,
        PAge__c: PAGE,
        Patient_Email__c: PEMAIL,
        PPhoneNo__c: PHONENo,
        ReferedBy__c :'a0W2v00001GhxZVEAZ'

    };
    
    /*
         pdob__c: PDOB,
         pgender__c: PGENDER,
         PaymentStatus__c: PAYSTATUS,
         //a0W2v00001GhxZVEAZ
    */

    get options() {
        return [
            { label: 'Male', value: '1' },
            { label: 'FeMale', value: '2' },
        ];
    }


    isInputValid()
    {
        let isvalid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => { 
            console.log(inputField.value);
            if (!inputField.checkValidity()) { 
                inputField.reportValidity();
                isvalid = false;
            }
            this.admission[inputField.name] = inputField.value;
        })

        return isvalid;
    }

    handleOnChange(event) { 
        if (event.target.name == 'Bedno')
        {
            this.admissionRecord.BedNo__c = event.target.value;

        }
        else if(event.target.name == 'Patientname')
        {
            this.admissionRecord.PA_Name__c = event.target.value;

        }
        else if(event.target.name == 'Email')
        {
            this.admissionRecord.Patient_Email__c = event.target.value;

        }
        else if(event.target.name == 'DOB')
        {
            this.admissionRecord.PDOB = event.target.value;

        }
        else if(event.target.name == 'AGE')
        {
            this.admissionRecord.PAge__c = event.target.value;

        }
        else if(event.target.name == 'Phone')
        {
            this.admissionRecord.PPhoneNo__c = event.target.value;

        }
        else if(event.target.name == 'Patientname')
        {
            this.admissionRecord.PA_Name__c= event.target.value;

        }
    }
    
    saveAdmission() {
        if (this.isInputValid()) {
           
            alert(JSON.stringify(this.admissionRecord));
            console.log(this.admissionRecord);
            alert('cannot save the value');
           // return;
           //AdmissionObj
            createAdmission({AdmissionObj: this.admissionRecord})
                .then(result => {
                    console.log(JSON.stringify(result));
                   // this.admisionId = result.Id;
                    alert('Record Saved');

                })
                .catch(error => {

                     this.dispatchEvent(
                       new ShowToastEvent({
                         title: 'Error while Saving Records',
                         message: error.body.message,
                         variant: 'error',
                        }),
                     );

                });
           
        }
        else {
            console.log(this.admission);
            alert(JSON.stringify(this.admission));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please Enter the required Fields',
                    message: JSON.stringify(this.admission),
                    variant: 'error',
                }),
            );
        }
        
     }


}