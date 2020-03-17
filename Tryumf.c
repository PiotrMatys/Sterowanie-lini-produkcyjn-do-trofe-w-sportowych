/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2016-11-18
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <io.h>

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
unsigned char status;
char data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      }
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-


#include <stdio.h>
#include <mega128.h>
#include <delay.h>
//#include <alcd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

int skonczony_proces[10];
int proces[10];
int monter_1_skonczyl,monter_2_skonczyl,monter_3_skonczyl,monterzy_skonczyli;
int start;
int licznik_pucharow;
int licznik;
int jest_pret_pod_czujnikami;
int czas_silnika_dokrecajacego_grzybki, czas_silnika_dokrecajacego_grzybki_stala;
int il_pretow_gwintowanych;
int dlugosc_preta_gwintowanego;
long int sek0,sek1,sek2,sek3;
long int sek0_7s,sek1_7s,sek2_7s,sek3_7s;
long int czas_monterow,czas_na_transport_preta;
long int monter_1_time, monter_2_time, monter_3_time;
long int stala_czasowa;
int licznik_spoznien_monter_1,licznik_spoznien_monter_2, licznik_spoznien_monter_3;
int licznik_spoznien_monter_1_2, licznik_spoznien_monter_3_nowy;
int d,dd,gg,klej,klej_slave,monter_slave;
//char *dupa1;
//int i,ff;
int ff;
char z;
int grzybek;
int il_grzybkow,kontrola_grzybkow;
int licz;
int grzybek_biezacy_dokrecony;
int grzybek_dokrecony;
int oproznij_podajnik;
int metalowe_grzybki;
int zajechalem,sekwencja;
int pierwszy_raz;
int czas_monterow_stala;
int il_pretow_gwintowanych_stala;
int oczekiwanie_na_poprawienie;
int potw_zielonym_bo_pomyliles_pedal_z_potwierdz;
int czekaj_komunikat;
int przejechalem_czujnik_lub_jestem_na_nim;
int licznik_niezakreconych_grzybkow;
int grzybek_jest_nakrecony_na_precie;
int licznik_wylatujacych_grzybkow;
int licznik_wyzwolen_kurtyny;
int licznik_pucharow_global;
long int czas_zaloczonego_orientatora;
int zaloczono_kurtyne;
int anuluj_biezace_zlecenie;
int licznik_niewlozonych_pretow_z_grzybkiem;
int anuluj_biezace_zlecenie_const;
int msek_clock;
int sek_clock, min_clock, godz_clock;
int przez_sek_clock, przez_min_clock, przez_godz_clock;

int tryb_male_puchary;
int predkosc_wiezyczek_male_puchary;
int wynik_wyboru_male_puchary;
int wielkosc_kamienia;



//int dupcia;
//int wynik;
//int wynik1;
//int oleole;


void sterowanie_tasmociagami_monterow()
{
/*

if(PINF.0 == 0)
    PORTD.7 = 1;
else                //tasma 1
    PORTD.7 = 0;

if(PINF.1 == 0)
    PORTD.6 = 1;
else                //tasma 2
    PORTD.6 = 0;

*/
}

void zerowanie_czasu()
{
msek_clock = 0;
sek_clock = 0;
min_clock = 0;
godz_clock = 0;
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
sek0++;
sek1++;
sek2++;
sek3++;

msek_clock++;
if(msek_clock == 60)
     {
     msek_clock = 0;
     sek_clock++;
     if(sek_clock == 60)
        {
        sek_clock = 0;
        min_clock++;
        if(min_clock == 60)
            {
            min_clock = 0;
            godz_clock++;
            }         
        }   
     }

//16 mhz = 
//co 1/16000s wykonywana jest operacja
//co 1/15,625 whodzi tam
//co 1024 jest 1s





//sek0_7s++;

//sek1_7s++;

//sek2_7s++;

//sek3_7s++;
//if(z == 1)
//    {
//    monter_1_time++;
//    monter_2_time++;
//    monter_3_time++;
//    }
//if(start == 0)
    //sterowanie_tasmociagami_monterow();
}



void orientator_grzybkow()
{

if(PINA.1 == 1)
    {
    PORTD.4 = 1;
    //if(grzybek == 0)
    //   {
    //   il_grzybkow++;
    //   grzybek = 1;
    //   
    }
if(PORTD.4 == 1 & PINA.1 == 0)
    czas_zaloczonego_orientatora++;    
    
if(PINA.1 == 0 & czas_zaloczonego_orientatora > 100000) //zmieniam z 10000
    {
    czas_zaloczonego_orientatora = 0;
    PORTD.4 = 0;
    grzybek = 0;
    }


}

int kontrola_grzyb()
{
int k;

/*
if(il_grzybkow < 7)
    k = 0;
else
    k = 1;
if(il_grzybkow >= 7 | PINA.1 == 0)
    k = 1;

*/

k = 1; //na pewno beda grzybki


return k;
}


void inicjalizacja_orientator_grzybkow()
{
int g;
g = 0;


while(PINA.1 == 1)
   PORTD.4 = 1;
delay_ms(2000);
PORTD.4 = 0;

while(g<20)
    {
    if(PINA.1 == 1)
        {
        while(PINA.1 == 1)
            PORTD.4 = 1;
        delay_ms(2000);
        PORTD.4 = 0;
        }
    g++;
    }


 
il_grzybkow = 20;
}


void wylacz_maszyne()
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(0);    //00
putchar(48);   //adres zmiennej 30
putchar(0);    //00
putchar(0);   //0
}

int czekaj_na_guzik_start()
{
z = 0;
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(48);  //adres zmiennej - 30
putchar(1);
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
z = getchar();
//itoa(z,dupa1);       
//lcd_puts(dupa1);

return z;
}


void ustaw_na_nie_anulacje_zlecenia()
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //zmienie na anulowanie zlecenia
putchar(0);    //00
putchar(96);   //60
putchar(0);    //00
putchar(1);   //1
}

void kontrola_lampki_brak_pretow()
{
if(PINA.6 == 0)
    PORTD.7 = 0;
else
    PORTD.7 = 1;
}

int wyczysc_grzebienie()
{
int wynik;
wynik = 0;

switch(proces[1])
    {
    case 0:
        sek1_7s = 0;
        sek1 = 0;
        proces[1] = 1;    
    break;
    
    case 1:
            if(sek1 > 100)
                {
                if(PINA.4 == 0)
                    {
                    PORTB.7 = 0;  //zakoncz dociskanie preta
                    PORTD.0 = 1; //rozpcznij przeniesienie pret do nakladania kleju
                    }
                else
                    {
                    PORTD.0 = 1; //czujnik juz nie swieci, czyli jade dalej
                    sek1 = 0;
                    proces[1] = 2;
                    }
                } 
    break;
    case 2:
            if(PINA.4 == 0)  //dojechalem znowu do czujnika
                {
                PORTD.0 = 0; //wylacz silnik
                proces[1] = 3;
                }
    break;
                       
    case 3:
                sek1 = 0;
                proces[1] = 0;
                wynik = 1;                                
    break;
    }

return wynik;
}

void wydaj_dzwiek()
{
licz++;
if(licz >= 100);
    {
    licz = 0;
    putchar(90);  //5A
    putchar(165); //A5
    putchar(3);//03
    putchar(128);  //80    //dzwiek
    putchar(2);    //02
    putchar(16);   //10
    }
}




void komunikat_1_na_panel()
{
putchar(90);
putchar(165);
putchar(35);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("                                        ");

putchar(90);
putchar(165);
putchar(23);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Inicjalizuje maszyne");
}

void komunikat_2_na_panel()
{
putchar(90);
putchar(165);
putchar(23);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Wyczyszczono maszyne");
}

void komunikat_3_na_panel()
{
putchar(90);
putchar(165);
putchar(27);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Maszyna zainicjalizowana");
}

void komunikat_4_na_panel()
{
putchar(90);
putchar(165);
putchar(28);       //ilosc liter 25 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Czekam na pret gwintowany");
}

void komunikat_5_na_panel()
{
putchar(90);
putchar(165);
putchar(35);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("                                        ");

putchar(90);
putchar(165);
putchar(8);       //ilosc liter 5 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Praca");
}

void komunikat_6_na_panel()
{
putchar(90);
putchar(165);
putchar(27);       //ilosc liter 24 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("                        ");

putchar(90);
putchar(165);
putchar(38);       //ilosc liter 35 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Zakrecilem wszystkie zadane puchary");
}

void komunikat_7_na_panel()
{
putchar(90);
putchar(165);
putchar(34);       //ilosc liter 31 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Brak wymaganego cisnienia 6 bar");
}

void komunikat_8_na_panel(int i)
{
if(i == 0)
    {
    putchar(90);
    putchar(165);
    putchar(35);       //ilosc liter 32 + 3
    putchar(130);  //82
    putchar(0);    //0
    putchar(144);  //adres 70 - 112
    printf("Dozownik kleju pretow nie gotowy");
    }
if(i == 1)
    {
    putchar(90);
    putchar(165);
    putchar(37);       //ilosc liter 34 + 3
    putchar(130);  //82
    putchar(0);    //0
    putchar(144);  //adres 90 - 144
    printf("Dozownik kleju nakretek nie gotowy");
    }
}

void komunikat_9_na_panel()
{
putchar(90);
putchar(165);                    
putchar(37);       //ilosc liter 34 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Wylacz maszyne i poczekaj 1 minute");
}

void komunikat_10_na_panel()
{
putchar(90);
putchar(165);                    
putchar(28);       //ilosc liter 25 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Odslon i zresetuj kurtyne");
}

void komunikat_11_na_panel()
{
putchar(90);
putchar(165);                    
putchar(31);       //ilosc liter 28 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Monter 3 nie nacisnal pedala");
}

void komunikat_12_na_panel()
{
putchar(90);
putchar(165);                    
putchar(26);       //ilosc liter 23 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Czekam na ruch lancucha");
}

