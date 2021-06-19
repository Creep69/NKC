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
    char str[20];
    char* pStr=str;

    GP_CLEARSCREEN();
    printString("Eingabe:\r\n");
    while((c != '\r') && (pStr!=&str[19]))
    {
        c=GP_CI();
        *pStr++=c;
        GP_CO2(c);
    }
    *pStr=0;
    printString("\r\nDu hast\r\n");
    printString(str);
    printString("\r\neingegeben.\r\n");
}
