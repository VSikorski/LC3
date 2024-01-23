.ORIG x3000
MAIN
    AND R1 R1 #0
    AND R2 R2 #0
    AND R3 R3 #0
    AND R4 R4 #0
    AND R5 R5 #0
    AND R6 R6 #0

    JSR GET_INPUT_A
    JSR GET_INPUT_B

    NOT R3 R2
    ADD R3 R3 #1
    
    ADD R4 R1 R3
    BRz EQUAL
    BRp DESC
    BRn ASC
    
    DESC 
        DESC_LOOP
        
        ADD R6 R1 #0
        LD R0 PRINT_VAL_PTR
        JSRR R0
        
        LD R0 DET_PRIME_PTR 
        JSRR R0
        
        ; Right here I want the divisor in R5
        ; and the value 111 in R0 if it needs to be outputted
        LD R6 HUNDRED_ELEVEN_NEG
        ADD R0 R0 R6
        BRz PRINT_DIVISOR
        BRnp BYPASS_PRINT_DIVISOR
        
        PRINT_DIVISOR
        ADD R6 R5 #0
        LD R0 PRINT_VAL_PTR
        JSRR R0
        
        BYPASS_PRINT_DIVISOR
        
        LD R0 NEW_LINE
        OUT
        
        ADD R1 R1 #-1
        
        ADD R5 R1 R3
        BRzp DESC_LOOP

    BRnzp DONE_PRINT_VALUES
    
    ASC
        ASC_LOOP
        ADD R6 R1 #0
        LD R0 PRINT_VAL_PTR
        JSRR R0
        
        LD R0 DET_PRIME_PTR 
        JSRR R0
        
        LD R6 HUNDRED_ELEVEN_NEG
        ADD R0 R0 R6
        BRz PRINT_DIVISOR_ASC
        BRnp BYPASS_PRINT_DIVISOR_ASC
    
        PRINT_DIVISOR_ASC
        ADD R6 R5 #0
        LD R0 PRINT_VAL_PTR
        JSRR R0
        
        BYPASS_PRINT_DIVISOR_ASC
    
        LD R0 NEW_LINE
        OUT
        
        ADD R1 R1 #1
    
        ADD R5 R1 R3
        BRnz ASC_LOOP
        
    BRnzp DONE_PRINT_VALUES
    
    EQUAL
    
    ADD R6 R1 #0
    LD R0 PRINT_VAL_PTR
    JSRR R0
        
    LD R0 DET_PRIME_PTR 
    JSRR R0
    
    ; and the value 111 in R0 if it needs to be outputted
    LD R6 HUNDRED_ELEVEN_NEG
    ADD R0 R0 R6
    BRz PRINT_DIVISOR_EQ
    BRnp BYPASS_PRINT_DIVISOR_EQ
        
    PRINT_DIVISOR_EQ
    ADD R6 R5 #0
    LD R0 PRINT_VAL_PTR
    JSRR R0
        
    BYPASS_PRINT_DIVISOR_EQ
        
    LD R0 NEW_LINE
    OUT
    
    DONE_PRINT_VALUES
    
    HALT
    PRINT_VAL_PTR                       .FILL PRINT_VAL
    DET_PRIME_PTR                       .FILL DET_PRIME
END_MAIN

