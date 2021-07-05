({
    setupTable : function(component,event, helper) {
        var action = component.get("c.ClassId");
        action.setParams({
            recId : component.get("v.id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allRecords = response.getReturnValue();
                component.set("v.classId", allRecords);
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.getPicklistValues");
        console.log('action=='+action);
        component.set("v.loaded", false);
        action.setParams({
            objectAPIName: "Attendance__c",
            fieldAPIName: "Status__c",
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.loaded", true);
                console.log('response getState == '+response.getState());
                console.log('response getValues == '+response.getReturnValue());
                var types = [];
                Object.entries(response.getReturnValue()).forEach(([key, value]) => types.push({label:key,value:value}));
                var cols = [
                    {label: "Name ", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: 'Provider Name', fieldName: 'Contact_Name__c', type: 'Formula'},
                    {label: 'Enrollment No.', fieldName: 'Enrollment_No__c', type: 'Formula'},
                    {label: 'Class Scheduled Date', fieldName: 'Date__c', type: 'Date'},
                    {label: "Attendance Status", fieldName: "Status__c", editable: true, type:"picklist", selectOptions:types}, 
                    //{label: "Students RSVP", fieldName: "Students_RSVP__c", editable: false, type:"text"}, 
                    {label: "Created Date", fieldName: "CreatedDate", type:"date", sortable: true}
                ];
                component.set("v.columns", cols);
                this.loadRecords(component);
            }else{
                var errors = response.getError();
                console.log('errors '+errors);
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error: "+message);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadRecords : function(component) {
        var action = component.get("c.fetchAttendance");
        console.log('action fetchAttendance='+component.get("c.fetchAttendance"));
        console.log(' record Id for class '+component.get("v.id") ); 
        console.log(' schduled date for the class '+component.get("v.classDate")); 
        action.setParams({
            'recId': component.get("v.id")
        });
        console.log('action.setParams loadRecords='+action.setParams);
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                console.log('response getState == '+response.getState());
                console.log('response getValues == '+response.getReturnValue());
                
                var allRecords = response.getReturnValue();
                console.log('allRecords=='+allRecords);
                console.log('allRecords.length=='+allRecords.length);
                console.log('response.getReturnValue()=='+response.getReturnValue());
                if(allRecords.length == 0){
                    component.set("v.Message", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Info:',
                        type: 'info',
                        message: 'No Make-Up Attendance are left to mark here!',
                        duration:'100',
                        key: 'info_alt',
                        mode: 'dismissible'
                        //mode: 'sticky'
                    });
                    toastEvent.fire();
                }
                allRecords.forEach(rec => {
                    rec.accountLink = '/'+rec.Id;
                });
                    
                    component.set("v.data", allRecords);
                    component.set("v.isLoading", false);
                    component.set("v.TotalNumberOfRecord", allRecords.length);
                    console.log('v.data for Init from Parent=='+allRecords);
                    console.log('data after loadRecords=='+JSON.parse(JSON.stringify(component.get("v.data"))));
                    
                    var filterdatamethods = component.find('datatableId');
                    console.log('filterdatamethods before=='+filterdatamethods);
                    if(allRecords.length>0){
                    filterdatamethods.filtermethod(allRecords);
                    console.log('filterdatamethods after=='+filterdatamethods);
                }
                }else{
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                    component.set("v.error", message);
                    console.log("Error: "+message);
                }
                });
        $A.enqueueAction(action);
    }
})