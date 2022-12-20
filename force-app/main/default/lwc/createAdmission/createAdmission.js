import { LightningElement,wire,track } from 'lwc';
import createAdmission from '@salesforce/apex/AddmissionController.createAddmission';
import doctorList from '@salesforce/apex/DoctorController.doctorList';
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
    @track searchdocName;
    @track selectedGender;
    @track doctorID;
    @track doctorsList;
    @track messageResult = false;
    @track isShowResult = true;
    @track showSearchValues = false;
    
    @track admissionRecord = {
        BedNo__c: BEDNO,
        PA_Name__c: PName,
        PAge__c: PAGE,
        Patient_Email__c: PEMAIL,
        PPhoneNo__c: PHONENo,
        ReferedBy__c :'',
        PGENDER:1,

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
            { label: 'Other', value: '3' },
        ];
    }


    handleRadioChange(event)
    {
        //const selGend = event.detail.value;
        this.admissionRecord.PGENDER = event.detail.value;
        //alert(this.admissionRecord.PGENDER);
        //alert(event.detail.value);
       // alert(event.detail.value.label);

       

    }




    @wire(doctorList, {strName:'$searchdocName'}) 
    retrivedoctors({error,data})
    {
        this.messageResult = false;
        if (data) {
            

            console.log('data::' + data.length);
            if (data.length > 0 && this.isShowResult) {
                this.doctorsList = data;
                this.showSearchValues = true;
                this.messageResult = false;

            }
            else if (data.length == 0) { 
                this.doctorsList = [];
                this.showSearchValues = false;
                if (this.searchdocName != '')
                { 
                    this.messageResult = trur;
                }
            }
        }
        else if (error) { 
            this.doctorID = '';
            this.searchdocName = '';
            this.doctorsList = [];
            this.showSearchValues -= false;
            this.messageResult = true;


        }

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
           
           // alert(JSON.stringify(this.admissionRecord));
            console.log(this.admissionRecord);
           // alert('cannot save the value');
           // return;
           //AdmissionObj
            createAdmission({AdmissionObj: this.admissionRecord})
                .then(result => {
                    console.log(JSON.stringify(result));
                   // this.admisionId = result.Id;
                    alert('Record Saved');

                })
                .catch(error => {


                   const errmessage = error.body.message;
                    let custerromess = '';
                    if (errmessage.includes('Patient is already admiitted')) {
                        custerromess = 'Patient is already admiitted';

                    }
                    else { 
                        custerromess = errmessage;
                    }

                     this.dispatchEvent(
                       new ShowToastEvent({
                         title: 'Error while Saving Records',
                         message: custerromess,
                         variant: 'error',
                        }),
                     );

                });
           
        }
        else {
            console.log(this.admission);
           // alert(JSON.stringify(this.admission));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please Enter the required Fields',
                    message: JSON.stringify(this.admission),
                    variant: 'error',
                }),
            );
        }
        
    }
    
    handleClick(event) { 
        this.isShowResult = true;
        this.messageResult = false;
    }

    handlekeyChange(event) { 
        this.messageResult = false;
        this.searchdocName = event.target.value;
    }

    handleDoctorSelection(event)
    {
    this.showSearchValues = false;
    this.isShowResult = false;
    this.messageResult=false;
    //Set the parent calendar id
    this.doctorID =  event.target.dataset.value;
    //Set the parent calendar label
    this.searchdocName =  event.target.dataset.label; 
    this.admissionRecord.ReferedBy__c = this.doctorID;
    console.log('DoctorId::'+this.doctorID); 
    console.log('DoctorName::'+this.searchdocName);    
    //const selectedEvent = new CustomEvent('selected', { detail: this.doctorID });
        // Dispatches the event.
    //this.dispatchEvent(selectedEvent); 

    }
    
    


}