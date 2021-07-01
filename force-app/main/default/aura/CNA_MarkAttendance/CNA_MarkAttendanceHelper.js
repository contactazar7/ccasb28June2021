({
    setupTable : function(component,event, helper) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "Attendance__c",
            fieldAPIName: "Status__c"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                console.log('response getState == '+response.getState());
                console.log('response getValues == '+response.getReturnValue());
                var types = [];
                var types_hour = [];
                var types_mins = [];
                var types_modules = [];
                var cna_types = [];
                Object.entries(response.getReturnValue()).forEach(([key, value]) => types.push({label:key,value:value}));
                var hours = component.get("c.getPicklistValues_hours");
                hours.setParams({
                    objectAPIName: "Attendance__c",
                    fieldAPIName: "Hours__c"
                });
                hours.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS"){
                        console.log('response getState == '+response.getState());
                        console.log('response getValues == '+response.getReturnValue());
                        Object.entries(response.getReturnValue()).forEach(([key, value]) => types_hour.push({label:key,value:value}));  
                    }
                });
                $A.enqueueAction(hours);
                var mins = component.get("c.getPicklistValues_mins");
                console.log(' mins '+ mins);
                mins.setParams({
                    objectAPIName: "Attendance__c",
                    fieldAPIName: "Minutes__c"
                });
                mins.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS"){
                        console.log('response getState == '+response.getState());
                        console.log('response getValues == '+response.getReturnValue());
                        Object.entries(response.getReturnValue()).forEach(([key, value]) => types_mins.push({label:key,value:value}));  
                    }
                });
                $A.enqueueAction(mins); 
                
                var cna_type = component.get("c.getPicklistValues_CNAType");
                console.log(' mins '+ mins);
                cna_type.setParams({
                    objectAPIName: "Attendance__c",
                    fieldAPIName: "CNA_Class_Type__c"
                });
                cna_type.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS"){
                        console.log('response getState == '+response.getState());
                        console.log('response getValues == '+response.getReturnValue());
                        Object.entries(response.getReturnValue()).forEach(([key, value]) => cna_types.push({label:key,value:value}));  
                    }
                });
                $A.enqueueAction(cna_type);
                var cols = [
                    {label: "Name ", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: 'Contact Name', fieldName: 'Contact_Name__c', type: 'Formula'},
                    //{label: "Attendance Status", fieldName: "Status__c", editable: true, type:"picklist", selectOptions:types},
                    {label: "CNA Type", fieldName: "CNA_Class_Type__c", editable: true, type:"picklist", selectOptions:cna_types}, 
                    {label: "Hours", fieldName: "Hours__c", editable: true, type:"picklist", selectOptions:types_hour}, 
                    {label: "Minutes", fieldName: "Minutes__c", editable: true, type:"picklist", selectOptions:types_mins}, 
                    {label: "Modules", fieldName: "CNA_Modules_Covered__c", type:"picklist", selectOptions:types_modules}, 
                    //{label: "Modules", fieldName: "CNA_Modules_Covered__c", type:"picklist", selectOptions:types_modules}, 
                    {label: 'Enrollment No.', fieldName: 'Enrollment_No__c', type: 'Formula'},
                    {label: 'Class Date', fieldName: 'Date__c', type: 'Date'},
                    
                ];
                    component.set("v.columns", cols);
                    this.loadRecords(component);
                    }else{
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadRecords : function(component) {
        var action = component.get("c.fetchAttendance");
        action.setParams({
            'recId': component.get("v.id")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var allRecords = response.getReturnValue();
                if(allRecords.length == 0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        type: 'Error',
                        message: 'No records has found on requested date.',
                        duration:'100',
                        key: 'info_alt',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
                allRecords.forEach(rec => {
                    rec.accountLink = '/'+rec.Id;
                    component.set("v.ratio", rec.Roaster__r.Ratio__c);
                });
                    component.set("v.data", allRecords);
                    component.set("v.isLoading", false);
                    component.set("v.TotalNumberOfRecord", allRecords.length);
                    var filterdatamethods = component.find('datatableId');
                    if(allRecords.length>0){
                    filterdatamethods.filtermethod(allRecords);
                }
                }else{
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                    component.set("v.error", message);
                }
                });
                    $A.enqueueAction(action);
  }
})