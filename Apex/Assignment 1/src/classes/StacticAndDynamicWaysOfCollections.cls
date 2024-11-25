/**
 * Purpose : Map of String and values as List of String Assignment 1 Apex
 * Created By : Mukul Pichunia
 * Created Date : 25/11/2024
 *  
 **/

public with sharing class StacticAndDynamicWaysOfCollections {

   
    
    public static Map<String, List<String>> getDepartment() {
        Map<String, List<String>> departmentEmployee = new Map<String, List<String>>
            {
                'IT' => new List<String>{'Mukul','Aman','Divyanshu'},
                'HR' => new List<String>{'Saloni','Abhijeet','Vikas'},
                'DevOps'=> new List<String>{'Aniket','Arup','Swapnil'}   	
            };   
        return departmentEmployee;
    }

    public static void printMap() {
		Map<String, List<String>> departmentEmployee = getDepartment();
        for (String department : departmentEmployee.keySet()) {
            System.debug('Department: ' + department + ' Employees: ' + departmentEmployee.get(department));
        }
    }

    //Set Implementation
    public static void studentsGroups() {
        // Initialize two groups of students
        Set<String> groupA = new Set<String>{'Mukul', 'Saloni', 'Aman', 'Divyanshu'};
        Set<String> groupB = new Set<String>{'Mukul', 'Aman', 'Abhijeet', 'Frank'};
        System.debug('Group A: ' + groupA);
        System.debug('Group B: ' + groupB);
        System.debug('Union: ' + unionSet(groupA, groupB));
        System.debug('Intersection: ' + intersectionSet(groupA, groupB));
        System.debug('Difference (Group A - Group B): ' + differenceSet(groupA, groupB));
    }

    // Method to find the union of two sets
    private static Set<String> unionSet(Set<String> groupA, Set<String> groupB) {
        Set<String> unionSet = new Set<String>(groupA);
        unionSet.addAll(groupB);
        return unionSet;
    }

    // Method to find the intersection of two sets
    private static Set<String> intersectionSet(Set<String> groupA, Set<String> groupB) {
        Set<String> intersectionSet = new Set<String>(groupA);
        intersectionSet.retainAll(groupB);
        return intersectionSet;
    }

    // Method to find the difference of two sets (Group A - Group B)
    private static Set<String> differenceSet(Set<String> groupA, Set<String> groupB) {
        Set<String> differenceSet = new Set<String>(groupA);
        differenceSet.removeAll(groupB);
        return differenceSet;
    }

    //List Implementations
    public static void getSortedList() {
        List<Integer> numbers = new List<Integer>{42, 7, 15, 3, 89, 24};
        System.debug('Before Sorting: ' + numbers);
        sortedList(numbers);
        System.debug('After Sorting: ' + numbers);        
    }
    private static void sortedList(List<Integer> numbers) {
        numbers.sort();
    }
}