; R1 holds a (the n to verify), R2 holds b, R3 holds -R2, R6 is used to print the value
DET_PRIME
    ST R7 BACKUP_R7

    AND R5 R5 #0            ; holds the divisor
    ADD R5 R5 #1
    
    ADD R0 R1 #-3
    BRz DET_PRIME_IS_PRIME
    
    ADD R0 R1 #-2
    BRz DET_PRIME_IS_PRIME
    
    ADD R0 R1 #-1
    BRz DET_PRIME_IS_NOT_PRIME
    
    ; R1 % 2 == 0
    ADD R0 R1 #0
    ; R0 % 2 == 0
    ADD R5 R5 #1        ; R5 = 2
    DET_PRIME_MOD_LOOP
        ADD R0 R0 #-2
        BRp DET_PRIME_MOD_LOOP
        BRz DET_PRIME_IS_NOT_PRIME
    
    ADD R0 R1 #0
    ;loop
    AND R4 R4 #0 ; i
    ADD R4 R4 #1
    DET_PRIME_LOOP
        ADD R4 R4 #2 ; i += 2
        ADD R5 R4 #0 ; saving the i in R5
        ADD R0 R1 #0 ; R0 = R1
        ; if (R0 % R4 == 0) return 0;
        NOT R6 R4           ; R6 = - R4
        ADD R6 R6 #1
        DET_PRIME_LOOP_INNER
            ADD R0 R0 R6
            BRp DET_PRIME_LOOP_INNER
            BRz DET_PRIME_IS_NOT_PRIME
        ; R0 = i = R4 , VERIFIED
        ADD R0 R4 #0
        ; R6 = i*i
        AND R6 R6 #0
        DET_PRIME_LOOP_MULT
            ADD R6 R6 R4
            ADD R0 R0 #-1
            BRp DET_PRIME_LOOP_MULT
        ; R6 = i*i  , VERIFIED
        ; repeat while i*i <= x
        NOT R7 R1
        ADD R7 R7 #1
        ADD R7 R6 R7
        BRnz DET_PRIME_LOOP

    DET_PRIME_IS_PRIME
    LEA R0 PRIME_MSG
    PUTS
    BRnzp DONE_DET_PRIME
    
    DET_PRIME_IS_NOT_PRIME
    LEA R0 NOT_PRIME_MSG
    PUTS
    ; the value 111 in R0 if it needs to be outputted
    LD R0 HUNDRED_ELEVEN 

    DONE_DET_PRIME
    
    LD R7 BACKUP_R7
    RET
    PRIME_MSG                           .STRINGZ " is a prime number"
    NOT_PRIME_MSG                       .STRINGZ " is not a prime number as it is divisible by "
    HUNDRED_ELEVEN                      .FILL #111
    HUNDRED_ELEVEN_NEG                  .FILL #-111
    BACKUP_R7                           .FILL #0
END_DET_PRIME

PRINT_VAL
    ST R0 BACKUP_R0
    ST R1 BACKUP_R1
    ST R2 BACKUP_R2
    ST R3 BACKUP_R3
    ST R4 BACKUP_R4
    ST R5 BACKUP_R5
    ST R6 BACKUP_R6

    LD R0 TEN_THOUSANDS_NEG
    ADD R0 R6 R0
    BRzp FOUR_ZEROES
    
    LD R0 ONE_THOUSAND_NEG
    ADD R0 R6 R0
    BRzp THREE_ZEROES
    
    LD R0 ONE_HUNDRED_NEG
    ADD R0 R6 R0
    BRzp TWO_ZEROES
    
    LD R0 TEN_NEG
    ADD R0 R6 R0
    BRzp ONE_ZERO
    
    LD R0 ASCII_OFFSET 
    ADD R0 R6 R0
    OUT
    
    BRnzp DONE_PRINT_VAL
    
    ONE_ZERO
    AND R3 R3 #0
    ADD R4 R6 #0
        ONE_ZERO_LOOP
        ADD R3 R3 #1
        ADD R4 R4 #-10
        BRzp ONE_ZERO_LOOP
    ADD R3 R3 #-1
    ADD R4 R4 #10
    
    LD R6 ASCII_OFFSET
    ADD R0 R3 #0
    ADD R0 R0 R6
    OUT
    
    ADD R0 R4 #0
    ADD R0 R0 R6
    OUT
    
    BRnzp DONE_PRINT_VAL   
        
    TWO_ZEROES
    AND R3 R3 #0                ; clearing the R3
    ADD R4 R6 #0                ; copying R6 (input) into the R4
        TWO_ZEROES_LOOP
        ADD R3 R3 #1            ; full points increase
        LD R0 ONE_HUNDRED_NEG
        ADD R4 R4 R0            ; remainder -100
        BRzp TWO_ZEROES_LOOP
    ADD R3 R3 #-1
    LD R0 ONE_HUNDRED
    ADD R4 R4 R0
    
    LD R6 ASCII_OFFSET
    ADD R0 R3 #0
    ADD R0 R0 R6
    OUT
    
    ADD R6 R4 #0
    BRnzp ONE_ZERO
    
    THREE_ZEROES
    
    AND R3 R3 #0                ; clearing the R3
    ADD R4 R6 #0                ; copying R6 (input) into the R4
        THREE_ZEROES_LOOP
        ADD R3 R3 #1            ; full points increase
        LD R0 ONE_THOUSAND_NEG
        ADD R4 R4 R0            ; remainder -1000
        BRzp THREE_ZEROES_LOOP
    ADD R3 R3 #-1
    LD R0 ONE_THOUSAND
    ADD R4 R4 R0
    
    LD R6 ASCII_OFFSET
    ADD R0 R3 #0
    ADD R0 R0 R6
    OUT
    
    ADD R6 R4 #0
    BRnzp TWO_ZEROES
    
    FOUR_ZEROES
    
    DONE_PRINT_VAL
    
    LD R0 BACKUP_R0
    LD R1 BACKUP_R1
    LD R2 BACKUP_R2
    LD R3 BACKUP_R3
    LD R4 BACKUP_R4
    LD R5 BACKUP_R5
    LD R6 BACKUP_R6
    
    RET
    BACKUP_R0                   .FILL #0
    BACKUP_R1                   .FILL #0
    BACKUP_R2                   .FILL #0
    BACKUP_R3                   .FILL #0
    BACKUP_R4                   .FILL #0
    BACKUP_R5                   .FILL #0
    BACKUP_R6                   .FILL #0
    
    TEN_THOUSANDS_NEG           .FILL #-10000
    ONE_THOUSAND_NEG            .FILL #-1000
    ONE_THOUSAND                .FILL #1000
    ONE_HUNDRED_NEG             .FILL #-100
    ONE_HUNDRED                 .FILL #100
    TEN_NEG                     .FILL #-10
    
    SPACE                       .FILL #32
    NEW_LINE                    .FILL #10
