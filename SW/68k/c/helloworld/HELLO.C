// Start
void _start(void)
{
    asm("pea main(%pc)\n\t");
}


#include "includes/gp_text.c"

// Print a string.
void printString(const char *s)
{
    while (*s != 0)
    {
        GP_CO2(*s);
        s++;
    }
}


int main(void)
{   char c=0;

    GP_CLEARSCREEN();
    printString("Hello World!\r\n");
}
