/*
	Author: Jeremy Kimotho
	Date: 10/10/2000
*/	
	.text		//code section. Read only section
	prnfmt1: .string "Enter an integer: "
	prnfmt2: .asciz "You have entered value %d\n\n"
	prnfmt3: .string "The value you entered is invalid. Please enter an integer value between 5 and 20\n"
	prnfmt6: .string "The number of occurences is: %d\n"
	prnfmt7: .string "\nThe document size is %d\n"
	prnfmt8: .string "The lowest frequency is %d%\n"
	prnfmt9: .string "The highest frequency is %d%\n"
	scnfmt: .asciz "%d"
	
	.balign 4
	.global main 

main:
	stp	x29,	x30,	[sp, -16]!	// save fp register and link register current values
	mov	x29,	sp			// update fp register 

	// Displaying a message asking the user to enter N an integer between 5 and 20
	ldr	x0,	=prnfmt1		// load register x0 with prnfmt1 which is the statement asking for an interger
	bl	printf				// Call C function printf
	
	// Getting user input using C function scanf
	ldr	x0,	=scnfmt			// load register x0 with the address of string input
	ldr	x1,	=entered_value		// load register x1 with the address of variable entered_value
	bl	scanf				// call C function scanf

	ldr	x1,	=entered_value		// load register x1 with address of variable entered_value again
	ldr	x19,	[x1]			// load content of entered_value to register x1

	// User input validation. Making sure value is between 5 and 20 inclusive
	
	mov	x20,	5			// copying the lowest value allowed to register x20 for comparison 
	cmp	x19,	x20			// comparing the value the user entered with the lowest value allowed
	b.lt	printEndInvalid			// if the value the user entered is lower than the lowest allowed value we branch to function printendinvalid which prints an error message to the user then ends the program
	
	mov	x20,	20			// copying the largest value allowed to register x20 for comparison 
	cmp	x19,	x20			// comparing the value the user entered with the largest value allowed
	b.gt	printEndInvalid			// if the value the user entered is larger than the largest allowed value we branch to function printendinvalid which prints an error message to the user then ends the program

	// Printing to the user the value they entered

	ldr     x0,     =prnfmt2                // loads register x0 with address of string message to be printed to the user
    	mov     x1,     x19                     // copies the user entered value we loaded into x19 into x1 to be printed with our message
    	bl      printf                          // print to the user the number the entered
	
	// Generating random number, then calculating frequencies and sorting, also calculating sum	
	mov	x23,	0			// register to be used for storing largest number generated
	mov	x24,	10			// register to be used for storing smallest number generated 
	mov	x25,	0			// register to be used for summing up our random numbers and this will be the document size	
	mov	x20,	x19			// the value we collected from the user is put copied into x20
	mov     x0,     xzr			// xzr which is 0 is added to x0 for seeding of our rand function
        bl      time 				// is the function that seeds our rand
        bl      srand				// to seed 
	b test					// a branching to a test that runs before the loop 
loop:						// the label name for our loop
	bl rand					// branch that  calls for a random integer then returns here
	mov	x3,	0xFF			// copies the value hexadecimal 255 to register x3
       	and     x2,     x0,    x3		// adds to register x2, the summation of our random integer and hexadecimal value 255. Thus ensures the value is kept below 256
        mov     x22,    x2			// copies our usable random number to register x22
	cmp	x22,	10			// compares the random number to 10
	b.ge	loop				// branches back to the beginning of our loop if random number is larger than 10. Does this till we generate a random number smaller than 10 
	add	x25,	x25,	x22		// this sums up the random numbers generated in x22 to the register x25 
	cmp	x22,	x23			// this compares the random number generated to the previous highest number in x23
	b.gt	greater				// if the  random number generated is higher than the previous highest then we branch to the greater function that makes it the new highest
	cmp	x22,	x24			// this compares the random number generated to the previous lowest number in x24
	b.lt	smaller				// if the random number generated is lower thsn the previous lowest then we branch to the smaller function that makes it the new lowest
compreturn:					// the label name for where we return after we make the random number we generated the new highest or lowest
	ldr     x0,     =prnfmt6		// loads register x0 with address of string message to display to user. 
        mov     x1,     x22			// copies our random integer to register x1 to be printed t to the user
        bl      printf				//print to the user a random integer
	sub    x20,    x20,    1		// decrement x20 which is the counter for our while loop	
test:						// the label name for our test we run  before the start of the loop. This tests if our counter x20 is equal to or smaller than 0, if not it branches back to the start of the loop. If so it ends the program.
        cmp     x20,    xzr			//compares our counter x20 to 0
        b.gt    loop				// checks if the value in our counter x20 is greater than 0 if it  is we branch back to the start of the loop
	b	finalPrint			// branch to the finalprint function that prints the frequencies and document size
greater:					// label name for the function where we swap the old largest and new largest
	mov	x23,	x22			// copy the new largest value in x22 into the register where we keep the largest value 
	b	compreturn			// branch back to the end of the loop where we print the random number and test if to continue the loop
smaller: 					// label name for the function where we swap the old smallest and new smallest
	mov	x24,	x22			// copy the new smallest value in x22 into the register where we keep the smallest value
	b	compreturn			// branch back to the end of the loop where we printthe random number and test if to continue the loop
finalPrint:					// label name forwhere we print the frequesncies and document size
        ldr     x0,     =prnfmt7		// loads register x0 with address of string message to display document size to user
        mov     x1,     x25			// copy document size to register x1 to be printed to the user
        bl      printf				// print the document size to the user
	ldr	x0,	=prnfmt8		// loads register x0 with address of string message to display smallest frequency to user
	mov	x26,	100			// copies value of  100 to x26 to be multiplied with smallest and largest as part of frequency calculation
	mul	x24,	x24,	x26		// multiplies the smallest value (stored  in x24) by 100 which is first part of frequency calculation
	sdiv	x24,	x24,	x25		// divides the value in x24 which is smallest value multiplied by 100 and divided it by document size and this is lowest frequency
	mov	x1,	x24			// copy smallest frequency to register x1 to be printed to the user
	bl	printf				// print the smallest frequency to the user
	ldr	x0,	=prnfmt9		// loads register x0 with address of string message to display highest frequency to user	
	mul	x23,	x23,	x26		// multiplies the largest value (stored  in x23) by 100 which is first part of frequency calculation
	sdiv	x23,	x23,	x25		// divides the value in x23 which is highest value multiplied by 100 and divided it by document size and this is highest frequency
	mov	x1,	x23			// copies highest frequency to register x1 to be printed to the user
	bl	printf				// print the highest frequency to the user
        b       end				// branches to the end function that restores fp and link registers

printEndInvalid:				// label name for where we print an error message and end the program if the user entered a value too small
	ldr	x0,	=prnfmt3		// load to regsiter x0 our error message
	bl	printf				// print  our error message to the user that their inputwas invalid
	b	end				// branch to the end function which restores fp and link registers

end:
	ldp	x29,	x30,	[sp], 16	// restore fp and link registers 
	ret

	// data section contains initialised global variables
	.data 		// in this section things can be written into as well as read
	entered_value:	.int	0		// scanf will store the number we asked the user to enter in this memory location		