END_PRINT_VAL

GET_INPUT_A
    READ_A
    GETC
    OUT
    
    LD R6 SPACE_NEG
    ADD R6 R0 R6
    BRz DONE_GET_INPUT_A
    
    LD R6 ASCII_OFFSET_NEG
    ADD R0 R0 R6
    
    ADD R6 R1 #0
    BRz READ_A_ADD_VAL
    BRnp READ_A_LOOP
    
    READ_A_ADD_VAL
    ADD R1 R0 #0
    BRnzp READ_A
    
    READ_A_LOOP
    AND R5 R5 #0
    AND R6 R6 #0
    ADD R6 R6 #10
        READ_A_LOOP_INNER
        ADD R5 R5 R1
        ADD R6 R6 #-1
        BRp READ_A_LOOP_INNER
    ADD R1 R5 R0
    BRnzp READ_A
    
    DONE_GET_INPUT_A
    
    RET
    SPACE_NEG               .FILL #-32
    NEW_LINE_NEG            .FILL #-10
    ASCII_OFFSET_NEG        .FILL #-48
    ASCII_OFFSET            .FILL #48
END_GET_INPUT_A

GET_INPUT_B
    READ_B
    GETC
    OUT
    
    LD R6 NEW_LINE_NEG
    ADD R6 R0 R6
    BRz DONE_GET_INPUT_B
    
    LD R6 ASCII_OFFSET_NEG
    ADD R0 R0 R6
    
    ADD R6 R2 #0
    BRz READ_B_ADD_VAL
    BRnp READ_B_LOOP
    
    READ_B_ADD_VAL
    ADD R2 R0 #0
    BRnzp READ_B
    
    READ_B_LOOP
    AND R5 R5 #0
    AND R6 R6 #0
    ADD R6 R6 #10
        READ_B_LOOP_INNER
        ADD R5 R5 R2
        ADD R6 R6 #-1
        BRp READ_B_LOOP_INNER
    ADD R2 R5 R0
    BRnzp READ_B
    
    DONE_GET_INPUT_B
    
    RET
END_GET_INPUT_B

.END
