public with sharing class currentUserInfoCtrl {
   @AuraEnabled 
    public static List<Contact> fetchUser(){
     // query current user information 
     List<Contact> Provider = new List<Contact>(); 
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          Provider = [select id,Name,FirstName,LastName,Salutation,CCA_Provider_ID__c,Student_ID__c,Gender__c,Phone_number__c,Email__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone from Contact where Phone ='1234567890']; 
       // }
        return Provider;
    }
     @AuraEnabled 
    public static List<SFDC_Enrollment__c> fetchclass(){
     // query current user information 
     List<Contact> Provider = new List<Contact>(); 
         List<SFDC_Enrollment__c> enrollerclass = new List<SFDC_Enrollment__c>(); 
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          Provider = [select id,Name,FirstName,LastName,Salutation,CCA_Provider_ID__c,Student_ID__c,Gender__c,Phone_number__c,Email__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone from Contact where Phone = '1234567890']; 
        if(Provider.size()>0)
      enrollerclass =[select id,Name,Enrollment__c,Contact__r.Name,Consumer_Name__c,Class__r.Name,Status__c,CPR_Status__c,CPR_Valid_Till__c,Enrolment_Status_C__c	from SFDC_Enrollment__c where Status__c ='Enrolled' and Contact__c =:Provider[0].id];
        // }
        return enrollerclass;
    }
    @AuraEnabled 
    public static List<Contact> fetchattendence(){
     // query current user information 
     List<Contact> Provider = new List<Contact>(); 
        
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          Provider = [select id,Name,Participation_form_submitted__c,FirstName,LastName,Salutation,CCA_Provider_ID__c,Student_ID__c,Gender__c,Phone_number__c,Email__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,(select id,Name,Class__r.Name,Date__c,Contact__c,Status__c,Students_RSVP__c from Attendance__r),(select id,PPF_Last_Name__c,PPF_Middle_Name__c,PPF_First_Name__c,PPF_Date_of_Birth__c,PPF_Email__c,PPF_Gender__c,Provider__c from Provider_Participant_Forms__r) from Contact where Phone = '1234567890']; 

        return Provider;
    }
     @AuraEnabled 
    public static List<Provider_Consumer_Affiliation__c> fetchproviderandaff(){
     // query current user information 
     List<Contact> Provider = new List<Contact>(); 
             List<Provider_Consumer_Affiliation__c> aff = new List<Provider_Consumer_Affiliation__c>(); 

      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          Provider = [select id,Name,Phone,FirstName,LastName,Salutation,CCA_Provider_ID__c,Student_ID__c,Gender__c,Phone_number__c,Email__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry from Contact where Phone = '1234567890']; 
        system.debug('ss'+Provider);
        if(Provider.size()>0){
            aff =[select id,Name,CCA_Consumer_ID__c,CCA_Provider_ID__c,Home_Care_Consumer__r.Name,Provider_s_Name__c,Relationship__c,Is_Consumer_a_relative_of_Provider__c from Provider_Consumer_Affiliation__c where Provider__c =:Provider[0].Id];
 system.debug('ss'+aff);
        }
        return aff;
    }
    
    
     
   
    @AuraEnabled
    public static Map<String,String> saveContactList(List<Contact> contactList) {
        // Forming a  string map to return response
        Map<String,String> resultMap = new Map<String,String>();
        // Adding try catch for exception handling
        try {
                // Updating the Contact List
            update contactList;
            // Setting the success status and message in resultMap
            resultMap.put('status', 'success');
                resultMap.put('message', 'Contacts Updated Successfully');        
        }
        catch(Exception e) {
            // Setting the success status and message in resultMap
            resultMap.put('status', 'error');
                        resultMap.put('message',e.getMessage());
        }
        // Returning the result string map
        return resultMap;
    }
    /* @AuraEnabled 
    public static List<SFDC_Enrollment__c> fetchconsumerclas(){
     // query current user information 
     List<Home_Care_Seeker_Consumer__c> consumer = new List<Home_Care_Seeker_Consumer__c>(); 
         List<SFDC_Enrollment__c> enrollerclass = new List<SFDC_Enrollment__c>(); 
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          consumer = [select id,Name,First_Name__c,Last_Name__c,CCA_Consumer_ID__c,Gender__c,Cell_Phone__c,Date_of_Birth__c,Email__c,Address__c,Street_Address__c,City__c,State__c from Home_Care_Seeker_Consumer__c where Cell_Phone__c = '1234567890']; 
        if(consumer.size()>0)
      enrollerclass =[select id,Name,Enrollment__c,Consumer_Name__r.Name,Consumer_Name__c,Class__r.Name,Status__c,CPR_Status__c,CPR_Valid_Till__c,Enrolment_Status_C__c	from SFDC_Enrollment__c where Status__c ='Enrolled' and Consumer_Name__c =:consumer[0].id];
        // }
        return enrollerclass;
    }
         @AuraEnabled 
    public static List<Provider_Consumer_Affiliation__c> fetchconsumerandparticiaptionaffi(){
     // query current user information 
     List<Home_Care_Seeker_Consumer__c> consumer = new List<Home_Care_Seeker_Consumer__c>(); 
             List<Provider_Consumer_Affiliation__c> aff = new List<Provider_Consumer_Affiliation__c>(); 

      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,SmallPhotoUrl, FullPhotoUrl,Phone 
                 FROM User Where id =: userInfo.getUserId()];
      //  if(oUser.Phone!=null){
          consumer = [select id,Name,First_Name__c,Last_Name__c,CCA_Consumer_ID__c,Gender__c,Cell_Phone__c,Date_of_Birth__c,Email__c,Address__c,Street_Address__c,City__c,State__c from Home_Care_Seeker_Consumer__c where Cell_Phone__c = '1234567890']; 
        if(consumer.size()>0){
            aff =[select id,Name,CCA_Consumer_ID__c,CCA_Provider_ID__c,Home_Care_Consumer__r.Name,Home_Care_Consumer__c,Provider_s_Name__c,Relationship__c,Is_Consumer_a_relative_of_Provider__c from Provider_Consumer_Affiliation__c where Home_Care_Consumer__r.Name =:consumer[0].Name];
            
        }
        return aff;
    }
   */
}