void komunikat_14_na_panel()
{
putchar(90);
putchar(165);                    
putchar(43);       //ilosc liter 40 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Popraw pret z grzybkiem i nacisnij guzik");
}

void komunikat_13_na_panel()
{
putchar(90);
putchar(165);                    
putchar(39);       //ilosc liter 36 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Usun pret ze szczek i nacisnij guzik");
}

void komunikat_15_na_panel()
{
putchar(90);
putchar(165);                    
putchar(52);       //ilosc liter 42 + 3  //49+3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Wymien lub nakrec/dokrec grzybek i nacisnij guzik");
}

void komunikat_16_na_panel()
{
putchar(90);
putchar(165);                    
putchar(42);       //ilosc liter 39 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Monter 3 - zdemontuj puchar i potwierdz");
}

void komunikat_17_na_panel()
{
putchar(90);
putchar(165);                    
putchar(44);       //ilosc liter 41 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("Monter 3 - wyzwol recznie czujnik puchara");  //41
}


void komunikat_18_na_panel()
{
putchar(90);
putchar(165);                    
putchar(41);       //ilosc liter 38 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("SLAVE nie potwierdzil podania nakretki");  //41
}

void komunikat_19_na_panel()
{
putchar(90);
putchar(165);                    
putchar(46);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 144
printf("SLAVE nie potwierdzil zezwolenia na szczeki");  //43
}

void komunikat_czysc_na_panel()
{
putchar(90);
putchar(165);
putchar(53); //38      //ilosc liter 50 + 3 //TU ZMIENIAM NORMALNIE SIE DODAJE??
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("                                                  ");
}

void przeslij_parametry_do_slave(char pomocnicza,char numer)
{                                                

int spr;

PORTE.7 = 1;//do komunikacji �adanie
putchar1(numer);  
putchar1(pomocnicza);
spr = getchar1();
if(spr == 3)
    PORTE.7 = 0;//do komunikacji koniec �adania
else
    {
    if(numer == 3)
        komunikat_18_na_panel();  //nie potwierdzil podania nakretki
    if(numer == 5)
        komunikat_19_na_panel();  //nie potwierdzil zezwolenia na szczeki
    PORTE.7 = 0;//do komunikacji koniec �adania    
    }
}


void odpytaj_parametry_z_panelu(int k)
{
char pomocnicza;
int hh;
int oleole;
oleole = 0;
z = 0;
pomocnicza = 0;

if(k == 1)
{
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(64);  //adres zmiennej - 40
putchar(1);   //dlugosc preta gwintowanego
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
dlugosc_preta_gwintowanego = getchar();
if(dlugosc_preta_gwintowanego == 60)
    dlugosc_preta_gwintowanego = 61;

putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(16);
putchar(16);  //adres zmiennej - 1010
putchar(1);   //czy metalowe grzybki
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
hh = getchar();
if(hh == 0)
    metalowe_grzybki = 1;
else
    metalowe_grzybki = 0;

putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(16);
putchar(32);  //adres zmiennej - 1020
putchar(1);   //czy oproznic podajnik grzybkow
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
hh = getchar();
if(hh == 0)
    oproznij_podajnik = 1;
else
    oproznij_podajnik = 0;
}

putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(80);  //adres zmiennej - 50
putchar(1);   //czas po jakim wylaczony silnik
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
czas_silnika_dokrecajacego_grzybki = getchar();

if(k == 1 | (k == 0 & il_pretow_gwintowanych > 4))
{
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(96);  //adres zmiennej - 60
putchar(1);     //odczyt czy anulowac zlecenie
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
hh = getchar();

if(hh == 0)
    anuluj_biezace_zlecenie = 1;
else
    anuluj_biezace_zlecenie = 0;



//czas_monterow = (long int)pomocnicza * stala_czasowa; 
czas_monterow = 7 * stala_czasowa;
}

if(pierwszy_raz == 0) 
    {
    //przeslij_parametry_do_slave(pomocnicza, 2);
    pierwszy_raz = 1;
    czas_monterow_stala = czas_monterow;
    }

if(czas_monterow_stala != czas_monterow)
   pierwszy_raz = 0; 

if(start == 0 & k == 1)
    {
    putchar(90);
    putchar(165);
    putchar(4);
    putchar(131);
    putchar(0);
    putchar(112);  //adres zmiennej - 70
    putchar(1);     //odczyt ilosci pucharow do zmontowania
    getchar();
    getchar();
    getchar();
    getchar();
    getchar();
    getchar();
    getchar();
    oleole = getchar();
    il_pretow_gwintowanych = getchar();
    
    if(oleole > 0)
        il_pretow_gwintowanych = oleole * 255 + il_pretow_gwintowanych + oleole;

    
    
    il_pretow_gwintowanych_stala = il_pretow_gwintowanych;
    }


if(k == 1)
{
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(32);
putchar(48);  //adres zmiennej - 2030
putchar(1);   
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
hh = getchar();
if(hh == 0)
    tryb_male_puchary = 1;
else
   tryb_male_puchary = 0;
}


putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(32);
putchar(64);  //adres zmiennej - 2040
putchar(1);   
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
predkosc_wiezyczek_male_puchary = getchar();



putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(32);
putchar(80);  //adres zmiennej - 2050
putchar(1);   
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
wielkosc_kamienia = getchar();


if(tryb_male_puchary == 0)
     wynik_wyboru_male_puchary = 3;
else
    {
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 50)
       wynik_wyboru_male_puchary = 17;
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 55)
       wynik_wyboru_male_puchary = 18;
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 60)
       wynik_wyboru_male_puchary = 19;
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 65)
       wynik_wyboru_male_puchary = 20;   
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 70)
       wynik_wyboru_male_puchary = 21;   
    if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 75)
       wynik_wyboru_male_puchary = 22;   
    
    
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 50)
          wynik_wyboru_male_puchary = 11;
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 55)
          wynik_wyboru_male_puchary = 12;
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 60)
          wynik_wyboru_male_puchary = 13;
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 65)
          wynik_wyboru_male_puchary = 14;
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 70)
          wynik_wyboru_male_puchary = 15;
    if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 75)
          wynik_wyboru_male_puchary = 16;
           
    }



}

void wartosci_wstepne_panelu()
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //dlugosc preta gwintowanego
putchar(0);    //00
putchar(64);   //40
putchar(0);    //00
putchar(dlugosc_preta_gwintowanego);   //80

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //czas po jakim wylaczamy silnik
putchar(0);    //00
putchar(80);   //50
putchar(0);    //00
putchar(czas_silnika_dokrecajacego_grzybki);   

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //zmienie na anulowanie zlecenia
putchar(0);    //00
putchar(96);   //60
putchar(0);    //00
putchar(1);   //1

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //ilosc pucharow do zmontowania
putchar(0);    //00
putchar(112);   //70
putchar(0);    //00
putchar(5);   //5

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05                              0-tak
putchar(130);  //82    /Czy grzybki metalowe 1-nie
putchar(16);    //10
putchar(16);   //10
putchar(0);    //00
putchar(1);   //1

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05                              0-tak
putchar(130);  //82    /Czy oproznic podajnik grzybkow 1-nie
putchar(16);    //10
putchar(32);   //80
putchar(0);    //00
putchar(1);   //1

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05                              0-tak
putchar(130);  //82    /Czy tryb kontynuacji 1-nie
putchar(16);    //10
putchar(128);   //80
putchar(0);    //00
putchar(1);   //1

//tu obrabiam tryb male puchary pod adresem 2030

putchar(90);
putchar(165);
putchar(5);        
putchar(130);  //82
putchar(32);    //20
putchar(48);  //adres 30
putchar(0);    //00
putchar(1);   //1          Czy tryb male puchary 1-nie 0-tak


//tu obrabiam predkosc wiezyczek male puchary           

putchar(90);
putchar(165);
putchar(5);        
putchar(130);  //82
putchar(32);    //20
putchar(64);  //adres 40
putchar(0);    //00
putchar(2);   //1          predkosc wiezyczek male puchary 2-maks 1-min

//tu obrabiam wielkosc kamienia male puchary           

putchar(90);
putchar(165);
putchar(5);        
putchar(130);  //82
putchar(32);    //20
putchar(80);  //adres 50
putchar(0);    //00
putchar(50);   //   //50 55 60 65 70 75  



}


void wyswietl_ilosc_zmontowanych_pucharow(int i,int j)
{
int gg,hh;

if(i>255)
    {
    gg = i/255;
    hh = i%255;
    }
else
    {
    gg = 0;
    hh = 0;
    }
    
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(0);    //00
putchar(128);   //80
putchar(gg);    //00
if(i>255)
    putchar(gg*255+hh);   //7
else
    if(i>=0)
        putchar(i);
    else
        putchar(0);
    
    
if(j>255)
    {
    gg = j/255;
    hh = j%255;
    }
else
    {
    gg = 0;
    hh = 0;
    }

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(16);    //10      
putchar(64);   //40
putchar(gg);    //00
if(j>255)
    putchar(gg*255+hh);
else
    putchar(j);   //7  //j na razie bo mam problem z 255
}

void wyswietl_czas_procesu()
{
putchar(90);
putchar(165);
putchar(11);       //ilosc liter 8+3 
putchar(130);  //82
putchar(32);    //20
putchar(16);  //adres 10

if(sek_clock < 10)
    printf("0%d",sek_clock);
else
    printf("%d",sek_clock);
printf(":");

if(min_clock < 10)
    printf("0%d",min_clock);
else
    printf("%d",min_clock);
printf(":");

if(godz_clock < 10)
    printf("0%d",godz_clock);
else
    printf("%d",godz_clock);
}


