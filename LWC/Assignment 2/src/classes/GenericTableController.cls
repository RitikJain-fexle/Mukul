public with sharing class GenericTableController {
    public GenericTableController() {

    }

    @AuraEnabled
    public static List<Sobject> doQuery(String objectName, String fieldsName, Integer limitValue){

        List<SObject> records = new List<Sobject>();
        String query = '';
        try {
            if (String.isNotBlank(objectName)) {
                if (String.isNotBlank(fieldsName)) {
                    if (String.isNotBlank(String.valueOf(limitValue))) {
                         query = 'SELECT ' + fieldsName+  ' FROM ' +  objectName + ' LIMIT ' + String.valueOf(limitValue);
                         records = Database.query(query);
                    } else {
                        throw new CustomException('Please Enter Limit');
                    }
                } else {
                    throw new CustomException('Please Enter Name');
                }
            } else {
                throw new CustomException('Please Enter Object Name');
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return records;
    }
    
}