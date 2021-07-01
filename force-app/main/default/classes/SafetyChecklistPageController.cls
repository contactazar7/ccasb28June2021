public class SafetyChecklistPageController {

      public string selectedOp {set;get;}
    public string selectedOp1 {set;get;}
     public string selectedOp2 {set;get;}
     public string selectedOp3 {set;get;}
     public string selectedOp4 {set;get;}
     public string selectedOp5 {set;get;}
     public string selectedOp6 {set;get;}
     public string selectedOp7 {set;get;}
     public string selectedOp8 {set;get;}
     public string selectedOp9 {set;get;}
     public string selectedOp10 {set;get;}
     public string selectedOp11 {set;get;}
     public string selectedOp12 {set;get;}
     public string selectedOp13 {set;get;}
     public string selectedOp14 {set;get;}
     public string selectedOp15 {set;get;}
     public string selectedOp16 {set;get;}
     public string selectedOp17 {set;get;}
     public string selectedOp18 {set;get;}
     public string selectedOp19 {set;get;}
     public string selectedOp20 {set;get;}
     public string selectedOp21 {set;get;}
     public string selectedOp22 {set;get;}
     public string selectedOp23 {set;get;}
     public string selectedOp24 {set;get;}
    public string selectedOp25 {set;get;}
     public string selectedOp26 {set;get;}
      public Facility__c fact;
    public ID parentId {get;set;}
    public string ugId {get;set;}
    
     public SafetyChecklistPageController(ApexPages.StandardController stdController) {
      this.fact = (Facility__c)stdController.getRecord();
         parentId=fact.id;
         ugId=fact.Name;
     }
    
     public pagereference updatecon(){
     
         PageReference pr = Page.PdfGeneratorTemplate;
        // Add parameters (if any) passed from the custom button or queried locally
        pr.getParameters().put('id', parentId);
        insert new Attachment(
                ParentId = fact.id,
                Name = fact.name,
                Body = pr.getContentAsPDF(),
                ContentType = 'application/pdf'
                );
         
         return new PageReference('/'+parentId);
  }  
     
}