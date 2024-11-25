public with sharing class SchoolManager {
    public SchoolManager() {}
    public void updateNumberOfStudentsDetails(String schoolName) {

        School__c fetchedSchool  = [Select Id from School__c where School__c.Name = :schoolName];

        if (fetchedSchool.Active__c) {

            List<Class__c> classList = [Select Id from Class__c where School__r.Id = :fetchedSchool.id];

            if (classList.isEmpty()) {

                fetchedSchool.Active__c = false;

            } else {

                Set<Id> classSet = new Set<Id>();

                for (Class__c cls: classList) {

                    classSet.add(cls.Id);

                }
                List<AggregateResult> aggregateList = [Select Count(id) totalStudents, Class__r.Id classId 
                                                        from Student__c where Class__r.id IN :classSet 
                                                        group by Class__r.id];
                Integer totalStudents = 0;                                        
                For (AggregateResult ar :  aggregateList) {
                    totalStudents += (Integer) ar.get('totalStudents');
                   // System.debug('Class ID: ' + ar.get('classId') + ', Student Count: ' + ar.get('totalStudents'));

                }
                fetchedSchool.NumberOfStudents__c = totalStudents;
            }
            update fetchedSchool;
            System.debug('Updated school: ' + fetchedSchool);
        } else {
            System.debug('School not found');
        }

    }
}