void wyswietl_czas_przezbrojenia()
{
putchar(90);
putchar(165);
putchar(11);       //ilosc liter 8+3 
putchar(130);  //82
putchar(32);    //20
putchar(00);  //adres 10

if(sek_clock < 10)
    printf("0%d",sek_clock);
else
    printf("%d",sek_clock);
printf(":");

if(min_clock < 10)
    printf("0%d",min_clock);
else
    printf("%d",min_clock);
printf(":");

if(godz_clock < 10)
    printf("0%d",godz_clock);
else
    printf("%d",godz_clock);

}

void wyswietl_czas_laczny_przezbrajan()
{
putchar(90);
putchar(165);
putchar(11);       //ilosc liter 8+3 
putchar(130);  //82
putchar(16);    //10
putchar(144);  //adres 90

przez_sek_clock = przez_sek_clock + sek_clock;
if(przez_sek_clock > 60)
    {
    przez_sek_clock = przez_sek_clock - 60;
    przez_min_clock++;
    }
     
przez_min_clock = przez_min_clock + min_clock;
if(przez_min_clock > 60)
    {
    przez_min_clock = przez_min_clock - 60;
    przez_godz_clock++;
    }

przez_godz_clock = przez_godz_clock + godz_clock; 
if(przez_godz_clock > 60)
    {
    przez_godz_clock = przez_godz_clock - 60;
    przez_godz_clock = 0;
    }



if(przez_sek_clock < 10)
    printf("0%d",przez_sek_clock);
else
    printf("%d",przez_sek_clock);
printf(":");

if(przez_min_clock < 10)
    printf("0%d",przez_min_clock);
else
    printf("%d",przez_min_clock);
printf(":");

if(przez_godz_clock < 10)
    printf("0%d",przez_godz_clock);
else
    printf("%d",przez_godz_clock);
}

void wyswietl_parametry(int i,int j,int k,int l, int m, int n)
{
int gg,hh;

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(0);    //00
putchar(16);   //10
putchar(0);    //00
//if(i>=0)
    putchar(i);   //
//else
//    putchar(i);
    
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(0);    //00
putchar(32);   //20
putchar(0);    //00
//if(j>=0)
    putchar(j);   //
//else
//    putchar(0);

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(16);    //10
putchar(48);   //30
putchar(0);    //00
putchar(k);   //7

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(16);    //10   //ilosc niewlozonych pretow z grzybkami do wiezy, czyli raczej krzywa wieza
putchar(80);   //50
putchar(0);    //00
putchar(l);   //7



if(m>255)
    {
    gg = m/255;
    hh = m%255;
    }
else
    {
    gg = 0;
    hh = 0;
    }


putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(16);    //10   //liczba spozniem monter 1 i 2
putchar(96);   //60    
putchar(gg);    //00
if(m>255)
    putchar(gg*255+hh);   //7
else
    if(m>=0)
        putchar(m);
    else
        putchar(0);


if(n>255)
    {
    gg = n/255;
    hh = n%255;
    }
else
    {
    gg = 0;
    hh = 0;
    }

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    
putchar(16);    //10   //liczba spoznien monter 3
putchar(112);   //70
putchar(gg);    //00

if(n>255)
    putchar(gg*255+hh);   //7
else
    if(n>=0)
        putchar(n);
    else
        putchar(0);

}



void obsluga_startowa_dozownika_kleju()
{
PORTD.5 = 1;  //zasilanie 220V na dozownik kleju
//PORTC.0 = 1;  //cisnienie na dozownik kleju

/*
while(PINA.6 == 1)
  {
  komunikat_8_na_panel(0); //dozownik kleju nie gotowy
  delay_ms(1000);
  }
*/
}

void obsluga_startowa_dozownika_kleju_slave()
{
int spr;
spr = 0;

PORTE.7 = 1;
delay_ms(100);
spr = getchar1();
if(spr == 0)   //jak na poczatku podal 0 to jeszcze raz getchar
    {
    komunikat_8_na_panel(1);
    getchar1();  //tu utyka i czeka az ok z dozownikiem            //wtedy ten getchar puszcza
    }
PORTE.7 = 0;  //koniec komunikacji

}

int pusc_pierwszego_preta()
{
int wynik;
wynik = 0;

//PORTC.5   si�ownik 3 kolejkuj�cy na rynnie
//PORTC.6   si�ownik 2 kolejkuj�cy na rynnie  //na pewno podupcona kolejno��
//PORTC.7   si�ownik 1 kolejkuj�cy na rynnie

switch(proces[0])
    {
    case 0:
        proces[0] = 1;
    break;
    
    case 1:       
                
        sek0_7s = 0;
        sek0 = 0;       
        proces[0] = 4;
    
    break;
        
    case 4:
            if(sek0 > 100)
                {
                PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
                sek0 = 0;
                proces[0] = 5;
                } 
    break;
    
    case 5:
            if(sek0 > 100)
                {
                PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
                sek0 = 0;
                proces[0] = 6;
                }
    
    break; 
    
    
    case 6:
            if(sek0 > 100)
                {
                PORTC.5 = 1; //silownik 3 w gore
                sek0 = 0;
                proces[0] = 7;
                } 
    break;
    
    case 7:
            if(sek0 > 100)
                {
                PORTC.5 = 0; //silownik 3 w dol
                sek0 = 0;
                proces[0] = 8;
                } 
    break;
    
    case 8:
            if(sek0 > 100)
               proces[0] = 9; 
    break;
    
    case 9:
                   
         sek0 = 0;
         proces[0] = 0;
         wynik = 1;               
                                    
    break;
    }

return wynik;
}


void wyczysc_maszyne_z_pretow_gwintowanych()
{
int i;
i=0;


while(i == 0)
    i = wyczysc_grzebienie();  //przenies raz grzebienie
i = 0;
while(i == 0)
    i = pusc_pierwszego_preta();
i = 0;
while(i == 0)
    i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym jest pod klejem
i = 0;
while(i == 0)
    i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym jest pod zakrecaniem
i = 0;

while(i == 0)
    i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym spada

//dorzucic czujnika indukcyjnego do tej �apki, kt�ra chwyta
//czyli maszyna ma si� nie uruchomi� dopoki ktos nie wyczyscil tych precikow
//JEZELI SA PRETY TO KOMUNIKAT - ZABIERZ PRETY

//po tym sprawdzeniu nastepuje komunikat:
//WYCZYSZCZONO MASZYNE
komunikat_2_na_panel();

}


int obsluga_startowa_tasmy_lancuchowej()
{
//int zaloczono_kurtyne;
//zaloczono_kurtyne = 0;

//PINF.6    czujnik ze jedzie lancuchowy
//0 - jedzie
//1 - stoi

//PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
            //jak monterzy zresetuja to sama mi sie pojawi 1


//uproszczona obsluga
//PORTE.5   sekwencja startowa pivexin
//PORTE.6   manipulator wykonal pivexin
//if(PINF.7 == 1)
//            {
//            zw = 99;
//            wydaj_dzwiek();


//PORTE.5 = 1;
//delay_ms(300);
//PORTE.5 = 0;
//delay_ms(300);
//PORTE.6 = 1;
//delay_ms(300);
//PORTE.6 = 0;
 
switch(PINF.7)
    {
case 0:  //zmieniam 28.06 bylo 0
        switch(sekwencja)       
           {
           case 0:
                    komunikat_czysc_na_panel();
                    zaloczono_kurtyne = 0;
                    PORTE.5 = 1;
                    delay_ms(400);  //delay_ms(400);
                    sekwencja = 1;
           break;
           case 1:
                    PORTE.5 = 0;
                    delay_ms(400);
                    sekwencja = 2;          
           break;
           
           case 2:
                    PORTE.6 = 1;
                    if(PINF.6 == 0)  //ze jedzie
                        {
                        komunikat_czysc_na_panel();
                        sekwencja = 3;
                        PORTE.6 = 0;
                        }
                    else
                        {
                        komunikat_12_na_panel();    
                        //delay_ms(100);
                        }
           break;
           
           case 3:   
                    if(PINF.6 == 1)  //ze stoi
                    {
                    komunikat_czysc_na_panel();
                    if(zajechalem == 2)
                        zajechalem = 3;
                    if(zajechalem == 0)
                        zajechalem = 2;
                    sekwencja = 4;
                    }
           break;
           
           case 4:
                    
                    if(zajechalem == 2)
                        {
                        delay_ms(400);
                        sekwencja = 2;
                        }
                    else
                        {    
                        zajechalem = 1;
                        sekwencja = 0;
                        }                              
           break;
           }

 
break;

case 1: //zmieniam 28.06 bylo 1
        komunikat_10_na_panel();
        PORTE.5 = 0;
        PORTE.6 = 0;
        zajechalem = 0;
        sekwencja = 0;
        if(zaloczono_kurtyne == 0)
            {
            zaloczono_kurtyne = 1;
            licznik_wyzwolen_kurtyny++;
            }
        wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
        delay_ms(1000);        
break;
    }

return zajechalem; 
}


