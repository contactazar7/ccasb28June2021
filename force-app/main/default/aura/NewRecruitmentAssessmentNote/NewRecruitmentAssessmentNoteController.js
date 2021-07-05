({
	myAction : function(component, event, helper) {
		
	},  
    doInit : function(component, event, helper) {
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context = JSON.parse(window.atob(value));
        var recordId = context.attributes.recordId;
        //alert(context.attributes.recordId)
        
        var action = component.get('c.getContactInfo'); 
        // method name i.e. getEntity should be same as defined in apex class
        // params name i.e. entityType should be same as defined in getEntity method
        
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                var objectname = result['ObjectName'];
                for(var key in result['Ids']) {
                    
                      // component.set('v.AccountId',key);
                        component.set('v.ContactId',key);
                    
                   
                }
            }
        });
        $A.enqueueAction(action);
    },
    onCancel : function(component, event) {
        
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Recruitment_Assessment_Note__c"
        });
        homeEvt.fire();
        
    },
    
})