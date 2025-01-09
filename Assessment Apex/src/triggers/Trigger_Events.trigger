trigger Trigger_Events on Event (After insert, After update, After delete, After unDelete) {
	if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert || Trigger.isdelete || Trigger.isUndelete) {
            EventTriggerHandler.updateActivitiesCountOnAccount(Trigger.new, Trigger.oldMap);
        }
    }
}