void przenies_pret_gwintowany()
{
int zwrot;
int liczenie;
int rozpoczalem_ruch_preta;
int zwloka_czasowa;
long int time,time1;
//int zaloczono_kurtyne;

//zaloczono_kurtyne = 0;

liczenie = 0;
rozpoczalem_ruch_preta = 0;
licz = 0;
time = 0;
time1 = 0;
zwrot = 1;  //wylaczam to na razie bo testuje czekam na ruch lanucha 27.06
//zwrot = 5;   //do testu czekam na ruch lanuchya
sekwencja = 0;
zwloka_czasowa = 0;


      //wylaczam to na razie bo testuje czekam na ruch lanucha 27.06


if(start >=8)
    //zw = 99;   //na razie do testow
    //zw = 1;
    sekwencja = 0;  
else
    sekwencja = 5;
    //zw = 0;


  


//to ponizej dziala na pewno ale kombinuje z kurtyna 22.03.2017

//while(zwrot == 1 | zwrot == 2 | zw == 1 | zw == 2 | zw == 3 | zw == 4 | zw == 5 | zw == 99)
while(zwrot == 1 | zwrot == 2 | zwrot == 3 | zwrot == 4 | sekwencja == 0 | sekwencja == 1 | sekwencja == 2 | sekwencja == 3 | sekwencja == 4)
    {
    if(zwrot == 1 | zwrot == 2 | zwrot == 3 | zwrot == 4)
            {
            switch(zwrot)
                {
                case 1:                                                       //30000 04.07
                        if((rozpoczalem_ruch_preta == 1 & start >=8 & time1 > 20000) | (start < 8 & time1 > 3000))                
                            {
                            if(start < 8)
                                PORTB.5 = 1;  //si�ownik ma�y chwytania pr�cika - chwycenie
                            zwrot = 2;
                            time1 = 0;
                            }
                break;
                case 2:
                        if((PINA.5 == 0 & start < 8) | (PINA.5 == 1 & start >= 8)) //kontrola ok - wywalam kontrolwe 14.09 bo koliduje jak sie zapetli nakretka
                            {
                            PORTB.5 = 0; //si�ownik ma�y chwytania pr�cika - puszczenie
                            PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem
                            PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
                            zwrot = 3;
                            } 
                        else
                            {
                            if(time1 > 100000 & PINA.7 == 1)
                                {
                                wydaj_dzwiek();
                                komunikat_13_na_panel();
                                PORTB.5 = 0;
                                time1 = 100001;
                                }
                            if(time1 > 100000 & PINA.7 == 0)    
                                {
                                komunikat_czysc_na_panel();
                                time1 = 0;
                                PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem
                                PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
                                zwrot = 3;
                                }
                            
                            }
                    
                break;
                
                case 3:    
                        
                        
                        if(przejechalem_czujnik_lub_jestem_na_nim == 1)
                            {
                            //if(dlugosc_preta_gwintowanego < 70 & il_pretow_gwintowanych > 1 & start >= 6 & metalowe_grzybki == 0)
                            //  PORTE.3 = 1;
                            PORTB.7 = 0;  //zakoncz dociskanie preta
                            PORTD.0 = 1; //rozpcznij przeniesienie pret do nakladania kleju
                            przejechalem_czujnik_lub_jestem_na_nim = 0;
                            }
                        if(PINA.4 == 1 & przejechalem_czujnik_lub_jestem_na_nim == 0)
                            {
                            PORTD.0 = 1; //czujnik juz nie swieci, czyli jade dalej
                            przejechalem_czujnik_lub_jestem_na_nim = 1;
                            grzybek_jest_nakrecony_na_precie = 0;
                            sek1 = 0;
                            zwrot = 4;
                            }
                                   
                break;
            
                case 4:
                
                    if(PINF.2 == 0)
                        grzybek_jest_nakrecony_na_precie = 1;     
                
                    
                    if(PINA.4 == 0)  //dojechalem znowu do czujnika
                        {
                        //if(grzybek_jest_nakrecony_na_precie == 0)
                        //    licznik_wylatujacych_grzybkow++;
                        //PORTD.0 = 0; //wylacz silnik      //zwalniam 20.09.2018
                        //zwrot = 5;
                        sek1 = 0;
                        zwloka_czasowa = 1;
                        }
                        
                    if(zwloka_czasowa == 1 & sek1 > 5)
                        {
                        PORTD.0 = 0;
                        sek1 = 0;
                        zwloka_czasowa = 0;
                        zwrot = 5;
                        }      
                        
                        
                break;
                }
            }

//PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
                        //jak monterzy zresetuja to sama mi sie pojawi 1

    switch(PINF.7)
    {
    case 0:    //zmieniam 28.06 bylo 0
        switch(sekwencja)       
           {
           case 0:
                    if(PINF.7 == 0 & PINF.3 == 0)
                    {
                    zaloczono_kurtyne = 0;
                    komunikat_czysc_na_panel();
                    PORTE.5 = 1;
                    time = 0;
                    sekwencja = 1;
                    }
                    else
                        {
                        if(PINF.3 == 1 & liczenie == 0)
                            {
                            licznik_spoznien_monter_1_2++;
                            liczenie = 1;
                            }   
                        break;
                        }
           break;                                 //& PINF.1 == 0
           case 1:                    //silownik chwytania lancy
                    if(PINF.7 == 0 & PORTB.1 == 0)
                    {
                    if(time > 1000)  //7500 04.07.2017 dziala bez zarzutu, to byla wina chyba przekaznikow i opoznien na nich, zmieniam tak jak bylo
                        {
                        PORTE.5 = 0;
                        sekwencja = 2;
                        time = 0;
                        }
                    
                    }
                    else
                        break;           
           break;
           
           case 2:                 //& PINF.1 == 0
                    if(PINF.7 == 0)
                    {
                    if(time > 1000)   ////7500  04.07.2017
                    {
                    PORTE.6 = 1;
                    if(PINF.6 == 0)  //ze jedzie
                        {
                        rozpoczalem_ruch_preta = 1;
                        time1 = 0;   //zeby sekunde odczekac z chwyceniem
                        komunikat_czysc_na_panel();
                        sekwencja = 3;
                        PORTE.6 = 0;
                        time = 0;
                        }
                    else
                        {
                        komunikat_12_na_panel();    
                        }
                    }
                    }
                    else
                        {
                        PORTB.1 = 0;
                        break;
                        }
                    
           break;
           
           case 3:   
                    if(PINF.6 == 1)  //ze stoi
                    {
                    komunikat_czysc_na_panel();
                    PORTE.6 = 0;
                    if(time > 6000)      //to b�dzie chyba to......to powoduje jechanie dwa razy...zmieniam to na 6000..bylo 60000  12.20.2017 
                        sekwencja = 4;
                    else
                        sekwencja = 0;
                    }
           break;
           case 4:
                    sekwencja = 5;
                    if(start >= 10 & tryb_male_puchary == 0)
                        PORTD.2 = 1;  //komunikacja bez rs232 zgodna na zacisniecie szczek
                    if(start >= 9 & tryb_male_puchary == 1)
                        PORTD.2 = 1;  //komunikacja bez rs232 zgodna na wysuniecie silownika otwierajacego wieze                                    
           break;
        
           }

 
    break;

    case 1: //zmieniam 28.06 bylo 1
        komunikat_czysc_na_panel();
        komunikat_10_na_panel();
        
        PORTE.5 = 0;
        PORTE.6 = 0;
        PORTD.2 = 0;   //koniec zezwolenia na zacisniecie szczek
        sekwencja = 0;
        time = 0;
        if(zaloczono_kurtyne == 0)
            {
            zaloczono_kurtyne = 1;
            licznik_wyzwolen_kurtyny++;
            }
    break;
    }

    
    
    
    
    time++;
    time1++;
    }



}


void komunikacja_startowa_male_puchary(int wynik_wyboru_male_puchary)
{
int licznik_impulsow_male_puchary;
int znacznik;

licznik_impulsow_male_puchary = 0;
znacznik = 0;

PORTD.6 = 1;
delay_ms(500);
while(licznik_impulsow_male_puchary < wynik_wyboru_male_puchary)    //3 oznacza brak malych pucharow
{
if(PINF.1 == 1)
    {
    PORTD.3 = 1;
    znacznik = 1;
    }
    
if(PINF.1 == 0 & znacznik == 1)
    {            //czekaj
    PORTD.3 = 0;
    znacznik = 2;
    }

if(znacznik == 2)
    {
    licznik_impulsow_male_puchary++;            
    znacznik = 3;
    }

}
delay_ms(500);
PORTD.6 = 0;

}




