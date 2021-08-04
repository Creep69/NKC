/* Routinen, um die SOUND3 auf Adresse 0x50 und 0x51 anzusteuern */
/* ...work in progress... */

#define BYTE_AT(adr) (*(unsigned char volatile *) adr)

#define SNDCTRL BYTE_AT(0xFFFFFF50) // Steuerport
#define SNDDATA BYTE_AT(0xFFFFFF51) // Datenport



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


/* Hauptroutine */
/* Nacheinander Ton auf Kanal A, B, C und B+C der SOUND3 ausgeben */
int main(void)
{
    char c;

    // Kanal A initialisieren
    SNDCTRL = 0;            // Adresse Tonperiode LSB Kanal A
    SNDDATA = 0x55;         // LSB Wert Tonperiode
    SNDCTRL = 1;            // Adresse Tonperiode MSB Kanal A
    SNDDATA = 0;            // MSB Wert Tonperiode
    SNDCTRL = 8;            // Amplitude Kanal A
    SNDDATA = 15;           // Maximum

    // Kanal B initialisieren
    SNDCTRL = 2;            // Adresse Tonperiode LSB Kanal B
    SNDDATA = 0x45;         // LSB Wert Tonperiode
    SNDCTRL = 3;            // Adresse Tonperiode MSB Kanal B
    SNDDATA = 0;            // MSB Wert Tonperiode
    SNDCTRL = 9;            // Amplitude Kanal B
    SNDDATA = 15;           // Maximum

    // Kanal C initialisieren
    SNDCTRL = 4;            // Adresse Tonperiode LSB Kanal C
    SNDDATA = 0x35;         // LSB Wert Tonperiode
    SNDCTRL = 5;            // Adresse Tonperiode MSB Kanal C
    SNDDATA = 0;            // MSB Wert Tonperiode
    SNDCTRL = 10;           // Amplitude Kanal C
    SNDDATA = 15;           // Maximum

    printString("Ton auf Kanal A\r\n");

    SNDCTRL = 7;            // Adresse Freigabekanal
    SNDDATA = 0b11111110;   // Kanal A

    printString("Taste druecken...\r\n");
    c = GP_CI();

    printString("Ton auf Kanal B\r\n");

    SNDCTRL = 7;            // Adresse Freigabekanal
    SNDDATA = 0b11111101;   // Kanal B

    printString("Taste druecken...\r\n");
    c = GP_CI();

    printString("Ton auf Kanal C\r\n");

    SNDCTRL = 7;            // Adresse Freigabekanal
    SNDDATA = 0b11111011;   // Kanal C

    printString("Taste druecken...\r\n");
    c = GP_CI();

    printString("Ton auf Kanal B + C\r\n");

    SNDCTRL = 7;            // Adresse Freigabekanal
    SNDDATA = 0b11111001;   // Kanal B + C

    printString("Taste druecken...\r\n");
    c = GP_CI();

    printString("Ton aus\r\n");

    SNDCTRL = 7;            // Adresse Freigabekanal
    SNDDATA = 0b11111111;   // kein Kanal
}
