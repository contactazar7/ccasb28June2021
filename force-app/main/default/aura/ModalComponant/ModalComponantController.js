({
    doInit: function(component) {
        var strAccId = component.get("v.recordId");
        console.log('Opportunity Id ====>'+strAccId);
        $A.createComponent("c:NewRecruitmentAssessmentNote", 
                           {strRecordId : strAccId},
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLibDemo').showCustomModal({
                                       header: "New Recruitment Assessment Note",
                                       body: result, 
                                       showCloseButton: true,
                                       cssClass: "mymodal", 
                                   })
                               }                               
                           });
      
    }
})