({
	myAction : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({ "url": "/lightning/n/View_Roster?c__id="+component.get("v.recordId")});
		urlEvent.fire();
	}
})