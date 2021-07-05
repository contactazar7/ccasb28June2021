public class Mycontroller {

    
     @AuraEnabled   
    public static map<string,object> getContactInfo(Id recordId)
    {
        map<string,object> mapObjects =new map<string,object>();
        map<string,string> mapIds =new map<string,string>();
          system.debug(String.valueOf(recordId.getSobjectType()));
        String objectName = String.valueOf(recordId.getSobjectType());
        system.debug(''+objectName);
        
            Recruitment_Assessment_Note__c con=[select id,Recruitment_Program__c,Recruitment_Type__c,Recruiter_Assigned_Date__c,Recruiter__c from Recruitment_Assessment_Note__c where id =: recordId]; 
            mapIds.put(con.id,con.Provider__c);
            system.debug(mapIds);
        
        mapObjects.put('ObjectName',objectName);
        mapObjects.put('Ids',mapIds);
        return mapObjects;
    }
}