int ustawienia_startowe()
{

wartosci_wstepne_panelu();

while(PINA.0 == 0)//brak cisnienia
    komunikat_7_na_panel();
komunikat_czysc_na_panel();      

obsluga_startowa_dozownika_kleju();
komunikat_czysc_na_panel();
komunikat_1_na_panel();
//obsluga_startowa_dozownika_kleju_slave();
komunikat_czysc_na_panel();

while(PINA.4 == 1)  //jak nie widzi czujnika przenosnik pretow czyli nie wiadomo gdzie jestesmy
    PORTD.0 = 1; //silnik przenosnika pretow
przejechalem_czujnik_lub_jestem_na_nim = 1;



PORTD.0 = 0;
PORTC.3 = 0;  //silownik na ktorym jest silnik dokrecajacy grzybki
PORTC.1 = 0;  //silownik pobierania grzybow duzy
PORTC.2 = 1;  //silownik pobierania grzybow maly - droga DO grzebienie pod ci�nieniem
PORTE.2 = 0;  //silownik pobierania grzybow maly - droga OD grzebienie pod ci�nieniem
PORTB.7 = 0;   //silownik dociskajacy pret na grzybkach

inicjalizacja_orientator_grzybkow();
komunikat_czysc_na_panel();
komunikat_3_na_panel();

while(z == 0)
{
//obsluga oproznienia grzybkow
odpytaj_parametry_z_panelu(1);
if(oproznij_podajnik == 1)
    {
    delay_ms(1000);
    PORTC.2 = 0;  //silownik pobierania grzybow maly - droga DO grzebienie pod ci�nieniem
    PORTE.2 = 1;  //silownik pobierania grzybow maly - droga OD grzebienie pod ci�nieniem
    delay_ms(3000);
    PORTC.1 = 1;  //silownik pobierania grzybow duzy - cofamy sie
    delay_ms(3000);
    PORTC.2 = 1;  //silownik pobierania grzybow maly - droga DO grzebienie pod ci�nieniem
    PORTE.2 = 0;  //silownik pobierania grzybow maly - droga OD grzebienie pod ci�nieniem
    delay_ms(2000);
    PORTC.2 = 0;  //silownik pobierania grzybow maly - droga DO grzebienie pod ci�nieniem
    PORTE.2 = 1;  //silownik pobierania grzybow maly - droga OD grzebienie pod ci�nieniem
    delay_ms(3000);
    PORTC.1 = 0;  //silownik pobierania grzybow duzy

    komunikat_9_na_panel();
    
    /*
    while(1)
        {
        delay_ms(1000);
        PORTC.1 = 0;  //silownik pobierania grzybow duzy
        delay_ms(1000);
        PORTC.1 = 1;  //silownik pobierania grzybow duzy
        }
    */
    
    while(1);
        {
        }
    }

//obsluga guzika start
z = czekaj_na_guzik_start();
}
z = 0;


przenies_pret_gwintowany(); //teraz mozemy spasc pierwszym pretem ze zjezdzalni
PORTC.5 = 1; //silownik ostatni otwarcie
delay_ms(1000);
PORTC.5 = 0;
przenies_pret_gwintowany();
delay_ms(1000);
przenies_pret_gwintowany();
delay_ms(1000);
przenies_pret_gwintowany();

zajechalem = 0;
sekwencja = 0;


//if(PINF.1 == 1)
//    while(1)
//        {
//        }

while(zajechalem == 0 | zajechalem == 2 | zajechalem == 3)
    zajechalem = obsluga_startowa_tasmy_lancuchowej();
zajechalem = 0;

/*
while(1)
{
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
delay_ms(1000);
//sekwencna testowa
przenies_pret_gwintowany();
}
*/


/*
while(1)
{
if(PINA.7 == 0)
    {
    PORTB.5 = 1; //si�ownik ma�y chwytania pr�cika - zlap
    PORTB.1 = 1; //si�ownik chwytania lancy - zlap
    PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
    delay_ms(1000);
    PORTB.6 = 1; //silownik obrotowy na ktorym jest maly chwytajacy precik 
    delay_ms(1000);
    PORTB.2 = 1; //wkladanie do lancy precika z grzybkiem
    delay_ms(1000);
    PORTB.0 = 0; //zamkniecie szczek w lancy - silownik z boku
    delay_ms(500);
    while(PINA.7 == 0)
        {
        }
    }
else
    {
    PORTB.5 = 0; //si�ownik ma�y chwytania pr�cika - pusc
    delay_ms(2000);
    PORTB.1 = 0; //si�ownik chwytania lancy - pusc
    //PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem
    //PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik
    delay_ms(2000);
    }
                                             //& PORTB.2 == 0 & PORTB.6 == 0
if(PINF.0 == 0 & PORTB.5 == 0 & PORTB.1 == 0 & PORTB.0 == 0)  //pedal
    {
    PORTE.6 = 1;
    delay_ms(500);
    PORTE.6 = 0;
    delay_ms(500);
    PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem
    PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik
    delay_ms(100);
    }
    
}
*/

delay_ms(1000);
odpytaj_parametry_z_panelu(1);

//////////////////////////////////////////////


if(tryb_male_puchary == 1)
    komunikacja_startowa_male_puchary(wynik_wyboru_male_puchary);

PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje

return 1;
}

int czekaj_na_klej()
{
/*
if(PINA.6 == 1)
  {
  komunikat_8_na_panel(0); //dozownik kleju nie gotowy
  delay_ms(1000);
  klej = 0;
  d = 1;
  }
*/

/*

if(PINA.6 == 0 | PINA.6 == 1)
  {
  if(d == 1)
     {
     komunikat_czysc_na_panel();
     d = 0;
     }
     
  klej = 1;
  }  
*/

klej = 1;
return klej;
}


int czekaj_na_odpuszczenie_szczek()
{
int spr;

PORTE.7 = 1;//do komunikacji �adanie

//putchar1(4);  //ze dotyczy szczek
//spr = getchar1();
//PORTE.7 = 0;//do komunikacji koniec �adania

if(PINF.1 == 0)
    spr = 1;
else
   spr = 0; 


if(spr == 0)
  {
  if(czekaj_komunikat == 5)
        {
        komunikat_11_na_panel(); //monter nie nacisnal pedala
        czekaj_komunikat = 0;
        }
  czekaj_komunikat++;
  monter_slave = 0;
  gg = 1; 
  }
  
if(spr == 1)
  {
  czekaj_komunikat = 0;
  if(gg == 1)
     {
     komunikat_czysc_na_panel();
     gg = 0;
     }
     
  monter_slave = 1;
  PORTE.7 = 0;
  PORTD.2 = 0;  //komunikacja bez rs232 KONIEC zgody na zacisniecie szczek
  }
    
return monter_slave;

}


int czekaj_na_widzenie_puchara_przez_czujnik()
{
int spr;

PORTE.7 = 1;//do komunikacji �adanie
putchar1(6);  //ze dotyczy czujnika widzenia puchara
spr = getchar1();
PORTE.7 = 0;//do komunikacji koniec �adania

if(spr == 0)
  {
  if(czekaj_komunikat == 5)
        {
        komunikat_17_na_panel(); //czujnik nie zobaczyl
        czekaj_komunikat = 0;
        }
  czekaj_komunikat++;
  //delay_ms(1000);
  monter_slave = 0;
  gg = 1;
  }
  
if(spr == 1)
  {
  czekaj_komunikat = 0;
  if(gg == 1)
     {
     komunikat_czysc_na_panel();
     gg = 0;
     }
     
  monter_slave = 1;
  }
    
return monter_slave;

}



int czekaj_na_klej_slave()
{
int spr;

PORTE.7 = 1;//do komunikacji �adanie
putchar1(1);  //ze dotyczy kleju
spr = getchar1();
PORTE.7 = 0;//do komunikacji koniec �adania

if(spr == 0)
  {
  komunikat_8_na_panel(1); //dozownik kleju nie gotowy
  delay_ms(1000);
  klej_slave = 0;
  dd = 1;
  }
  
if(spr == 1)
  {
  if(dd == 1)
     {
     komunikat_czysc_na_panel();
     dd = 0;
     }
     
  klej_slave = 1;
  }
    
return klej_slave;

}



int proces_0()
{
int wynik;
wynik = 0;

switch(proces[0])
    {
    case 0:
        proces[0] = 1;
        zerowanie_czasu();
        
    break;
    
    case 1: 
            PORTC.7 = 1;      //silownik 1 w gore
            if(PINA.2 == 0 & PINA.3 == 0)  //widzi preta      
                {
                sek0_7s = 0;
                sek0 = 0;       
                proces[0] = 2;
                jest_pret_pod_czujnikami = 1;
                komunikat_5_na_panel();
                }
            else
                {
                komunikat_4_na_panel();
                
                }
    break;
        
    case 2:  
            if(sek0 > 40)  //silownik 1 w dol
                {
                PORTC.7 = 0;
                sek0 = 0;
                proces[0] = 3;
                }
    break;
    case 3:
            if(sek0 > 20)  //20 13.09  //60   //40 11.23
                {
                PORTC.6 = 1; //silownik 2 w gore
                sek0 = 0;
                proces[0] = 4;
                }          
                  
    break;
    case 4:
            if(sek0 > 20) //20 13.09  //60    //40 11.23
                {
                PORTC.6 = 0; //silownik 2 w dol
                PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
                sek0 = 0;
                proces[0] = 5;
                } 
    break;
    
    case 5:
            if(sek0 > 40)       //60
                {
                PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
                sek0 = 0;
                proces[0] = 6;
                }
    
    break;
    
    case 6:
            if(PINA.2 == 0 & PINA.3 == 1)    //       
                {
                //proces[0] = 3;
                proces[0] = 1;
                sek0 = 21;
                }
                
            if(PINA.2 == 1 & PINA.3 == 0)       
                {
                //proces[0] = 3;
                proces[0] = 1;
                sek0 = 21;
                }
                
            if(PINA.2 == 0 & PINA.3 == 0)       
                {
                proces[0] = 3;
                sek0 = 21;
                }    
                    
            if(PINA.2 == 1 & PINA.3 == 1)   // 
                {
                proces[0] = 7;
                }    
            
    
    break;
    

    case 7:
            if(sek0 > 20)    //60  tu byla chyba akcja jak dalem na 20, zwiekszam czas na 40, 20 bylo ok chwilowo daje 30    //30 11.23
                {
                PORTC.5 = 1; //silownik 3 w gore
                sek0 = 0;
                proces[0] = 8;
                } 
    break;
    
    case 8:
            if(sek0 > 20)      //60
                {
                PORTC.5 = 0; //silownik 3 w dol
                PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
                sek0 = 0;
                proces[0] = 9;
                } 
    break;
    
    case 9:
            if(sek0 > 50)  //10
               {
               PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
               proces[0] = 10;
               //proces[0] = 1;
               }                
    break;
    
    case 10:
            //if(sek0_7s > czas_monterow)
            //    {
                sek0 = 0;
                proces[0] = 0;
                wynik = 1;
                if(start == 1)  //do sytuacji startowej
                    start = 2;
            //    }   
                                    
    break;
    }


return wynik;
}


int proces_1()
{
int wynik;
wynik = 0;
//zwrotka = 0;

switch(proces[1])
    {
    case 0:
        sek1_7s = 0;
        sek1 = 0;
        proces[1] = 1;    
    break;
    
        
    case 1: 
            //if(sek1 > 40)
            //    {
            //    PORTC.4 = 1;      //silownik z glowica kleju nad pret nie ma juz na razie kleju
            //    }
            
            if(sek1 > 60)  //150 01.08  
                {
                //lej klej
                PORTE.4 = 1;  //lej klej
                sek1 = 0;       
                proces[1] = 2;
                }              
    break;
        
    case 2:  
            if(sek1 > 30) //100  
                {
                //przestan lac klej
                PORTE.4 = 0;  //lej klej
                sek1 = 0;
                proces[1] = 3;
                }
    break;
    case 3:
            if(sek1 > 50)
                {
                //PORTC.4 = 0; //cofnij silownik z klejem  //nie ma juz na razie kleju
                sek1 = 0;
                proces[1] = 4;
                }          
                  
    break;
    case 4:
            if(sek1 > 50)  //czekaj az sie cofnie
                proces[1] = 5;
                 
    break;
                   
    case 5:
            //if(sek1_7s > czas_monterow)
            //    {
                sek1 = 0;
                proces[1] = 0;
                wynik = 1;
                if(start == 3)  //do sytuacji startowej
                    start = 4;
            //    }   
                                    
    break;
    }




return wynik;
}


