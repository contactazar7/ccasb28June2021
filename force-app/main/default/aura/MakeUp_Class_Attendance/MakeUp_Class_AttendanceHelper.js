({
    setupTable: function(component, event, helper) {
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
        component.set('v.contactrows', [
            {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
            {label: 'Provider Name', fieldName: 'Contact_Name__c', type: 'text', sortable: true},
            {label: 'Enrollment', fieldName: 'Enrollment_No__c', sortable: true},
            {label: 'Class Session Status', fieldName: 'Status__c', type:'picklist', sortable: true},
            {label: 'Class Name', fieldName: 'Class_Name__c', sortable: true},
            
        ]);
            var action = component.get("c.fetchAttendance");
            component.set('v.loaded', false);
            action.setParams({
                recId : component.get("v.id")
            });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            component.set('v.loaded', true);
            var allRecords = response.getReturnValue();
            if (allRecords.length == 0) {
            	component.set('v.Message', true);
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                title : 'Info:',
                type: 'info',
                message: ' No class absentees records are left here to create the make-Up class attendance!',
                duration:'200',
                key: 'info_alt',
                mode: 'dismissible'
                });
                toastEvent.fire();
            } 
                console.log( ' AllRecords ' + allRecords);
                console.log( ' AllRecords length ' + allRecords.length);
                component.set("v.searchResult",allRecords);
                component.set("v.TotalNumberOfRecord", allRecords.length);
            }
            else if (state === "INCOMPLETE") {
            alert('Response is Incompleted');
            }
            else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
            if (errors[0] && errors[0].message) {
            alert("Error message: " + 
                  errors[0].message);
        }
        }else {
        alert("Unknown error");
        }
    }
    });
        $A.enqueueAction(action);
    }
})