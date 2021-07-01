public class CompetencyPostEnrollClass {

    
    public static void  getdate(list<SFDC_Enrollment__c> sfdlst)
    {
       //  list<SFDC_Enrollment__c> sfdlst=Trigger.isDelete ? Trigger.old:Trigger.new;
    set<ID> clsID=new set<ID>();
    set<ID> ProviderID=new set<ID>();
 
    for(SFDC_Enrollment__c se : sfdlst)
    {
        clsID.add(se.Class__c);
        ProviderID.add(se.Contact__c);
    }
    list<SFDC_Class__c> clsLst=[select id,name,competency_created__c from SFDC_Class__c where ID IN : clsID];
    
    list<SFDC_Enrollment__c> enrollList=[select id,Contact__c,Status__c from SFDC_Enrollment__c where Contact__c IN:ProviderID AND Status__c='Enrolled'];
    list<Contact> conlist=[select id,Single_ConsAffiliate__c,Enrollment_Check__c,Multi_ConsAffiliate__c,No_Affiliation__c from Contact where ID IN:ProviderID];

    for(SFDC_Class__c sc : clsLst)
    {
        for(SFDC_Enrollment__c sen : sfdlst)
        {
            if(sen.Status__c=='Enrolled')
            {
                sc.competency_created__c=false;
            }
        }
    }
    update clsLst; 
    
    for(Contact cc:conlist)
    {
        if(enrollList.size()>=1)
        {
            cc.Enrollment_Check__c=true;
        }
        else
        {
          cc.Enrollment_Check__c=false;  
        }
    }
    update conlist;
    }
}