// wersja fast ale koliduje to ze przenosze pret na poczotku
int proces_2()
{
int wynik;
wynik = 0;

switch(proces[2])
    {
    case 0:
        sek2_7s = 0;
        sek2 = 0;
        PORTB.3 = 0; //silownik dociskajacy grzybki - na wszelki wypadek w gore gdyby nie byl
        PORTC.2 = 0; //maly silownik grzybka - droga DO grzebieni
        proces[2] = 1;    
    break;
    
    case 1:
            if(sek2 > 1)
                {
                PORTE.2 = 1; //wroc malym silownik grzybka
                sek2 = 0;
                proces[2] = 2;
                } 
    break;
    
    case 2:  
            
            if(metalowe_grzybki == 1)
                {
                grzybek_biezacy_dokrecony = 1;
                sek2 = 0;       
                proces[2] = 9;
                }
                
            if(sek2 > 10)  //30
                {
                PORTC.1 = 1; //wroc duzym pobieraniem grzybka
                PORTB.7 = 1; //docisnij preta
                sek2 = 0;
                proces[2] = 3;
                } 
    break;
    
    
    case 3:
            if(sek2 > 50)  //30   bylo ale stukalo, zwolnie  
                {
                PORTC.1 = 0; //pobierz grzybek
                il_grzybkow--;
                sek2 = 0;
                proces[2] = 4;
                } 
    break;
    
    case 4:
            //if(PINA.4 == 0 | )  //upewnij sie ze grzebienie na dole
            //    {
                //PORTB.7 = 1; //docisnij preta
                sek2 = 0;
                proces[2] = 5;
            //    } 
    break;
    
    
    case 5:
            if(sek2 > 20)  //70
                {
                PORTB.3 = 1;   //docisnij grzybek z gory
                PORTE.2 = 0;  //maly silownik grzybka na luz
                grzybek_biezacy_dokrecony = 0;
                sek2 = 0;
                proces[2] = 6;
                }
    break;
    
    case 6:
            if(sek2 > 40)  //30  
                {
                
                //while(1)
                //    {
                //    }
                
                PORTD.1 = 1;  //silnik dokrecajacy grzybki
                PORTC.3 = 1; //przysun silnik
                sek2 = 0;
                proces[2] = 7;
                }
    
    break;
    /*    
    case 7: 
            
            if(PINF.5 == 0)
                grzybek_biezacy_dokrecony = 1;
            
            if(sek2 > czas_silnika_dokrecajacego_grzybki)       //maks 200, min 20
                {
                PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
                PORTD.1 = 0;  //silnik dokrecajacy grzybki
                }
                
             if(sek2 > czas_silnika_dokrecajacego_grzybki+10)    
                {
                PORTC.3 = 0; //odsun silnik  
                PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
                sek2 = 0;       
                proces[2] = 8;
                }   
                
                
    break;
    */
    case 7: 
            
            if(PINF.5 == 0 & grzybek_biezacy_dokrecony == 0)
                {
                grzybek_biezacy_dokrecony = 1;
                sek2 = 0;
                }
            
            //if(grzybek_biezacy_dokrecony == 1 & sek2 >= (czas_silnika_dokrecajacego_grzybki - 5))
                
            
            if(grzybek_biezacy_dokrecony == 1 & sek2 >= czas_silnika_dokrecajacego_grzybki)
                {
                PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
                PORTD.1 = 0;  //silnik dokrecajacy grzybki 
                sek2 = 0;                                  
                proces[2] = 8;
                }
                
            if(sek2 > czas_silnika_dokrecajacego_grzybki_stala)       //maks 200, min 20
                {
                PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
                PORTD.1 = 0;  //silnik dokrecajacy grzybki
                licznik_niezakreconych_grzybkow++;
                grzybek_biezacy_dokrecony = 0;
                sek2 = 0;
                proces[2] = 8;
                }
            
    
    break;
    
    case 8:
             if(sek2 > 0 & grzybek_biezacy_dokrecony == 1)   //NOWE 18.09.2018   
                 PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni       
             if(sek2 > 0 & grzybek_biezacy_dokrecony == 0)   //NOWE 18.09.2018   
                 PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
             
             if(sek2 > 5 & grzybek_biezacy_dokrecony == 1)    
                {
                //PORTC.3 = 0; //odsun silnik  
                PORTB.7 = 0; //przestan dociskac pret////////
                //PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
                if(sek2 > 13)
                    {
                    PORTB.7 = 1;  //docisnij pret
                    sek2 = 0;       
                    proces[2] = 9;
                    }
                }
             
             if(sek2 > 5 & grzybek_biezacy_dokrecony == 0)    
                {
                //PORTC.3 = 0; //odsun silnik  
                PORTB.7 = 0; //przestan dociskac pret////////
                //PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
                if(sek2 > 13)
                    {
                    PORTB.7 = 1;    //docisnij pret
                    sek2 = 0;       
                    proces[2] = 9;
                    }
                }
                
             
                            
    break;
    
    
    case 9: 
            if(sek2 > 5)    
                {
                PORTC.3 = 0; //odsun silnik  
                if(sek2 > 33)    //zmieniam 5 na 30 zeby trzymalo dluzej az odjedzie silnik
                    {
                    PORTB.7 = 0; //pusc preta
                    sek2 = 0;       
                    proces[2] = 10;
                    }
                }
    break;
                   
    case 10:
            //if(sek2_7s > czas_monterow)
            //    {
                grzybek_dokrecony = grzybek_biezacy_dokrecony;
                sek2 = 0;
                proces[2] = 0;
                wynik = 1;
                if(start == 5)  //do sytuacji startowej
                    start = 6;
            //    }   
                                    
    break;
    }




return wynik;
}

int proces_3()
{
int wynik;
wynik = 0;

switch(proces[3])
    {
    case 0:
        sek3_7s = 0;
        sek3 = 0;
        proces[3] = 1;
        licz = 0;    
    break;
    
    case 1:
                    
            sek3 = 0;
            PORTC.4 = 0;     //bramka grzybkow w gore
            if(dlugosc_preta_gwintowanego < 70)
                  PORTE.3 = 1;
            proces[3] = 2;
            
                 
    break;
    
    case 2:
            
            
            
            if(sek3 > 50)    //80 02.08
                {
                if(dlugosc_preta_gwintowanego < 70)
                  PORTE.3 = 0;
                }
            if(sek3 > 60)    
                {
                PORTC.0 = 0;
                if(dlugosc_preta_gwintowanego != 60)
                    PORTB.1 = 1; //si�ownik chwytania lancy
                PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
                sek3 = 0;
                proces[3] = 3;
                }
            
    
    break;
    
    
    case 3: 
            if(grzybek_dokrecony == 1 & metalowe_grzybki == 0 & oczekiwanie_na_poprawienie == 0 & grzybek_jest_nakrecony_na_precie == 1) 
                {
                proces[3] = 4;
                sek3 = 0;
                }
            else
                {
                wydaj_dzwiek();
                komunikat_15_na_panel();
                oczekiwanie_na_poprawienie = 1;
                if(PINA.7 == 0)
                    {
                    if(grzybek_jest_nakrecony_na_precie == 0 & start >= 7)
                        licznik_wylatujacych_grzybkow++;
                    proces[3] = 4;
                    sek3 = 0;
                    }    
                }
    break;
    
    case 4:
                           
                
                    
                    if(dlugosc_preta_gwintowanego != 60)
                        {
                        komunikat_czysc_na_panel();
                        oczekiwanie_na_poprawienie = 0;
                        PORTB.5 = 1; //si�ownik ma�y chwytania pr�cika
                        }
                    
                    if(dlugosc_preta_gwintowanego == 60 & PINA.7 == 0)
                        {
                        skonczony_proces[0] = 0;
                        skonczony_proces[1] = 0;
                        skonczony_proces[2] = 0;
                        skonczony_proces[3] = 0;
                        zerowanie_czasu();
                        jest_pret_pod_czujnikami = 0;
                        proces[3] = 0;
                        start = 7;
                        przenies_pret_gwintowany();
                        }
                        
                        
                   if(dlugosc_preta_gwintowanego != 60)
                        {
                        sek3 = 0;
                        proces[3] = 5; //WYWALAM NA RAZIE PRZEJSCIE DALEJ ABY UPROSCIC              
                        }
    break;
    
    case 5:
            
            if(sek3 > 25 & PINA.5 == 1 & PORTB.5 == 1) //nie dojechal do konca czyli jest precik  //50 02.08
                {
                //PORTB.1 = 1; //si�ownik chwytania lancy
                //PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
                PORTB.6 = 1; //silownik obrotowy na ktorym jest maly chwytajacy precik 
                sek3 = 0;
                proces[3] = 6;
                }
            if(sek3 > 50 & PINA.5 == 0) // dojechal do konca czyli jest precika nie ma
                {
                sek3 = 0;
                wydaj_dzwiek();
                komunikat_14_na_panel();
                PORTB.5 = 0; //si�ownik ma�y chwytania pr�cika
                }
            if(PORTB.5 == 0 & PINA.7 == 0)
                 {
                 komunikat_czysc_na_panel();
                 proces[3] = 4;
                 }
            
             
    break;

    case 6:
            
            if(sek3 > 25)  //50 02.08  
                {
                //PORTB.1 = 1; //si�ownik chwytania lancy
                PORTB.2 = 1; //wkladanie do lancy precika z grzybkiem
                sek3 = 0;
                proces[3] = 7;
                } 
    break;
    
    case 7:
            
            if(sek3 > 30)  //50 02.08  
                {
                if(PINF.0 == 1)
                    licznik_niewlozonych_pretow_z_grzybkiem++;    
                PORTB.0 = 0; //zacisniecie szczek w lancy - silownik z boku
                sek3 = 0;
                proces[3] = 8;
                } 
    break;
    
    case 8:
           
            if(sek3 > 30)  //50  02.08  
                {
                PORTB.5 = 0; //si�ownik ma�y chwytania pr�cika - puszczenie precika
                //PORTB.1 = 0; //si�ownik chwytania lancy - puszczenie
                sek3 = 0;
                proces[3] = 9;  ///bylo 9 omijam teraz te dwa ponizej  //jednak finalnie nie omijam
                                //jednal omijam tylko jednego ponizej
                }
    break;
    
    
        
    case 9: 
            if(sek3 > 10)  
                {
                PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem  
                sek3 = 0;       
                proces[3] = 10;
                }
    break;
       
    case 10: 
            if(sek3 > 10)  
                {  
                PORTB.1 = 0; //si�ownik chwytania lancy - puszczenie
                //PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
                PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje 
                sek3 = 0;       
                proces[3] = 11;
                }
    break;
    
    
    
                   
    case 11:                             
                         //& PINF.1 == 0               
            if(sek3 > 20 )
                {
                sek3 = 0;
                proces[3] = 0;
                wynik = 1;
                il_pretow_gwintowanych--;   
                if(start == 7)  //do sytuacji startowej
                    {
                    start = 8;
                    monter_1_time = 0;
                    monter_2_time = 0;
                    monter_3_time = 0;
                    }
                }   
                                    
    break;
    }


return wynik;
}


