/* Routinen, um das NKC-LCD auf Adresse 0xAA und 0xAB anzusteuern */
/* ...work in progress... */

#define BYTE_AT(adr) (*(unsigned char volatile *) adr)

#define LCDCTRL BYTE_AT(0xFFFFFFAA) // Steuerport
#define LCDDATA BYTE_AT(0xFFFFFFAB) // Datenport



// Start
void _start(void)
{
    asm("pea main(%pc)\n\t");
}


#include "includes/gp_text.c"

// Print a string on GDP64.
void printString(const char *s)
{
    while (*s != 0)
    {
        GP_CO2(*s);
        s++;
    }
}

/* Warten bis LCD bereit ist */
void waitLcdReady(void)
{
    while (LCDCTRL & 0x80);
}

/* Initialisierung des LCD */
/* Genaue Beschreibung der Kommandos kommt spaeter */
void initLcd(void)
{
    char i;
    
    for (i=0; i<4; i++)
    {
            LCDCTRL = 0x38;
            waitLcdReady();
            LCDCTRL = 6;
            waitLcdReady();
            LCDCTRL = 0x0e;
            waitLcdReady();
            LCDCTRL = 1;
            waitLcdReady();
            LCDCTRL = 0x80;
            waitLcdReady();
    }
}

/* String auf LCD anzeigen */
/* Simpelste Methode - Cursorpositionierung usw. t.b.d. */
void printLcd(const char *s)
{
    while (*s != 0)
    {
        LCDDATA = *s;
        s++;
        waitLcdReady();
    }
}

/* Hauptroutine */
/* LCD initialisieren und "Hello World" anzeigen */
int main(void)
{
    /* LCD initialisieren und String ausgeben */
    initLcd();
    printLcd("Hello World!");
}
