/**Purpose: This Class Demonstrate the Functionality and Usage of List, Set, Map With Different method like String.join(), Math.mod().
 * Created by: Mukul Pichunia
 * Created Date : 02-12-24
 * Revision Log: V:1.1
 **/

public class TwoDimensionalList {
    
    /*
     * Method to call transpose,  uniqueRowMap, uniqueAndSortedList
     */
    public void getList() {
        List<String> firstList = new List<String>{'a; b; a; v; c', 'x; x; y; c; q'};
        List<String> SecList = new List<String>{'m; b; h; j; m', 'u; k; j; u'};
        List<List<String>> listOfList =  new List<List<String>>{firstList, SecList};
        //transpose(listOfList);
        uniqueAndSortedList(listOfList);
    }
    
    /*
     * Transpose of 2D mmatrix
     */
    public void transpose(List<List<String>> twoDMatrix) {
        Integer rows = twoDMatrix.size();
        List<String> s1 = twoDMatrix.get(0);
        System.debug('Before'+ twoDMatrix); //((a; b; a; v; c, x; x; y; c; q), (m; b; h; j; m, u; k; j; u))
        Integer cols = twoDMatrix.get(0).size();
        
		List<List<String>> transposed = new List<List<String>>();
        for (Integer i = 0; i<cols ; i++) {
            transposed.add(new List<String>());
        }
        for (Integer i = 0; i < rows; i++) {
            
            for (Integer j = 0; j < cols; j++) {
                transposed[j].add(twoDMatrix[i][j]);
            }
        }
        
        System.debug('After'+transposed); //((a; b; a; v; c, m; b; h; j; m), (x; x; y; c; q, u; k; j; u))
		
    }
    
    /*
     * INPUT
     * firstList = {'a; b; a; v; c', 'x; x; y; c; q'};
     * secList = {'m; b; h; j; m', 'u; k; j; u'};
     * 
     * OUTPUT
	 * Row Map with Unique Values: { 0 => {a, b, v, c, x, y, q},
	 * 									1 => {m, b, h, j, u, k}}
     */
    
    public void uniqueRowMap(List<List<String>> twoDMatrix) {
        Map<Integer, Set<String>> rowIndexKey = new Map<Integer, Set<String>>();
        Integer rows = twoDMatrix.size();
		Integer cols = twoDMatrix.get(0).size();
        
        for (Integer i = 0; i< rows; i++) {
            Set<String> uniqueSet = new Set<String>();
            List<String> uniqueListWithSemi = new List<String>();
            for (Integer j = 0; j < cols; j++) {
                String s  = twoDMatrix.get(i).get(j);
                for (String uVal : s.split(';')) {
                    System.debug(uVal);//Splitng String by ; but there is no need if i am doing this by other input then this
                    uniqueSet.add(uVal.trim());
                } 
            }
            rowIndexKey.put(i, uniqueSet);
        }
        
        System.debug(rowIndexKey);
    }
	/**
     * firstList = {'a; b; a; v; c', 'x; x; y; c; q'};
     * secList = {'m; b; h; j; m', 'u; k; j; u'};
     * listOfList = {firstList, secList};
     * 
     * 
     * 
     * Output :- List of Lists: [['a; b; c; v', 'c; q; x; y'], ['b; h; j; m', 'j; k; u']]
	 */

	public  void uniqueAndSortedList(List<List<String>> listOfList) {
        
        List<List<String>> result = new List<List<String>>();
        
        for (List<String> sublist : listOfList) {
            List<String> newList = new List<String>();

            for (String s : sublist) {
                
                Set<String> uniqueSet = new Set<String>();
                for (String value : s.split(';')) {
                    uniqueSet.add(value.trim());
                }
                
                
                List<String> sortedList = new List<String>(uniqueSet);
                sortedList.sort();
                System.debug(sortedList);
                // String.join()
                String sortedStringWithSemiColon = String.join(sortedList, '; ');
                
                
                newList.add(sortedStringWithSemiColon);
            }
            
            result.add(newList);
        }
        System.debug('List : ' + result);  
        /*
         * Output :- List of Lists: [['a; b; c; v', 'c; q; x; y'], ['b; h; j; m', 'j; k; u']]
         */
        
	}


    /**
     * This method is use for calling listRotationClockwise() && listRotaionAntiClockWise()
     * 
	 */
    
    public void provideList() {
        List<Integer> inputList = new List<Integer>{1, 2,3,4,5,6,7};
        listRotaionAntiClockWise(inputList, 5);
    }
	/**
     * Rotation ClockWise as per user input
     * 
	 */
    public void listRotationClockwise(List<Integer> inputList, Integer rotations) {
        Integer listSize = inputList.size();
        
        rotations = Math.mod(rotations,listSize);
        for (Integer i = 0; i < rotations; i++) {
           
            Integer lastElement = inputList.remove(inputList.size() - 1);  
            inputList.add(0, lastElement);  
        }

        System.debug(inputList);
    }
    
    
    /**
     * Rotation AntiClockWise as per user input
     * 
	 */
    
    public void listRotaionAntiClockWise(List<Integer> inputList, Integer rotations) {
        Integer listSize = inputList.size();
        rotations = Math.mod(rotations,listSize);
        for (Integer i = 0; i < rotations; i++) {
           
            Integer firstElement = inputList.remove(0);  
            inputList.add(firstElement);  
        }

        System.debug(inputList);
	}
}