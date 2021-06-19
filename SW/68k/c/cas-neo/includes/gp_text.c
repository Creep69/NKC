// CLEARSCREEN GP trap
void GP_CLEARSCREEN(void)
{
    asm("movem.l %d7/%a5-%a6,-(%sp)\n\t"
    "moveq #20,%d7\n\t"
    "trap #1\n\t"
    "movem.l (%sp)+,%d7/%a5-%a6\n\t");
}

// Print a character using the GP trap function.
void GP_CO2(char c)
{
    asm("movem.l %d7/%a5-%a6,-(%sp)\n\t"
    "move.b 19(%sp),%d0\n\t"
    "moveq #33,%d7\n\t"// CO2 trap function code
    "trap #1\n\t"// Call GP function
    "movem.l (%sp)+,%d7/%a5-%a6\n\t");
}

// CI
/*
char GP_CI(void)
{
    asm("movem.l %d7/%a5-%a6,-(%sp)\n\t"
    "moveq #12,%d7\n\t"
    "trap #1\n\t"
    "movem.l (%sp)+,%d7/%a5-%a6\n\t");
}
*/

char GP_CI(void)
{
    asm("movem.l %a0-%a6/%d1-%d7,-(%a7)\n\t\
        moveq #12,%d7\n\t\
        trap #1\n\t\
        movem.l (%a7)+,%a0-%a6/%d1-%d7\
    ");    
}
