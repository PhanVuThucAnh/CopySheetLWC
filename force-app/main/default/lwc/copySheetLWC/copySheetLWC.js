import { LightningElement, api, wire, track } from "lwc";

//import getCycleDetail from "@salesforce/apex/CopySheetLWCCtrl.getCycleDetail";
import copyCycle from "@salesforce/apex/CopySheetLWCCtrl.copyCycle";

import Name_FIELD from "@salesforce/schema/Cycle__c.Name";
import Contactc_FIELD from "@salesforce/schema/Cycle__c.Contact__c";
import Statusc_FIELD from "@salesforce/schema/Cycle__c.Status__c";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";

const wireFIELDS = [Name_FIELD, Contactc_FIELD, Statusc_FIELD];

export default class CopySheetLWC extends LightningElement {
  lwcstart = false;

  @api recordId;
  @track data;
  @track error;

  objectApiName = "Cycle__c";

  // @wire(getCycleDetail, { Id: "$recordId" })
  // cycledetail({ error, data }) {
  //   if (data) {
  //     this.data = data;
  //   }
  // }

  @wire(getRecord, { recordId: "$recordId", fields: wireFIELDS }) currentCycle;
  @api copyCurrentCycle;

  get name() {
    return this.currentCycle.data.fields.Name.value;
  }

  get contactInfo() {
    return this.currentCycle.data.fields.Contact__c.value;
  }

  get cycleStatus() {
    return this.currentCycle.data.fields.Status__c.value;
  }

  @track fields = [Name_FIELD, Contactc_FIELD, Statusc_FIELD];

  handleLWCStart() {
    this.lwcstart = true;
  }

  handleSuccess() {
    if (this.cycleStatus !== "支援終了") {
      const copyDetail = {
        apiName: this.objectApiName,
        Name: this.name + "Copy",
        Contact__c: this.contactInfo,
        SegmentA__c: true,
        ShienExID__c: "xxxxxxxxxCopy"
      };

      console.log(">>>>>>SHOW DETAIL<<<<<<<", copyDetail);

      copyCycle({ copyCurrentCycle: copyDetail })
        .then(() => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "成功した",
              message: "サイクルをコピーした",
              variant: "success"
            })
          );
        })
        .catch((error) => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "エラー。コピーできませんでした。",
              message: error.body.message,
              variant: "error"
            })
          );
          console.log("error", JSON.stringify(error));
        });
    } else {
      console.log(">>>Closed<<<");
      const evt = new ShowToastEvent({
        title: "エラー",
        message: "終了サイクルをコピーできません",
        variant: "error"
      });
      this.dispatchEvent(evt);
      this.lwcstart = false;
    }
  }

  handleCancel(event) {
    console.log(">>Inside Cancel<<");
    this.lwcstart = false;
  }
}
