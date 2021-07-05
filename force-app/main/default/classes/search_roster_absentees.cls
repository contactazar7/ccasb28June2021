/**
*  Created By: Azar- Cube84
*  search_roster_absentees class is used for creating the Attendance records for the Regular Class Type Absentees from the Roster Records.
*  We could create the Make Up Class Attendance from the Add to Makeup Class Button from the
*  Make Up Class Detail pgae or It could create the Attendance records from the Add to Make-Up Class from the 
*  View Roster button on the Class record page
*/
public class search_roster_absentees {
    
    @AuraEnabled
    public static List<Attendance__c> fetchAttendance(string recId){
        system.debug('Make up Class Id - recId === '+recId);
        set<string> roster_id = new set<string>();
        set<string> makeup_id = new set<string>();
        if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Roaster__c'){
            system.debug(' Roster ');
            for(Make_Up_Class__c m: [select id, Roster_Name__c, Roster_Name__r.id, Class__c,Class_Scheduled_Date__c,Status__c from Make_Up_Class__c where Roster_Name__c=:recId and Status__c='Open']){
                roster_id.add(m.Roster_Name__r.id);
                makeup_id.add(m.Id);
            }
        }else if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Make_Up_Class__c'){
            system.debug(' Make-Up ');
            for(Make_Up_Class__c m: [select id, Roster_Name__c, Roster_Name__r.id, Class__c,Class_Scheduled_Date__c,Status__c from Make_Up_Class__c where id=:recId and Status__c='Open']){
                roster_id.add(m.Roster_Name__r.id);
                makeup_id.add(m.Id);
            }
        }
        system.debug('makeup_id with roster records ' + roster_id);
        List < Attendance__c > returnList = [Select id,Students_RSVP__c,createdDate,name,Class_Name__c,Enrollment_No__c,Enrollment__r.name,MakeUp_Created__c,
                                             Roaster_No__c,Contact_Name__c,Class__c,Class__r.id,Class__r.Name,Contact__c,Contact__r.id,
                                             Contact__r.Name,Date__c,Enrollment__c,Enrollment__r.Approval_Status__c,Enrollment__r.Status__c,Roaster__c,Status__c,Make_Up_Class__c,Makeup_Class_status__c,
                                             Has_Make_Up_Class__c from Attendance__c where (( Roaster__r.id IN: roster_id and Status__c='Absent' and Makeup_Class_status__c ='Need to attend make-up class' and MakeUp_Created__c = false) or (Make_Up_Class__r.id=: makeup_id and Status__c='Absent' and Makeup_Class_status__c ='Absent' and MakeUp_Created__c = false)) and ((Enrollment__r.Approval_Status__c = '' or Enrollment__r.Approval_Status__c = 'Approved') and Enrollment__r.Status__c= 'Enrolled')];
        system.debug('makeup_id with roster records ' + returnList);
        system.debug('makeup_id with roster records size ' + returnList.size()); 
        return returnList;
    }
    @AuraEnabled
    public static List<Attendance__c > createAtdrecords(List<Id> jsonString, string recId){
        List<Attendance__c > recordslist = new List<Attendance__c >();
        List<Approval_for_Makeup__c> approvalMakeup = new List<Approval_for_Makeup__c>();
        List<Make_Up_Class__c> make_up_Class;
        set<Id> rosterid = new set<Id>();
        set<Id> enrollmentAttId = new set<Id>();
        
        try{
            system.debug(' jsonString== '+jsonString);
            system.debug(' Make Up recId== '+recId);
            system.debug( ' sObject Name based on Ids ' + string.valueof(Id.valueOf(recId).getsobjecttype()));
            
            List<Attendance__c > Exsit_recordslist = [select id,Students_RSVP__c,Makeup_Class_status__c,createdDate,name, Class_Name__c, Enrollment_No__c,Enrollment__r.id,Class_Type__c,
                                                      Roaster_No__c, Contact_Name__c, Class__c,Class__r.id,Class__r.Name, Contact__c, Contact__r.id, Contact__r.Name,Date__c,
                                                      Enrollment__c, Roaster__c,Roaster__r.id, Status__c, Has_Make_Up_Class__c, MakeUp_Created__c from Attendance__c where id=:jsonString];
            system.debug(' Exsit_recordslist '+Exsit_recordslist);
            system.debug(' Exsit_recordslist size '+Exsit_recordslist.size());
            
            //If condition based on the Id name - Roster or Make Up  
            if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Roaster__c'){
                make_up_Class = [select id, Roster_Name__c, Roster_Name__r.id, Class__c , Class__r.id, Class_Scheduled_Date__c from Make_Up_Class__c where Roster_Name__c=:recId and Status__c='Open'];
                system.debug(' make_up_Class '+make_up_Class);
                system.debug(' make_up_Class size '+make_up_Class.size());
            }else if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Make_Up_Class__c'){
                make_up_Class = [select id, Roster_Name__c, Roster_Name__r.id, Class__c , Class__r.id, Class_Scheduled_Date__c from Make_Up_Class__c where id=:recId and Status__c='Open'];
                system.debug(' make_up_Class '+make_up_Class);
                system.debug(' make_up_Class size '+make_up_Class.size());
            }
            for(Attendance__c at: Exsit_recordslist){
                at.MakeUp_Created__c = True;
                rosterid.add(at.Roaster__c);
                for( Make_Up_Class__c m :  make_up_Class){
                    Attendance__c a = new Attendance__c();
                    a.Roaster__c = m.Roster_Name__r.id;
                    a.Date__c = m.Class_Scheduled_Date__c;
                    a.Contact__c = at.Contact__r.id;
                    a.Enrollment__c = at.Enrollment__r.id;
                    a.Class__c = m.Class__r.id;
                    a.Make_Up_Class__c = m.id;
                    a.Status__c = 'Scheduled';
                    a.Has_Make_Up_Class__c = True;
                    a.Students_RSVP__c = 'Awaiting RSVP';
                    a.Class_Type__c = 'Make-up';
                    a.Makeup_Class_status__c = 'Open';
                    recordslist.add(a);  
                }
            }
            Insert recordslist;
            if(!recordslist.isEmpty()){
                update Exsit_recordslist;
                system.debug('Exsit_recordslist '+Exsit_recordslist);
                system.debug('Exsit_recordslist size '+Exsit_recordslist.size());
                
                for(Attendance__c at : recordslist){
                    system.debug('Attendance Class Type '+ at.Class_Type__c);
                    if(at.Class_Type__c == 'Make-up'){
                        enrollmentAttId.add(at.Enrollment__c);
                    }
                }
                
                system.debug(' enrollmentAttId ' + enrollmentAttId);
                system.debug(' EnrollMent Number Size ' + enrollmentAttId.size());
                List<SFDC_Enrollment__c > enrollment_recs = [select Id, Name, Contact__c,Status__c,Approval_Status__c,Contact__r.name, Class__c , MakeUp_count__c , Severity__c  From SFDC_Enrollment__c where id In:enrollmentAttId];
                system.debug(' Enrollement that needs to be Updated ' + enrollment_recs);
                
                
                
                for(SFDC_Enrollment__c en : enrollment_recs){
                    system.debug('enrollment records as absentees '+en);
                    system.debug('show this when it is Make up is '+ en.MakeUp_count__c);
                    en.MakeUp_count__c = en.MakeUp_count__c + 1;
                    system.debug('Enrollment makeup count after adding is  '+en.MakeUp_count__c);
                    if((en.MakeUp_count__c) < 2 ){
                        system.debug('en.MakeUp_count__c <2' +en.MakeUp_count__c);
                        en.Severity__c = 'Low';
                    }else if((en.MakeUp_count__c) == 2){
                        system.debug('en.MakeUp_count__c == 2 ' +en.MakeUp_count__c);
                        en.Severity__c = 'Medium';
                        if(en.Approval_Status__c== null){
                            en.Approval_Status__c = 'Pending Approval';
                            Approval_for_Makeup__c app = new Approval_for_Makeup__c();
                            app.Enrollment__c = en.id;
                            app.Provider_Name__c = en.Contact__c;
                            app.Status__c = 'Pending Approval';
                            app.Class_Session__c = recId;
                            app.Class_Name__c = en.Class__c;
                            approvalMakeup.add(app);
                            
                        }
                    }else if((en.MakeUp_count__c) >2){
                        system.debug('en.MakeUp_count__c > 2' +en.MakeUp_count__c);
                        en.Severity__c = 'High';
                        if(en.Approval_Status__c == 'Approved'){
                            en.Approval_Status__c = 'Pending Approval';
                            Approval_for_Makeup__c app = new Approval_for_Makeup__c();
                            app.Enrollment__c = en.id;
                            app.Provider_Name__c = en.Contact__c;
                            app.Status__c = 'Pending Approval';
                            app.Class_Session__c = recId;
                            app.Class_Name__c = en.Class__c;
                            approvalMakeup.add(app);
                        }
                        
                    }
                    system.debug('enrollment_recs update makeupcount '+enrollment_recs);
                }   
                
                update enrollment_recs;
                system.debug('enrollment_recs '+enrollment_recs);
                system.debug('enrollment_recs size '+enrollment_recs.size());

                if(!enrollment_recs.isEmpty()){Insert approvalMakeup;}
                
                system.debug('rosterid from search Roster absentees '+rosterid);    
                List<Roaster__c> rosterlist= [select id,Class_Name__c,Count_of_Make_up_Attendance__c,Az_Make_up_Open__c,Make_Up_Count__c,Status__c,Count_of_Enrollment__c,Total_Present__c from Roaster__c where Id IN:rosterid];
                system.debug('rosterlist '+rosterlist);  
                system.debug('rosterlist size '+rosterlist.size());  
                
                for(Roaster__c r: rosterlist){
                    if(r.Count_of_Make_up_Attendance__c > 0){
                        r.Status__c = 'Make-Up Ongoing';
                    }
                } 
                
                update rosterlist;
                system.debug('rosterlist '+rosterlist);  
                system.debug('rosterlist size '+rosterlist.size());  
            }
            
            
            
        }catch(Exception e){
            system.debug(' Following== '+e);
            system.debug(' Line number ====> '+e.getLineNumber() + ' Exception Message =====> '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return recordslist;
    }
    @AuraEnabled
    public static string ClassId(string recId){
        List<Make_Up_Class__c > makeUpList;
        string classId = '';
        try {
            system.debug('Make up or Roster recId === '+recId);
            if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Roaster__c'){
                system.debug(' Roster ');
                makeUpList = [select id, Roster_Name__c, Roster_Name__r.id, Class__c,Class_Scheduled_Date__c,Status__c from Make_Up_Class__c where Roster_Name__c=:recId];
                classId= makeUpList[0].Class__c;
            }else if(string.valueof(Id.valueOf(recId).getsobjecttype()) == 'Make_Up_Class__c'){
                system.debug(' Make-Up ');
                makeUpList = [select id, Roster_Name__c, Roster_Name__r.id, Class__c,Class_Scheduled_Date__c,Status__c from Make_Up_Class__c where id=:recId];
                classId= makeUpList[0].Class__c;
            } 
            system.debug(' classId ' + classId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return classId;
    }
}