This Design is for the algorithm that finds the sum of the first N natural numbers iteratively.  
Algorithm is as follows-  

```
sum = 0 ; 
for(i=N to i=1) 
	{
		sum +=i;
	} 
```

There is one main module and two submodules namely __ControlPath__ and __DataPath__ as can be seen in the `ModuleConnection.jpg`  

__DataPath__ module needs following resources-  
1. 	`register i` to store the value of decreamenter i  
2. 	`register sum` to store the value of sum  
3. 	`mux i` to control the input to the register i  
4. 	`mux sum` to control the input to the register sum  
5. 	`adder` to add the value of i to the previously computed sum  
6. 	`comparator` to compare i with 1

*Note-* Please refer `DataPath.jpg` image for better understanding  
 
 __ControlPath__ module needs following resources-  
 
 *Note-* Since there are three states needed in the FSM , we need atleast 2-bit registers.  
 1. 	`register state` to remember the current state  
 2.	`register next_state` to store the next state to be transitioned.  
 
 