void procesy()
{
if(skonczony_proces[0] == 0 & start != 0)
  skonczony_proces[0] = proces_0();  
        
if(skonczony_proces[1] == 0 & start != 0 & start != 1 & jest_pret_pod_czujnikami == 1)
  skonczony_proces[1] = proces_1();        
      
if(skonczony_proces[2] == 0 & start != 0 & start != 1 & start != 2 & start != 3 & start != 4 & jest_pret_pod_czujnikami == 1)
    skonczony_proces[2] = proces_2();
          
if(skonczony_proces[3] == 0 & start != 0 & start != 1 & start != 2 & start != 3 & start != 4 & start != 5 & start != 6 & jest_pret_pod_czujnikami == 1)
  skonczony_proces[3] = proces_3();
}

void wyzeruj_monterow()
{
monterzy_skonczyli = 0;
monter_1_skonczyl = 0;
monter_2_skonczyl = 0;
monter_3_skonczyl = 0;
monter_1_time = 0;
monter_2_time = 0;
monter_3_time = 0;
wyswietl_czas_procesu();
zerowanie_czasu();
//if(skonczony_proces[0] == 0)
//    wyswietl_czas_procesu();
}



void zerowanie_procesow()
{
int liczenie;
long int czestosc_komunikacji;
czestosc_komunikacji = 0;
liczenie = 0;

if(skonczony_proces[0] == 1 & start == 2)
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        //klej_slave = czekaj_na_klej_slave();
        klej_slave = 1;
        kontrola_grzybkow = kontrola_grzyb();  // & kontrola_grzybkow == 1
        if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
            {
            przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
            wyswietl_czas_procesu();
            odpytaj_parametry_z_panelu(0);
            skonczony_proces[0] = 0;
            zerowanie_czasu();
            jest_pret_pod_czujnikami = 0;
            start = 3;
            }
        }
        
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & start == 4) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        //klej_slave = czekaj_na_klej_slave();
        klej_slave = 1;
        kontrola_grzybkow = kontrola_grzyb();   
        if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
            {
            przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
            wyswietl_czas_procesu();
            odpytaj_parametry_z_panelu(0);
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            zerowanie_czasu();
            start = 5;
            jest_pret_pod_czujnikami = 0;
            }
        }
      
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & start == 6) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        //klej_slave = czekaj_na_klej_slave();
        klej_slave = 1;
        kontrola_grzybkow = kontrola_grzyb();   
        if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
            { 
            //ksp = 0;
            przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
            wyswietl_czas_procesu();
            odpytaj_parametry_z_panelu(0);
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            skonczony_proces[2] = 0;
            zerowanie_czasu();
            jest_pret_pod_czujnikami = 0;
            start = 7;
            }
        }

//to ju� jest ten glowny co chodzi w kolko      
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & skonczony_proces[3] == 1 & start >= 8) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        //klej_slave = czekaj_na_klej_slave();
        klej_slave = 1;
        kontrola_grzybkow = kontrola_grzyb();                             
        if(monterzy_skonczyli == 1 & z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
            {
            monter_slave = 0;
            czestosc_komunikacji = 0;
            while(monter_slave == 0 & start >=11 & tryb_male_puchary == 0)   
                {                                                                
                czestosc_komunikacji++;
                if(czestosc_komunikacji == 1)
                    monter_slave = czekaj_na_odpuszczenie_szczek();
                if(czestosc_komunikacji > 100)
                    czestosc_komunikacji = 0;
                          
                if(monter_slave == 0 & liczenie == 0)   //nie nacisnal o czasie szczek
                      {
                      licznik_spoznien_monter_3_nowy++;
                      liczenie = 1;
                      }
                }
            
            while(monter_slave == 0 & start >=10 & tryb_male_puchary == 1)
                {
                czestosc_komunikacji++;
                if(czestosc_komunikacji == 1)
                    monter_slave = czekaj_na_odpuszczenie_szczek();
                    //tasma lancuchowa powinna ruszyc monter 2 nacisnie pedal i minie okolo 1s
                if(czestosc_komunikacji > 100)
                    czestosc_komunikacji = 0;
                }
                
                
                
                
             
                przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
                                          //nie dawca zezwolenia na szczeki
                             
            odpytaj_parametry_z_panelu(0);       //jak il_pretow == 4
            if(anuluj_biezace_zlecenie == 1 & anuluj_biezace_zlecenie_const == 0)
                {
                anuluj_biezace_zlecenie = 0;
                anuluj_biezace_zlecenie_const = 1;
                ustaw_na_nie_anulacje_zlecenia();
                il_pretow_gwintowanych = 4;
                il_pretow_gwintowanych_stala = il_pretow_gwintowanych; 
                licznik_pucharow = -2;  //0
                }        
            
            
            start++;
            if(start > 1000)
               start = 100;  //zeby sie nie zapetlil start 
            
            if(il_pretow_gwintowanych > 3 & jest_pret_pod_czujnikami == 1)
                {
                jest_pret_pod_czujnikami = 0;
                skonczony_proces[0] = 0;
                skonczony_proces[1] = 0;
                skonczony_proces[2] = 0;
                skonczony_proces[3] = 0;
                }
            
             if(il_pretow_gwintowanych > 2)
                {
                jest_pret_pod_czujnikami = 1;//bo procesu 0 juz nie ma
                skonczony_proces[1] = 0;
                skonczony_proces[2] = 0;
                skonczony_proces[3] = 0;
                }
                
             if(il_pretow_gwintowanych > 1)
                {
                jest_pret_pod_czujnikami = 1; //bo procesu 0 juz nie ma
                skonczony_proces[2] = 0;
                skonczony_proces[3] = 0;
                }
                
             if(il_pretow_gwintowanych > 0)
                {
                jest_pret_pod_czujnikami = 1; //bo procesu 0 juz nie ma
                skonczony_proces[3] = 0;
                }
            
            wyzeruj_monterow();
                               
            if((licznik_pucharow - 1) == il_pretow_gwintowanych_stala & potw_zielonym_bo_pomyliles_pedal_z_potwierdz == 0)
                    {
                    komunikat_6_na_panel();
                    msek_clock = 0;
                    sek_clock = 0;
                    min_clock = 0;
                    godz_clock = 0;            
                    PORTD.4 = 0;  //wylacz orientator bo wyl
                    PORTD.2 = 0;  //koniec zezwolenia na szczeki
                    ustaw_na_nie_anulacje_zlecenia();
                    wylacz_maszyne();
                    z = 0;
                    start = 0;
                    }
            }
            
        }
}
                 

void kontrola_monterow()
{
//brak monterow

if(start == 8 & monterzy_skonczyli == 0)
      monterzy_skonczyli = 1;

//praca ciagla monterow

if(start >= 9 & monterzy_skonczyli == 0)
    {
    if(monter_1_skonczyl == 0)  //zmianiam & na | i powinno nie byc potrzebne naciskanie guzika monter 1
        {
        if(monter_1_time > czas_monterow & start >= 10)
           licznik_spoznien_monter_1++; 
        monter_1_skonczyl = 1;
        }

    if(monter_2_skonczyl == 0)    //zmianiam & na | i powinno nie byc potrzebne naciskanie guzika monter 2
        {
        if(monter_2_time > czas_monterow & start >= 10)
           licznik_spoznien_monter_2++;
        monter_2_skonczyl = 1;    
        }
    
    
                                              
    if(PINF.4 == 0 & monter_3_skonczyl == 0 & start < 11 & tryb_male_puchary == 0)
        {
        if(monter_3_time > czas_monterow & start >= 10)
           licznik_spoznien_monter_3++;
        if(start >=10)   //12 23.03.2016
            {
            licznik_pucharow++;
            licznik_pucharow_global++;    
            wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
            wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
            }
        monter_3_skonczyl = 1;    
        }
    
     
    
     if(PINF.4 == 0 & monter_3_skonczyl == 0 & start == 9 & tryb_male_puchary == 1)
        {
        monter_3_skonczyl = 1;
        }
     
     
     if((PINF.4 == 0 | monter_3_skonczyl == 0) & start >= 10 & tryb_male_puchary == 1)      
        {
        if(monter_3_time > czas_monterow & start >= 10)
           licznik_spoznien_monter_3++;
        if(start >=10)   //12 23.03.2016
            {
            licznik_pucharow++;
            licznik_pucharow_global++;
            wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
            wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
            }
        monter_3_skonczyl = 1;    
        }
     
     
     
     
     
     
     
    
     if((PINF.4 == 0 | monter_3_skonczyl == 0) & start >= 11 & tryb_male_puchary == 0)      //nowe cale if 31.07
        {
        if(monter_3_time > czas_monterow & start >= 10)
           licznik_spoznien_monter_3++;
        if(start >=10)   //12 23.03.2016
            {
            licznik_pucharow++;
            licznik_pucharow_global++;
            wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
            wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
            }
        monter_3_skonczyl = 1;    
        }
    

    if(monter_1_skonczyl == 1 & monter_2_skonczyl == 1 & monter_3_skonczyl == 1)
       {
       monterzy_skonczyli = 1; 
       }
    }

}


