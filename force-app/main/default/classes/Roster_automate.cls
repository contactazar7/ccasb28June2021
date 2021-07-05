public with sharing class Roster_automate {
    
    public List<Roaster__c> roasterlist {get;set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    public Id recId {get; set;}
    public SFDC_Class__c classrec {get; set;}
    public static string Days {get;set;}
    public List<string > weeksession {get;set;}
    public string message{get;set;}
    public Roster_automate(ApexPages.StandardController controller){
        classrec = (SFDC_Class__c)controller.getRecord();
        recId = classrec.Id;
        message = '';
    }
    public PageReference createRosterRecs() {
        createRosterRecs(recId);
        PageReference pageRef;
        if(message == 'SUCCESS'){
            pageRef = new PageReference('/'+recId);
            pageRef.setRedirect(true);
        }
        return pageRef;
    }
    public PageReference back() {
        PageReference pageRef = new PageReference('/'+recId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void createRosterRecs(Id recId){
        
        recId = this.recId;
        roasterlist = new List<Roaster__c>();
        weeksession = new List<string>();
        
        SFDC_Class__c cls = [select id,name,Days__c,Class_Category__c,Class_Days__c,Same_time_for_all_days__c,Start_Date__c,End_Date__c,Start_Time__c, End_Time__c, Monday_Start_Time__c,Tuesday_Start_Time__c,
                             Wednesday_Start_Time__c,Thursday_Start_Time__c,Friday_Start_Time__c,Saturday_Start_Time__c,Sunday_Start_Time1__c,Monday_End_Time__c,Tuesday_End_Time__c,Wednesday_End_Time__c,
                             Thursday_End_Time__c,Friday_End_Time__c,Saturday_End_Time__c,Sunday_End_Time1__c  From SFDC_Class__c where id=:recId];
        
        List<Roaster__c> roasterLists = [select id,Class_Name__c,Module__c,Session_Order_Number__c,Class_Name__r.id,Start_Time__c,End_Time__c,Class_Scheduled_Date__c,Status__c From Roaster__c where Class_Name__r.id=:cls.id];
       
        List<Modules__c> modulelists = [select id, Name, Class_Category__c, Is_Active__c, Is_it_a_Mandatory_module__c, Module_Order_number__c From Modules__c where  Class_Category__c=:cls.Class_Category__c];
        if(cls.Class_Days__c <> null){ 
            system.debug(' cls.Class_Days__c ' + cls.Class_Days__c);
          weeksession.addAll(cls.Class_Days__c.split(';'));
        }else{
           message = 'Please make ensure that class would contains start date and end date!'; 
        }
       
        
        Days = cls.Days__c;
        startDate = cls.Start_Date__c - 1 ;
        endDate = cls.End_Date__c;
        Integer noOfDays = startDate.daysBetween(endDate);
        Integer moduleNo = 0;
        for(Integer i=1; i<=noOfDays;i++){
            Date newDate = startDate.addDays(1);
            startDate = newDate;
            
            Integer day = startDate.DAY();
            Integer dayOfYear = startDate.YEAR();
            Integer month = startDate.MONTH();
            
            Date d = date.newinstance(dayOfYear,month, day);
            datetime myDate = datetime.newInstance(d.year(), d.month(), d.day());
            
            string dayName1 = myDate.format('EEEE');
            string dayName2 = myDate.format('EEE');
            
            if(weeksession.contains(dayName1) || weeksession.contains(dayName2)){
                //system.debug( ' dayName1 ' + dayName1 );
                //system.debug( ' dayName2 ' + dayName2 );
                
                if(roasterLists.isEmpty()){                        
                    Roaster__c roaster = new Roaster__c();
                    roaster.Class_Name__c = cls.id;
                    roaster.Class_Scheduled_Date__c = startDate;
                    roaster.Status__c = 'Open';
                    if( dayName1 == 'Monday' || dayName2 == 'Mon' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Monday_Start_Time__c;
                            roaster.End_Time__c = cls.Monday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        } 
                    }else if( dayName1 == 'Tuesday' || dayName2 == 'Tue' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Tuesday_Start_Time__c;
                            roaster.End_Time__c = cls.Tuesday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        } 
                    }else if( dayName1 == 'Wednesday' || dayName2 == 'Wed' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Wednesday_Start_Time__c;
                            roaster.End_Time__c = cls.Wednesday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        }    
                    }else if( dayName1 == 'Thursday' || dayName2 == 'Thu' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Thursday_Start_Time__c;
                            roaster.End_Time__c = cls.Thursday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        } 
                    }else if( dayName1 == 'Friday' || dayName2 == 'Fri' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Friday_Start_Time__c;
                            roaster.End_Time__c = cls.Friday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        } 
                    }else if( dayName1 == 'Saturday' || dayName2 == 'Sat' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Saturday_Start_Time__c;
                            roaster.End_Time__c = cls.Saturday_End_Time__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        } 
                    }else if( dayName1 == 'Sunday' || dayName2 == 'Sun' ){
                        if(cls.Same_time_for_all_days__c == false){
                            roaster.Start_Time__c = cls.Sunday_Start_Time1__c;
                            roaster.End_Time__c = cls.Sunday_End_Time1__c;  
                        }else{
                            roaster.Start_Time__c = cls.Start_Time__c;
                            roaster.End_Time__c = cls.End_Time__c;  
                        }   
                    }
                    moduleNo++;
                    for(Modules__c m: [select id, Name, Class_Category__c, Is_Active__c, Is_it_a_Mandatory_module__c, Module_Order_number__c From Modules__c where  Class_Category__c=:cls.Class_Category__c and Module_Order_number__c=:moduleNo]){
                        roaster.Session_Order_Number__c = m.Module_Order_number__c;
                        roaster.Module__c = m.id;
                    }     
                    roasterlist.add(roaster);                                         
                }                
            }else{
                message = 'Selected days are not available between these Date!';
            }
        } 
        if(!roasterlist.isEmpty()){
            try{
                Database.saveResult [] srlistUpd = Database.Insert(roasterlist, false);
                for(Database.saveResult  rosRecords: srlistUpd){
                    if(rosRecords.isSuccess()){
                        message = 'SUCCESS';
                        system.debug('Successfully Inserted Roaster Records: ' + rosRecords);
                    } else {
                        for(Database.Error err : rosRecords.getErrors()) {
                            system.debug('The following error has occurred.');                    
                            system.debug(err.getStatusCode() + ': ' + err.getMessage());
                            system.debug('Roaster fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }catch(Exception ex){
                system.debug('Exception '+ ex);  
            }
            
        } 
    }
}