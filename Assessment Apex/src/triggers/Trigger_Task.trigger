trigger Trigger_Task on Task (After insert, After update, After delete, After unDelete) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert || Trigger.isdelete || Trigger.isUndelete) {
            TaskTriggerHandler.updateActivitiesCountOnAccount(Trigger.new, Trigger.oldMap);
        }
    }
}