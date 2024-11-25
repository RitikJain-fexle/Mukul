public class DynamicCollections {
    Map<String, Map<String, List<Student2__c>>> mapOfSchoolNameWithClassNameAndRelatedStudentsDetails;
    public DynamicCollections() {
        mapOfSchoolNameWithClassNameAndRelatedStudentsDetails = new  Map<String, Map<String, List<Student2__c>>>();
        for (Student2__c st : [Select Name, Id,Class__c, Class__r.name,Class__r.School__c,Class__r.School__r.Name 
                               from Student2__c 
                               where Class__c != null
                               And Class__r.School__c != null
                              ]) 
        {
            if (mapOfSchoolNameWithClassNameAndRelatedStudentsDetails.containsKey(st.Class__r.School__r.Name)) {
                if (mapOfSchoolNameWithClassNameAndRelatedStudentsDetails.get(st.Class__r.School__r.Name)
                    .containsKey(st.Class__r.Name)) {
                    mapOfSchoolNameWithClassNameAndRelatedStudentsDetails.get(st.Class__r.School__r.Name).get(st.Class__r.Name)
                        .add(st);
                }  
                else {
                    mapOfSchoolNameWithClassNameAndRelatedStudentsDetails.get(st.Class__r.School__r.Name)
                        .put(st.Class__r.Name, new List<Student2__c> {st});
                }
                
            } else {
                Map<String, List<Student2__c>> mapClassNameWithStudents = new Map<String, List<Student2__c>>();
                if (!mapClassNameWithStudents.containsKey(st.Class__r.name)) {
                    mapClassNameWithStudents.put(st.class__r.Name, new List<Student2__c>());
                }
                mapClassNameWithStudents.get(st.Class__r.Name).add(st);
                mapOfSchoolNameWithClassNameAndRelatedStudentsDetails.put(st.Class__r.School__r.Name, mapClassNameWithStudents);
            }
        }
        
        System.debug('@@@@@@ map ' + mapOfSchoolNameWithClassNameAndRelatedStudentsDetails);
    }
}


//{Active Test={Class 12=(Student2__c:{Name=ST-0003, Id=a0NdM000009w5TZUAY, Class__c=a0DdM00000FUqqjUAD})}, 
//Kendriya Vidyalaya Number 5={Class 1=(Student2__c:{Name=ST-0001, Id=a0NdM000007zE6rUAE, Class__c=a0DdM00000Edip9UAB}), Class 2=(Student2__c:{Name=ST-0002, Id=a0NdM000009K4iDUAS, Class__c=a0DdM00000FKLxbUAH})}, 
//MyDream={clasee 33=(Student2__c:{Name=ST-0004, Id=a0NdM000009w6KnUAI, Class__c=a0DdM00000FMktBUAT})}}