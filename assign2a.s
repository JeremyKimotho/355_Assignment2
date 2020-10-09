	.text		//code section. Read only section
prnfmt1: .string "Enter an integer:"
prnfmt2: .asciz "You have entered value %d\n"
prnfmt3: .string "The value you entered %d is too small. Please enter a value between 5 and 20\n"
prnfmt4: .string "The value you entered %d is too large. Please enter a value between 5 and 20\n"
prnfmt5: .string "equal\n"
prnfmt6: .string "The number that has been generated is: %d\n"
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
	ldr	x19,	[x1]			// load content of entered_value to register x19

	ldr	x0,	=prnfmt2		// loads register x0 with address of string message to be printed to the user
	mov	x1,	x19			// copies the user entered value we loaded into x19 into x1 to be printed with our message
	bl	printf				// print to the user the number the entered

	// Generating random number, then calculating frequencies and sorting, also calculating sum	
	mov	x23	0			// register to be used for storing largest number generated
	mov	x24	10			// register to be used for storing smallest number generated 
	
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
	b.gt	loop				// branches back to the beginning of our loop if random number is larger than 10. Does this till we generate a random number smaller than 10 
	cmp	x23	x22
	b.gt	greater
	cmp	x24	x22
	b.lt	smaller	
	ldr     x0,     =prnfmt6		// loads register x0 with address of string message to display to user. 
        mov     x1,     x22			// copies our random integer to register x1 to be printed t to the user
        bl      printf				//print to the user a random integer

        sub     x20,    x20,    1		// decrement x20 which is the counter for our while loop
	
test:						// the label name for our test we run  before the start of the loop. This tests if our counter x20 is equal to or smaller than 0, if not it branches back to the start of the loop. If so it ends the program.
        cmp     x20,    xzr			//compares our counter x20 to 0
        b.gt    loop				// checks if the value in our counter x20 is greater than 0 if it  is we branch back to the start of the loop
	b	end				// branch to the end function that restores fp and link registers

end:
	ldp	x29,	x30,	[sp], 16	// restore fp and link registers 
	ret

	// data section contains initialised global variables
	.data 		// in this section things can be written into as well as read
	entered_value:	.int	0		// scanf will store the number we asked the user to enter in this memory location		
