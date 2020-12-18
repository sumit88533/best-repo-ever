//Whenever Account status will change to Approved. Trigger will create ObjectB record and ObjectC record. ObjectB has direct relationship 
//with Account and ObjectB. But ObjectB has a master detail relastionship with ObjectC. So, ObjectCID__c is required field for ObjectB.
trigger CustomObjectATrigger on Account(after update){
    List<ObjectC__c> objCList = new List<ObjectC__c>();
    List<ObjectB__c> objBList = new List<ObjectC__c>();
    Map<Id,ObjectC__c> accountByobjC = new Map<Id,ObjectC__c>();
    for(Account nAccount: trigger.new){
        Account oAccount = trigger.oldMap.get(nAccount.Id);
        if(nAccount.status != oAccount.status && nAccount.status ='Approved'){
            ObjectC__c objC = new ObjectC__c(Status='Completed');
            objCList.add(objC);
            accountByobjC.put(nAccount.Id, objC);
        }
    }
    if(!objCList.isEmpty()){
        insert objCList;
    }
    for(Id id : accountByobjC.KeySet()){
        Id objCById = accountByobjC.get(id).Id;
        ObjectB__c objB = new ObjectB__c();
        objB.AccountId__c = id;
        objB.ObjectCID__c = objCById;
        objB.Status = 'Completed';
        objBList.add(objB);
    }
    if(!objBList.isEmpty()){
        insert objBList;
    }    
}