void wznowienie_pracy_po_wykonaniu_zadania()
{
if(start == 0)
         {  
         if(z == 0)
            {
            z = czekaj_na_guzik_start();
            wyswietl_czas_przezbrojenia();
            }
         else
            {
            odpytaj_parametry_z_panelu(1);
            //if(tryb_male_puchary == 1)
            komunikacja_startowa_male_puchary(wynik_wyboru_male_puchary);

            licznik_pucharow = 0;
            licznik_spoznien_monter_1 = -1;
            licznik_spoznien_monter_2 = -1;
            licznik_spoznien_monter_3 = -1;
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            skonczony_proces[2] = 0;
            skonczony_proces[3] = 0;
            licznik_pucharow = 0;
            komunikat_czysc_na_panel();
            PORTD.4 = 0; //wylacz orientatorchy gdyby chodzil
            anuluj_biezace_zlecenie_const = 0;
            wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow,licznik_pucharow_global);
            wyswietl_czas_laczny_przezbrajan();
            PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje
            start = 1;
            
            }
         }
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Port E initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTE=0x00;
DDRE=0xFF;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T  
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State4=0 State3=0 State2=0 State1=0 State0=0 
PORTG=0x00;
DDRG=0x1F;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x07;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

ETIMSK=0x00;



// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x67;

/*
// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 2400
UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
UBRR1H=0x01;
UBRR1L=0xA0;

*/

// USART1 initialization
// USART1 disabled
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);


/*

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 9600
UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
UBRR1H=0x00;
UBRR1L=0x67;

*/

/*

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x08;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 115200
UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
UBRR1H=0x00;
UBRR1L=0x08;

*/

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")

//WE
//PINA.0    czujnik ci�nienia
//PINA.1    czujnik widzenia grzybka
//PINA.2    czujnik 1 widzenia pr�ta gwintowanego na rynnie
//PINA.3    czujnik 2 widzenia pr�ta gwintowanego na rynnie
//PINA.4    czujnik od silnika grzebieni
//PINA.5    sygnal braku kleju - informacja z dozownika kleju - nie wykorzystuje, zmieniam na czujnik chwycenia preta
//PINA.6    sygnal gotowosci do pracy dozownika kleju - zmieniam na czujnik czy sa prety gorne
//PINA.7    guzik czy monter dokrecil grzybka, je�eli by�a taka potrzeba

//PINF.0    wlacznik tasmociagu monterow 1 dawnij, teraz: czujnik czy w�o�y� grzybek do lufy
//PINF.1    teraz czy si�ownik chwytaj�cy wie�e jest zamkniety  //znowu idzie out//teraz sygnal odpowiedzi od Slave 
//PINF.2    monter 1 wykonal dawniej //tu teraz podpinamy czujnik czy jest grzybek 
//PINF.3    monter 2 wykonal dawnij //teraz sygnal ze kurtyna jest aktywna
//PINF.4    monter 3 wykonal (dawniej czujnik indukcyjny widzacy wieze - ju� go nie ma)
//PINF.5    czujnik czy dokrecil grzybka
//PINF.6    czujnik ze jedzie lancuchowy
//PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
            //jak monterzy zresetuja to sama mi sie pojawi 1

//WY
//PORTB.0   zaciskanie grzybka w lancy
//PORTB.1   si�ownik chwytania lancy
//PORTB.2   wkladanie do lancy precika z grzybkiem
//PORTB.3   silownik przytrzymujacy grzybka od gory
//PORTB.4   silownik pozycjonujacy preta jeszcze na zjezdzalni
//PORTB.5   si�ownik ma�y chwytania pr�cika
//PORTB.6   silownik obrotowy na ktorym jest maly chwytajacy precik
//PORTB.7   silownik dociskajacy pret na grzebieniach

//PORTC.0   cisnienie na linijke - ci�nienie do dozownika kleju - dalem na stale ------------------TU EWENTUALNIE PSIKANIE NA GRZYBEK - chyba wolne
//PORTC.1   silownik pobierania grzybow duzy
//PORTC.2   silownik pobierania grzybow maly - droga DO grzebienie pod ci�nieniem
//PORTC.3   silownik na ktorym jest silnik dokrecajacy grzybki
//PORTC.4   dawniej silownik trzymajcy strzelanie klejem - zmieniam na silownik bramki precikow z grzybkiem
//PORTC.5   si�ownik 3 kolejkuj�cy na rynnie
//PORTC.6   si�ownik 2 kolejkuj�cy na rynnie  
//PORTC.7   si�ownik 1 kolejkuj�cy na rynnie

//PORTD.0   silnik przenosnika pretow 
//PORTD.1   silnik dokrecajacy grzybki
//PORTD.2   DAWNIEJ kana� 1 RS232, TERAZ   zgoda na zacisniecie szczek w wersji komunikacja uproszczona    
//PORTD.3   DAWNIEJ kana� 1 RS232, TERAZ sygnal do przesylania informacji malych pucharach
//PORTD.4   orientator grzybkow
//PORTD.5   dozownik kleju zasilanie 220V   
//PORTD.6   SPALONY DAWNIEJ, TERAZ DAJE TU SYGNAL JAKO PRZECINEK MIEDZY PACZKAMI DANYCH - informacja o malych puchyarach 
//PORTD.7   LAMPA BRAK PRETOW

//PORTE.0   kana� 0 RS232
//PORTE.1   kana� 0 RS232
//PORTE.2   silownik pobierania grzybow maly - droga OD grzebienie pod ci�nieniem  
//PORTE.3   podpi�ty do listwy zaworowej ale nie podpi�ty ci�nieniowo------TU EWENTUALNIE PSIKANIE NA GRZYBEK
//PORTE.4   wlaczenie lania kleju
//PORTE.5   sekwencja startowa pivexin
//PORTE.6   manipulator wykonal pivexin
//PORTE.7   sygnal synchronizacji dla procesora slave
 
//PROCESY
//proces_0 - kolejkowanie pr�ta na zje�d�alni
//proces_1 - nak�adanie kleju
//proces_2 - nakrecanie grzybka
//proces_3 - pobieranie grzybka i wsadzanie do lancy



//delay_ms(8000); //bo panel sie inicjalizuje
//delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje


putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

//PORTD.1 = 1;
//while(1)
//{
//}


komunikacja_startowa_male_puchary(3);//brak malych pucharow
//przeslanie danych do slave
//wnioski do komunikacji - wcale nie trzeba czekac czy monter 3 nie nacisnal szczek
//sygnalem aby tasmociag ruszyl ponownie jest nacisniecie pedala tego nowego przez montera 


//zmienne startowe
start = 0;
czas_monterow = 0;
monter_1_skonczyl = 0;
monter_2_skonczyl = 0;
monter_3_skonczyl = 0;
monterzy_skonczyli = 0;
czas_na_transport_preta = 100;
jest_pret_pod_czujnikami = 0;
stala_czasowa = 62;
//il_pretow_gwintowanych = 5;  //minimum dac 5 w panelu
zajechalem = 0;
sekwencja = 0;
czas_silnika_dokrecajacego_grzybki_stala = 220;
czas_silnika_dokrecajacego_grzybki = 40;  //zmianiam z 35 na 55 bo sie wyrobila guma
dlugosc_preta_gwintowanego = 80;
licznik = 0;
licznik_pucharow = 0;
licznik_spoznien_monter_1 = -1;
licznik_spoznien_monter_2 = -1;
licznik_spoznien_monter_3 = -1;  
ff = 0;
pierwszy_raz = 0;
czas_monterow_stala = 0;
oczekiwanie_na_poprawienie = 0;
czekaj_komunikat = 0;
potw_zielonym_bo_pomyliles_pedal_z_potwierdz = 0;
przejechalem_czujnik_lub_jestem_na_nim = 0;
licznik_niezakreconych_grzybkow = 0;
licznik_wylatujacych_grzybkow = 0;
grzybek_jest_nakrecony_na_precie = 0;
licznik_wyzwolen_kurtyny = 0;
licznik_pucharow_global = 0;
czas_zaloczonego_orientatora = 0;
zaloczono_kurtyne = 0;
anuluj_biezace_zlecenie_const = 0;
wynik_wyboru_male_puchary = 0;
wielkosc_kamienia = 0;



z = 0; //do panela
d = 0;
dd = 0;
gg = 0;
klej = 0;
klej_slave = 0;
monter_slave = 0;



//while(1)
//{
//wyswietl_czas_laczny_przezbrajan();
//wyswietl_czas_procesu();
//wyswietl_czas_przezbrojenia();
//}

/////////////////////////////////////////sekwencja do testowania jak jada grzebienie


//while(1)
//{
//if(PINA.7 == 0)
//    PORTD.0 = 1;
//else
//    PORTD.0 = 0;
//}


//jezeli dajemy z panelu dlugosc preta gwintowanego na 60 to wtedy tryb testowy


///////////////////////////////////////////
while(start == 0)
    start = ustawienia_startowe();
    
while (1)
      { 
      orientator_grzybkow();
      wznowienie_pracy_po_wykonaniu_zadania();
      procesy();
      kontrola_monterow();
      zerowanie_procesow();
      kontrola_lampki_brak_pretow();   
      }
}








 