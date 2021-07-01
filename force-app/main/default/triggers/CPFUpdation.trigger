trigger CPFUpdation on Consumer__c (before insert,before update,after insert,after update) {

    list<Contact> conlist=new list<Contact>();
    set<id> provID=new set<id>();
    
    if(Trigger.isBefore)
    {
        for(Consumer__c consu:Trigger.new)
        {
            consu.Name=consu.First_Name__c+' '+consu.Middle_Name__c+' '+consu.Last_Name__c;
        }
    }
    
    if(Trigger.isAfter)
    {
        
    list<Consumer__c> lstcons=[select id,(select id,name,Provider__c,Home_Care_Consumer__c from Provider_Consumer_Affiliations__r),name from Consumer__c where id IN : Trigger.new];
    for(Consumer__c cc:lstcons)
    {
       for(Provider_Consumer_Affiliation__c p:cc.Provider_Consumer_Affiliations__r)
       {
           provID.add(p.Provider__c);
       }
    }
    
    for(Consumer__c c:Trigger.new)
    {
        for(Contact con:[select id,BackendCheck__c,Consumer_Participation_form_submitted__c,CPF_Submitted_Date__c from Contact where id IN :provID])
        {
            if(c.Consumer_Participation_form_submitted__c==true && con.BackendCheck__c==false)
            {
                con.Consumer_Participation_form_submitted__c=true;
                con.CPF_Submitted_Date__c=system.today();
                con.BackendCheck__c=true;
                conlist.add(con);
            }
        }
    }
    update conlist;
        
        
    }
}