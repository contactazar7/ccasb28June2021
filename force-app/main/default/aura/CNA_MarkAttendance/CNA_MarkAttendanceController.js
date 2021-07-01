({
    onPageReferenceChange: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var id = myPageRef.state.c__id;
        component.set("v.id", id);
        if(component.get("v.id") != null){
            helper.setupTable(component,event,helper);
        }
    }, 
    //Below onChangeVal function is used for to pass the Class scheduled date to get the attendance.
    onChangeVal:function(component,event,helper) {
        //console.log(' set Id '+component.get("v.id"));
        helper.setupTable(component,event,helper);
    },
    reset : function(component,event,helper){
        component.set('v.classDate','');
        helper.setupTable(component);
    },
    saveTableRecords : function(component, event, helper) {
        var recordsData = event.getParam("recordsString");
        var tableAuraId = event.getParam("tableAuraId");
        var action = component.get("c.updateRecords");
        
        action.setParams({
            jsonString: recordsData
        });
        action.setCallback(this,function(response){
            var datatable = component.find(tableAuraId);
            datatable.finishSaving("SUCCESS");
        });
        $A.enqueueAction(action);        
    },
    
    navigate : function(component, event, helper){
        var recordlinkto = component.get("v.id");
        var navEvt = $A.get("e.force:navigateToSObject");
        //console.log('navEvt '+navEvt);
        navEvt.setParams({
            "recordId": recordlinkto,
        });
        navEvt.fire();
    },
    handleRecordSelectEvent : function(component, event, helper){
        var selectedRecords = event.getParam("selectedRecords");
        component.set('v.selectedRecords',selectedRecords); 
    },
    
    handleSelect : function(component, event, helper){
        var selectedMenu = event.detail.menuItem.get("v.value");
        var selectedRecords = component.get('v.selectedRecords');
        var attIds = [];
        selectedRecords.forEach(function(row){
            attIds.push(row.id);
        })
        var action = component.get("c.updateMassRecords");
        action.setParams({
            selectedMenu : selectedMenu,
            attIds : attIds
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);  
    },
    showModel: function(component, event, helper) {
        component.set("v.showModal", true);
        var action = component.get("c.getPiklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.ModuleList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    saveDetails: function(component, event, helper) {
        var selectedValues = component.get("v.selectedModuleList");
        //console.log('Selectd Values -' + selectedValues);
        
        //Save Module for the Selected Records 
        
        var selectedRecords = component.get('v.selectedRecords');
        //console.log('selectedRecords -' + selectedRecords);
        
        var attIds = [];
        selectedRecords.forEach(function(row){
            attIds.push(row.id);
        })
        
        //console.log('attIds -' + attIds);
        var action = component.get("c.updateModulesRecs");
        action.setParams({
            selectedValues : JSON.stringify(selectedValues),
            attIds : attIds
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            //console.log('state response after Module Saved - ' + state);
            if(response.getState() === "SUCCESS"){
                console.log( ' State ' + response.getState() );
                console.log( ' Resoponse values modules ' + response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log('Error message - ' + message);
            }
        });
        $A.enqueueAction(action);
        
        component.set("v.showModal", false);
        $A.get('e.force:refreshView').fire();
    },
    
    handleModuleChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.selectedModuleList", selectedValues);
    }
})