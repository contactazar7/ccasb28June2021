public class MassTransferProvider_Recs {
    @AuraEnabled
    public static List<ListView> getListViews(){
        List<ListView> listviews = [select id, Name from ListView where SobjectType = 'Contact' and Name='All Provider'];
        return listviews;
    }
    @AuraEnabled
    public static List <Contact> fetchValues(String searchName, String searchProviderID, String searchRolodexID, String searchStudentID, String searchCity, String searchPostalCode, string searchStatus, string searchLanguage,  string searchRecruiter, string searchDate, string searchrecruiterAssesment, string searchrecruitmentProgam,  string searchrecruitmentType, string recruiterW_WO, string recLimits) {
        string sStatus = searchStatus;
        string sLanguage = searchLanguage;
        string sRecruiter = searchRecruiter;
        //String pName = '%' +searchName + '%';
        string pName =  searchName + '%';
        string pProviderID = searchProviderID + '%';
        string pRolodexID = searchRolodexID + '%';
        string pStudentID = '%'+ searchStudentID + '%';
        string pCity = searchCity + '%';
        string pPostalCode = searchPostalCode + '%';
        List < Contact > returnList = new List < Contact > ();
        string query = 'select id,Assigned_Name__c,Choice_of_Class_Language__c,Recruitment_Program__c,Recruitment_Type__c,Recruiter_Assigned_Date__c,Recruitment_Assessment__c,Recruiter__c,Recruitment_Status__c,EdFund_Facility_Primary__r.Name,EdFund_Facility_Secondary__r.Name,Student_ID__c,Rolodex_ID__c, Name,CCA_Provider_ID__c,MailingCity,Qualified__c,MailingPostalCode from Contact where id != null  ';
        if(string.isNotBlank(sStatus)){
            query = query + ' AND Recruitment_Status__c=: sStatus';
        }
        if(string.isNotBlank(sLanguage)){
            query = query + ' AND Choice_of_Class_Language__c=: sLanguage';
        }
        if(string.isNotBlank(searchrecruitmentType)){
            query = query + ' AND Recruitment_Type__c=: searchrecruitmentType';
        }
        if(string.isNotBlank(searchrecruiterAssesment)){
            query = query + ' AND Recruitment_Assessment__c=: searchrecruiterAssesment';
        }
        if(string.isNotBlank(searchrecruitmentProgam)){
            query = query + ' AND Recruitment_Program__c=: searchrecruitmentProgam';
        }
        if(string.isNotBlank(searchName)){
            query = query + ' AND Name LIKE: pName ';
        }
        if(string.isNotBlank(searchStudentID)){
            query = query + ' AND Student_ID__c LIKE: pStudentID';
        } 
        if(string.isNotBlank(searchCity)){
            query = query + ' AND MailingCity LIKE: pCity';
        }
        if(string.isNotBlank(searchPostalCode)){
            query = query + ' AND MailingPostalCode LIKE: pPostalCode';
        }
        if(string.isNotBlank(sRecruiter)) {
            system.debug( ' sRecruiter ' + sRecruiter);
            query = query + ' AND Recruiter__c =:sRecruiter';
        }
        if(string.isNotBlank(searchDate)){
            Date sDate = Date.valueOf(searchDate);
            query = query + ' AND Recruiter_Assigned_Date__c =:sDate';
        }
        if(string.isNotBlank(recruiterW_WO)){
            if( recruiterW_WO == '1' ){
                query = query + ' AND ( Recruiter__c != null OR Recruiter__c = null ) ';
            }else if(recruiterW_WO == '2' ){
                query = query + ' AND  Recruiter__c != null ';
            }else if(recruiterW_WO == '3' ){
                query = query + ' AND  Recruiter__c = null  ';
            }  
        }
        if(string.isNotBlank(recLimits)){
            Integer limits = Integer.valueOf(recLimits);
            query = query + '  Limit ' + limits;
        }
        if(string.isBlank(recLimits)){
            Integer limits = 100;
            query = query + '  Limit ' + limits;
        }
        system.debug( ' Query ' + query);
        List < Contact > lstOfContact = Database.query(query);
        system.debug(' lstOfContact '+lstOfContact);
        
        for (Contact c: lstOfContact) {
            returnList.add(c);
        }     
        return returnList;
    }
    @AuraEnabled
    public static Integer providerCount(){
        AggregateResult results = [SELECT Count(Id) providerCounts From Contact];
        Integer providerCount = (Integer)results.get('providerCounts'); 
        return providerCount;
    } 
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }   
    @AuraEnabled        
    public static List<String> getLanguagePickListValuesIntoList(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }   
    @AuraEnabled        
    public static List<String> getRecruitmentAssesment(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled        
    public static List<String> getRecruitmentProgram(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled        
    public static List<String> getRecruitmentType(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static List<contact> assignedUser(Id userId, string providerIds, string rType, string rProgram){
        List<Contact > contactList;
        set<Id> pId = new set<Id>();
        set<Id> pchcId = new set<Id>();
        set<Id> hcId = new set<Id>();
        List<Consumer__c> hcList;
        
        try{
            List<Contact> records = (List<Contact>)JSON.deserialize(providerIds, List<Contact>.class);
            contactList =  [select id,Assigned_Name__c,Recruitment_Type__c,Recruitment_Program__c,Recruiter_Assigned_Date__c,Recruiter__c,Recruitment_Status__c,EdFund_Facility_Primary__r.Name,EdFund_Facility_Secondary__r.Name,Student_ID__c,Rolodex_ID__c, Name,CCA_Provider_ID__c,MailingCity, Qualified__c,MailingPostalCode from Contact where id=:records];
            for(contact c : contactList){
                pId.add(c.Id);
                if(string.isNotBlank(userId)){
                    c.Recruiter__c  = userId;
                    c.Recruiter_Assigned_Date__c = system.today();
                }
                if(string.isNotBlank(rType)){
                    c.Recruitment_Type__c = rType;
                }
                if(string.isNotBlank(rProgram)){
                    c.Recruitment_Program__c = rProgram;
                }
            }
            for( Provider_Consumer_Affiliation__c p: [select Id,name,Home_Care_Consumer__c,Affiliation_Status__c,Provider__c from Provider_Consumer_Affiliation__c where Provider__c IN:pId and Affiliation_Status__c='Current'] ){
                pchcId.add(p.Id);
                hcId.add(p.Home_Care_Consumer__c);
            }
            hcList = [select id, name, Recruiter__c from Consumer__c  where id IN:hcId];
            for(Consumer__c  h: hcList ){
                if(string.isNotBlank(userId)){
                    h.Recruiter__c  = userId;
                }
            }
            
        }catch(Exception e){
            system.debug(' Exception e ' + e);
            system.debug(' Exception Message ' + e.getMessage());
            system.debug(' Exception Line Number ' + e.getMessage());
            system.debug(' Exception Cause ' + e.getCause());
        }
        update contactList;
        update hcList;
        return contactList;
    }   
}