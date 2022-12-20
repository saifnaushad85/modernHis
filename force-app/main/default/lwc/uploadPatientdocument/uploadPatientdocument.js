import { LightningElement, track, api } from 'lwc';
import uploadFileToAWS from '@salesforce/apex/PatientDocumentController.uploadFileToAWS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import displayUploadedDocuments from '@salesforce/apex/PatientDocumentController.displayUploadedDocuments';

export default class UploadPatientdocument extends LightningElement {


    @api recordId;
    selectedFilesToUpload = [];
    @track showSpinner = false;
    @track fileName;
    @track tableData;
    file;
    fileType;
    fileReaderObj;
    base64FileData;

    handleSelectedFiles(event) {
        if (event.target.files.length > 0)
        {
            this.selectedFilesToUpload = event.target.files;
            this.fileName = this.selectedFilesToUpload[0].name;
            this.fileType = this.selectedFilesToUpload[0].type;
            console.log('filename=' + this.fileName);
            console.log('filetype=' + this.fileType);
            }
     }

    handleFileUpload(event) { 
        if (this.selectedFilesToUpload.length > 0) { 
            this.showSpinner = true;
            this.file = this.selectedFilesToUpload[0];
            //create an instance of file
            this.fileReaderObj = new FileReader();

        //this callback function in for fileReaderObj.readAsDataURL
         this.fileReaderObj.onloadend = (() => {
                //get the uploaded file in base64 format
                let fileContents = this.fileReaderObj.result;
                fileContents = fileContents.substr(fileContents.indexOf(',')+1)
                
                //read the file chunkwise
                let sliceSize = 1024;           
                let byteCharacters = atob(fileContents);
                let bytesLength = byteCharacters.length;
                let slicesCount = Math.ceil(bytesLength / sliceSize);                
                let byteArrays = new Array(slicesCount);
                for (let sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
                    let begin = sliceIndex * sliceSize;
                    let end = Math.min(begin + sliceSize, bytesLength);                    
                    let bytes = new Array(end - begin);
                    for (let offset = begin, i = 0 ; offset < end; ++i, ++offset) {
                        bytes[i] = byteCharacters[offset].charCodeAt(0);                        
                    }
                    byteArrays[sliceIndex] = new Uint8Array(bytes);                    
                }
                
                //from arraybuffer create a File instance
                this.myFile =  new File(byteArrays, this.fileName, { type: this.fileType });
                
                //callback for final base64 String format
                let reader = new FileReader();
                reader.onloadend = (() => {
                    let base64data = reader.result;
                    this.base64FileData = base64data.substr(base64data.indexOf(',')+1); 
                    this.fileUpload();
                });
                reader.readAsDataURL(this.myFile);                                 
            });
            this.fileReaderObj.readAsDataURL(this.file);            
        }
        else {
            this.fileName = 'Please select a file to upload!';
        }
    }

    fileUpload() {

        uploadFileToAWS({ parentId: this.recordId, 
                        strfileName: this.file.name, 
                        fileType: this.file.type,
                        fileContent: encodeURIComponent(this.base64FileData)})
            .then(result => {
                console.log('Upload result' + result);
                this.fileName = this.fileName + 'Uplaoded Successfully';
                this.getUploadedFiles();
                this.showSpinner = false;
                this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success !!',
                message: this.fileName + 'Uploaded Successfully for Patient ID'+this.recordId,
                variant:'sucess',

            }),);
            })
            .catch(error => {
                window.console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error in uplaoding file',
                        message: error.message,
                        variant: 'error',

                    }),
                   );
            });
        


    }
    
    getUploadedFiles(){
        displayUploadedDocuments({parentId: this.recordId})
        .then(data => {
            this.tableData = data;
            console.log('tableData=' + this.tableData);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error in displaying data!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }


}