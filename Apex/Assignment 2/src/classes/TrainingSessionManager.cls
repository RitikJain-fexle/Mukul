/**Purpose:(Assignment 2) Class To Perform Create, Read, Update, Delete on Training_Session__c.

Created by: Mukul Pichunia

Created Date : 27-11-24

Rivision Log: V:1.1

**/
public without sharing class TrainingSessionManager {
    public Enum SessionsType {
    WEBINAR, WORKSHOP, SEMINAR
	}
    public Enum Status {
        SUCCESS, FAILED
    }
    //Constructor
    public TrainingSessionManager() {

    }

    /*
     * @description: Creates a new Training_Session__c record.
     * @param sessionName The name of the training session.
     * @param typeOfSession The type of session (WEBINAR, WORKSHOP, SEMINAR).
     * @param sessionDate The date of the session.
     * @param location The location of the session (ignored for webinars).
     * @return The created Training_Session__c record.
     * @throws IllegalArgumentException if sessionName is blank or sessionDate is in the past.
     */
    public Training_Session__c createTrainingSessions(String sessionName,SessionsType typeOfSession,  Date sessionDate, String location) {
        // Check for sessionName validity
        if (String.isBlank(sessionName)) {
            // Throw an exception if sessionName is blank
            throw new IllegalArgumentException('Session Name must not be empty.');
        }
        if (sessionDate < Date.today()) {
            // Throw an exception if sessionDate is in past
            throw new IllegalArgumentException('Session Date must not be in past');
        }
        // Create new Training_Session__c record
        Training_Session__c trainingSessions = new Training_Session__c();
        trainingSessions.name = sessionName;
        trainingSessions.Session_Date__c = sessionDate;
        // Use of Enum
        if (typeOfSession == TrainingSessionManager.SessionsType.WEBINAR) {
            trainingSessions.Location__c =  'Remote';
        } else {
            trainingSessions.Location__c =  location;
        }
        try {
            //Insertion in database
            insert trainingSessions;
        } catch(DmlException e) {
            System.debug('Error Inserting traning sessions: ' + e.getMessage());
            throw e;
        }
        return trainingSessions;
    }

    /**
     * @description: Retrieves all Training_Session__c records ordered by Session_Date__c in descending order.
     * @return A list of Training_Session__c records.
     */
    public List<Training_Session__c> getAllTrainingSessions() {
        List<Training_Session__c> trainingSessions = new List<Training_Session__c>();
        try {
            // Retrieve records with relevant fields
            trainingSessions = 
        [SELECT Id, Name, Session_Date__c, Location__c 
        FROM Training_Session__c order by Session_Date__c desc];
        
        } catch(Exception e) {
            System.debug('Error Reteriving the Sessions');
			return new List<Training_Session__c>();
        }
        return trainingSessions;
    }
    /**
     * @description: Updates an existing Training_Session__c record.
     * @param recordUdationId The ID of the record to update.
     * @param updatedName The updated name for the training session.
     * @param trainingSessionDate The updated session date.
     * @return The updated Training_Session__c record.
     * @throws IllegalArgumentException if updatedName is blank or trainingSessionDate is in the past.
     */
    public List<Training_Session__c> updateFetchedRecords(Id recordUdationId, String updatedName, Date trainingSessionDate) {
        //Check for session Name
        if (String.isBlank(updatedName)) {
            // Throw an exception if sessionName is blank
            throw new IllegalArgumentException('Session Name must not be empty.');
        }
        if (trainingSessionDate < Date.today()) {
            // Throw an exception if sessionDate is in past
            throw new IllegalArgumentException('Session Date must not be in past');
        }
        List<Training_Session__c> trainingSessions = [SELECT Id, Name FROM Training_Session__c WHERE Id = :recordUdationId ];
        for (Training_Session__c session : trainingSessions) {
            
            session.Name = updatedName;
            session.Session_Date__c = trainingSessionDate;
            
        }
        try {
            //Updation in database
            update trainingSessions;
        } catch(DmlException e) {
            System.debug('Error Updating traning sessions: ' + e.getMessage());
            throw e;
        }
        return trainingSessions;
    }
   
    /**
     * @description: Deletes a Training_Session__c record by its ID.
     *
     * @param recordDeletionId The ID of the Training_Session__c record to delete.
     * @throws IllegalArgumentException if no record is found with the provided ID.
     */
    public void deleteSessionRecords(Id recordDeletionId) {
        try {
         List<Training_Session__c> trainingSessions = [SELECT Id, Name
                                                        FROM Training_Session__c 
                                                        WHERE Id = :recordDeletionId ];
         delete trainingSessions;
        } catch(Exception e) {
            System.debug('Error Fetching record: ' + e.getMessage());
        }
    }

    /**
     * @description: Adds attendees to a training session, ensuring no duplicate attendees are added.
     *
     * @param sessionId The ID of the Training_Session__c record.
     * @param attendeeIds A List of Attendee__c IDs to be added to the training session.
     * @return A List of Training_Attendee__c records successfully added.
     * @throws IllegalArgumentException if sessionId or attendeeIds are invalid.
     */
    public void addUniqueAttendeeToTrainingSession(Id trainingSessionId, List<Attendee__c> attendees) {
        if (trainingSessionId == null) {
            throw new IllegalArgumentException('Session ID must not be null.');
        }
        if (attendees.isEmpty()) {
            throw new IllegalArgumentException('Attendee IDs must not be null or empty.');
        }

        // Fetch existing attendee records for the Training_Session__c
        Set<Id> existingAttendeeInSessions = new Set<Id>();
        for (Attendee__c existingAttendee : [SELECT Id, Name FROM Attendee__c WHERE Training_Session_1__c = :trainingSessionId]) {
            existingAttendeeInSessions.add(existingAttendee.Id);
        }

        // Filter new attendees to only include unique ones
        List<Attendee__c> newAttendees = new List<Attendee__c>();
        for(Attendee__c newAttendee : attendees) {
            if(!existingAttendeeInSessions.contains(newAttendee.id)) {
                Attendee__c student = new Attendee__c();
                student.Training_Session_1__c = trainingSessionId;
                student.Id = newAttendee.Id;
				student.name = newAttendee.name;
                student.Email__c = newAttendee.Email__c;
                student.Phone__c = newAttendee.Phone__c;
                newAttendees.add(student);
            }
        }
        
        System.debug('@@@@@@@ pRINTING lSIT : '+  newAttendees);
        try {
            //Implementation of safe navigation operators
            if (newAttendees?.size() > 0 && !newAttendees.isEmpty()) {
                INSERT newAttendees;
            }
        } catch(DmlException e) {
            System.debug('Error Inserting Records: ' + e.getMessage());
        }
        
    }
	/**
     * @description: Use to test addUniqueAttendeeToTrainingSession() method.
     */
    public void makeAttendeeList() {
        List<Attendee__c> attendeeList = [SELECT Id, Name FROM Attendee__c];
        System.debug('@@@ Before' + attendeeList.size());
        Attendee__c  attendee = new Attendee__c();
        attendee.Name = 'ABC';
        attendee.Email__c = 'mukulpichunia@gmail.com';
        attendee.Phone__c = '1234545446';
        attendeeList.add(attendee);
        System.debug('##### : '+ attendeeList);
        addUniqueAttendeeToTrainingSession('a0GdM0000084MMPUA2', attendeeList);
		attendeeList = [SELECT Id, Name FROM Attendee__c];
        System.debug('@@@@ After ' + attendeeList.size());
   }
	/**
     * @description: Use to Fetch Training Sessions  based on Date Criteria.
     */
    public void FetchRecordsBasedOnDate() {
        List<Training_Session__c> dateList = [SELECT Id FROM Training_Session__c WHERE CreatedDate = YESTERDAY OR CreatedDate = LAST_N_DAYS:60];
    }
    /**
     * @description: Use to Fetch Attendee__c count on a  Training Session.
     */
    public void FetchRecordsBasedOnCount() {
        AggregateResult attendeeCount = [SELECT Count(Id) totalCount FROM Attendee__c where Training_Session__c = 'a0GdM0000084MMPUA2'];
        System.debug(attendeeCount.get('totalCount'));
    }
    /**
     * @description: Use to Fetch Records based on Record Type.
     */
    public void FetchRecordsBasedOnRecordType() {
        //Getting Webinar RT ID 
        String gsRecordTypeID = Schema.SObjectType.Training_Session__c.getRecordTypeInfosByName().get('Webinar RT').getRecordTypeId();
		System.debug(gsRecordTypeID);
        List<Training_Session__c> recordBasedSessions = [SELECT Id, Name FROM Training_Session__c where RecordTypeId = :gsRecordTypeID];
    }
    
	/**
     * @description: Creates a list of dummy Training_Session__c records for bulk operations.
     * @return: A List<Training_Session__c> containing dummy training session records.
     */
	public List<Training_Session__c> createList(){
   		List<Training_Session__c> ListToInsertUsingBulkOperation = new List<Training_Session__c>();
        for(Integer i=1;i<10;i++) {
          Training_Session__c Student = new Training_Session__c();
          Student.Name = 'FEXLE' + i;
          ListToInsertUsingBulkOperation.add(Student);	
    	}
        
        return ListToInsertUsingBulkOperation;
	}
    
    /**
     * @description: Deletes a set of Training_Session__c records in bulk.
     */
    public void deleteBulkRecords() {
        List<Training_Session__c> sessions = [SELECT ID FROM Training_Session__c LIMIT 5];
        if (!sessions.isEmpty()) {
            Database.DeleteResult[] DR_Dels = Database.delete(sessions, false);
            for (Database.DeleteResult result : DR_Dels) {
                if (result.isSuccess()) {
                    System.debug('Status: ' + Status.Success + ', Record ID: ' + result.getId());
                } else {
                    for (Database.Error error : result.getErrors()) {
                        System.debug('Status: ' + Status.Failed + ', Error: ' + error.getMessage());
                    }
                }
            
         	}
        }
    }
    /**
     * @description: Inserts a list of Training_Session__c records in bulk.
     */
    public void insertBulkRecords() {
        List<Training_Session__c> sessions = createList();
        List<Database.SaveResult> insertSessions = Database.insert(sessions, false);
        for (Database.SaveResult result : insertSessions) {
            if (result.isSuccess()) {
                System.debug('Status: ' + Status.Success + ', Record ID: ' + result.getId());
            } else {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Status: ' + Status.Failed + ', Error: ' + error.getMessage());
                }
            }
        }
    }
    
    /**
     * @description: Updates a batch of Training_Session__c records in bulk.
     */	
     public void updateBulkRecords() {
        List<Training_Session__c> records = [SELECT Id, Name FROM Training_Session__c LIMIT 5];
        for (Training_Session__c record : records) {
            record.Name += '_Updated';
        }
        Database.SaveResult[] saveResults = Database.update(records, false);
        for (Database.SaveResult result : saveResults) {
            if (result.isSuccess()) {
                System.debug('Status: ' + Status.Success + ', Record ID: ' + result.getId());
            } else {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Status: ' + Status.Failed + ', Error: ' + error.getMessage());
                }
            }
        }
    }
}