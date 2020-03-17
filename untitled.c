/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <alcd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

int skonczony_proces[10];
int proces[10];
int monter_1_skonczyl,monter_2_skonczyl,monterzy_skonczyli;
int start;
int licznik_pucharow;
int tasma_przejechala,licznik;
int jest_pret_pod_czujnikami;
int czas_silnika_dokrecajacego_grzybki;
int il_pretow_gwintowanych;
int dlugosc_preta_gwintowanego;
long int sek0,sek1,sek2,sek3;
long int sek0_7s,sek1_7s,sek2_7s,sek3_7s;
long int czas_monterow,czas_na_transport_preta;
long int monter_1_time, monter_2_time;
long int stala_czasowa;
int licznik_spoznien_monter_1,licznik_spoznien_monter_2;
int d,dd,klej,klej_slave;
char *dupa1;
int i;
char z;



void sterowanie_tasmociagami_monterow()
{
if(PINF.0 == 0)
    PORTD.1 = 1;
else                //tasma 1
    PORTD.1 = 0;

if(PINF.1 == 0)
    PORTD.6 = 1;
else                //tasma 2
    PORTD.6 = 0;
}



// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
sek0++;
sek0_7s++;
sek1++;
sek1_7s++;
sek2++;
sek2_7s++;
sek3++;
sek3_7s++;
//if(z == 1)
//    {
    monter_1_time++;
    monter_2_time++;
//    }
if(start == 0)
    sterowanie_tasmociagami_monterow();
}



void orientator_grzybkow()
{


if(PINA.1 == 1)
    {
    PORTD.4 = 1;
    if(grzybek == 0)
       {
       il_grzybkow++;
       grzybek = 1;
       }
else
    {
    PORTD.4 = 0;
    grzybek = 1;
    }
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


int pusc_pierwszego_preta()
{
int wynik;
wynik = 0;

//PORTC.5   si³ownik 3 kolejkuj¹cy na rynnie
//PORTC.6   si³ownik 2 kolejkuj¹cy na rynnie  //na pewno podupcona kolejnoœæ
//PORTC.7   si³ownik 1 kolejkuj¹cy na rynnie

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

void komunikat_1_na_panel()
{
putchar(90);
putchar(165);
putchar(35);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 90 - 112
printf("                                        ");

putchar(90);
putchar(165);
putchar(23);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Inicjalizuje maszyne");
}

void komunikat_2_na_panel()
{
putchar(90);
putchar(165);
putchar(23);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Wyczyszczono maszyne");
}

void komunikat_3_na_panel()
{
putchar(90);
putchar(165);
putchar(27);       //ilosc liter 20 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Maszyna zainicjalizowana");
}

void komunikat_4_na_panel()
{
putchar(90);
putchar(165);
putchar(28);       //ilosc liter 25 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Czekam na pret gwintowany");
}

void komunikat_5_na_panel()
{
putchar(90);
putchar(165);
putchar(35);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("                                        ");

putchar(90);
putchar(165);
putchar(8);       //ilosc liter 5 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Praca");
}

void komunikat_6_na_panel()
{
putchar(90);
putchar(165);
putchar(27);       //ilosc liter 24 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("                        ");

putchar(90);
putchar(165);
putchar(38);       //ilosc liter 35 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("Zakrecilem wszystkie zadane puchary");
}

void komunikat_7_na_panel()
{
putchar(90);
putchar(165);
putchar(34);       //ilosc liter 31 + 3
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
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
    putchar(144);  //adres 70 - 112
    printf("Dozownik kleju nakretek nie gotowy");
    }
}

void komunikat_czysc_na_panel()
{
putchar(90);
putchar(165);
putchar(38);       //ilosc liter 43 + 3 //TU ZMIENIAM NORMALNIE SIE DODAJE??
putchar(130);  //82
putchar(0);    //0
putchar(144);  //adres 70 - 112
printf("                                           ");
}

void odpytaj_parametry_z_panelu()
{
char pomocnicza;
z = 0;
pomocnicza = 0;

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

putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(96);  //adres zmiennej - 60
putchar(1);     //czas monterow odczyt
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
pomocnicza = 0;
pomocnicza = getchar();

czas_monterow = (long int)pomocnicza * stala_czasowa; 
//itoa(czas_monterow,dupa1);       
//lcd_puts(dupa1);

if(start == 0)
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
    getchar();
    il_pretow_gwintowanych = getchar();
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
putchar(60);   //60

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
putchar(130);  //82    //czas montazu pucharu
putchar(0);    //00
putchar(96);   //60
putchar(0);    //00
putchar(7);   //7

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //ilosc pucharow do zmontowania
putchar(0);    //00
putchar(112);   //70
putchar(0);    //00
putchar(5);   //5

}


void wyswietl_ilosc_zmontowanych_pucharow(int i)
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //ilosc zmontowanych pucharow
putchar(0);    //00
putchar(128);   //80
putchar(0);    //00
putchar(i);   //7
}

void wyswietl_ilosc_spoznien_monterzy(int i,int j)
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //ilosc zmontowanych pucharow
putchar(0);    //00
putchar(16);   //10
putchar(0);    //00
putchar(i);   //

putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    //ilosc zmontowanych pucharow
putchar(0);    //00
putchar(32);   //20
putchar(0);    //00
putchar(j);   //


}



void obsluga_startowa_dozownika_kleju()
{
PORTD.5 = 1;  //zasilanie 220V na dozownik kleju
PORTC.0 = 1;  //cisnienie na dozownik kleju

while(PINA.6 == 1)
  {
  komunikat_8_na_panel(0); //dozownik kleju nie gotowy
  delay_ms(1000);
  }

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

//dorzucic czujnika indukcyjnego do tej ³apki, która chwyta
//czyli maszyna ma siê nie uruchomiæ dopoki ktos nie wyczyscil tych precikow
//JEZELI SA PRETY TO KOMUNIKAT - ZABIERZ PRETY

//po tym sprawdzeniu nastepuje komunikat:
//WYCZYSZCZONO MASZYNE
komunikat_2_na_panel();

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
obsluga_startowa_dozownika_kleju_slave();
komunikat_czysc_na_panel();

while(PINA.4 == 1)  //jak nie widzi czujnika przenosnik pretow czyli nie wiadomo gdzie jestesmy
    PORTD.0 = 1; //silnik przenosnika pretow
PORTD.0 = 0;
PORTC.3 = 0;  //silownik na ktorym jest silnik dokrecajacy grzybki
PORTC.1 = 0;  //silownik pobierania grzybow duzy
PORTC.2 = 1;  //silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
PORTE.2 = 0;  //silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
PORTB.7 = 0;   //silownik dociskajacy pret na grzybkach

inicjalizacja_orientator_grzybkow();
komunikat_czysc_na_panel();
komunikat_3_na_panel();

while(z == 0)
{
z = czekaj_na_guzik_start();
}
z = 0;

PORTE.5 = 1; //sekwnecja startowa
delay_ms(100);
PORTE.5 = 0; //sekwnecja startowa
delay_ms(200);
PORTE.6 = 1; //manipulator wykonal
delay_ms(100);
PORTE.6 = 0; //manipulator wykonal //mamy wie¿e w odpowiednim miejscu
delay_ms(1000);

odpytaj_parametry_z_panelu();

return 1;
}

int czekaj_na_klej()
{
if(PINA.6 == 1)
  {
  komunikat_8_na_panel(0); //dozownik kleju nie gotowy
  delay_ms(1000);
  klej = 0;
  d = 1;
  }
if(PINA.6 == 0)
  {
  if(d == 1)
     {
     komunikat_czysc_na_panel();
     d = 0;
     }
     
  klej = 1;
  }  
return klej;
}


int czekaj_na_klej_slave()
{
int spr;

PORTE.7 = 1;//do komunikacji ¿adanie
spr = getchar1();
PORTE.7 = 0;//do komunikacji koniec ¿adania

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

//PORTC.5   si³ownik 3 kolejkuj¹cy na rynnie
//PORTC.6   si³ownik 2 kolejkuj¹cy na rynnie  //na pewno podupcona kolejnoœæ
//PORTC.7   si³ownik 1 kolejkuj¹cy na rynnie

switch(proces[0])
    {
    case 0:
        proces[0] = 1;
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
            if(sek0 > 100)  //silownik 1 w dol
                {
                PORTC.7 = 0;
                sek0 = 0;
                proces[0] = 3;
                }
    break;
    case 3:
            if(sek0 > 100)
                {
                PORTC.6 = 1; //silownik 2 w gore
                sek0 = 0;
                proces[0] = 4;
                }          
                  
    break;
    case 4:
            if(sek0 > 100)
                {
                PORTC.6 = 0; //silownik 2 w dol
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
            if(sek0_7s > czas_monterow)
                {
                sek0 = 0;
                proces[0] = 0;
                wynik = 1;
                if(start == 1)  //do sytuacji startowej
                    start = 2;
                }   
                                    
    break;
    }




return wynik;
}


int proces_1()
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
                
                if(il_pretow_gwintowanych > 2)
                    proces[1] = 3;
                else
                    proces[1] = 7;
                }
    break;
        
    case 3: 
            PORTC.4 = 1;      //silownik z glowica kleju nad pret
            if(sek1 > 100)  
                {
                //lej klej
                //PORTE.4 = 1;  //lej klej
                sek1 = 0;       
                proces[1] = 4;
                }
    break;
        
    case 4:  
            if(sek1 > 10)  
                {
                //przestan lac klej
                PORTE.4 = 0;  //lej klej
                sek1 = 0;
                proces[1] = 5;
                }
    break;
    case 5:
            if(sek1 > 200)
                {
                PORTC.4 = 0; //cofnij silownik z klejem
                sek1 = 0;
                proces[1] = 6;
                }          
                  
    break;
    case 6:
            if(sek1 > 100)  //czekaj az sie cofnie
                proces[1] = 7;
                 
    break;
                   
    case 7:
            if(sek1_7s > czas_monterow)
                {
                sek1 = 0;
                proces[1] = 0;
                wynik = 1;
                if(start == 3)  //do sytuacji startowej
                    start = 4;
                }   
                                    
    break;
    }




return wynik;
}

int proces_2()
{
int wynik;
wynik = 0;

switch(proces[2])
    {
    case 0:
        sek2_7s = 0;
        sek2 = 0;
        proces[2] = 1;    
    break;
    
    case 1:
            if(sek2 > czas_na_transport_preta & PINA.4 == 0)  //czekaj az pret sie przetransportuje
                {
                PORTB.3 = 1; //silownik dociskajacy grzybki - na wszelki wypadek w gore gdyby nie byl
                PORTC.2 = 0; //maly silownik grzybka - droga DO grzebieni
                PORTB.7 = 1; //docisnij preta
                sek2 = 0;
                proces[2] = 2;
                } 
    break;
    
    
    case 2:
            if(sek2 > 30)
                {
                PORTE.2 = 1; //wroc malym silownik grzybka
                sek2 = 0;
                proces[2] = 3;
                } 
    break;
    
    
    
    
    case 3:  
            if(sek2 > 100)
                {
                PORTC.1 = 1; //wroc duzym pobieraniem grzybka
                sek2 = 0;
                proces[2] = 4;
                } 
    break;
    
    case 4:
            if(sek2 > 100)  
                {
                PORTC.1 = 0; //pobierz grzybek
                il_grzybkow--;
                sek2 = 0;
                proces[2] = 5;
                } 
    break;
    case 5:
            if(sek2 > 100)  
                {
                PORTB.3 = 0;   //docisnij grzybek z gory
                PORTE.2 = 0;  //maly silownik grzybka na luz
                PORTC.3 = 1; //przysun silnik
                sek2 = 0;
                proces[2] = 6;
                }
    break;
    
    case 6:
            if(sek2 > 10)  //30  
                {
                PORTD.7 = 1;  //silnik dokrecajacy grzybki
                sek2 = 0;
                proces[2] = 7;
                }
        
    case 7: 
            if(sek2 > czas_silnika_dokrecajacego_grzybki)       //maks 200, min 20
                {
                PORTB.3 = 1;   //silownik dociskajacy grzybek z gory
                PORTD.7 = 0;  //silnik dokrecajacy grzybki
                PORTC.3 = 0; //odsun silnik  
                PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
                sek2 = 0;       
                proces[2] = 8;
                }
    break;
    
    case 8: 
            if(sek2 > 100)  
                {
                PORTB.7 = 0; //przestan dociskac pret  
                sek2 = 0;       
                proces[2] = 9;
                }
    break;
                   
    case 9:
            if(sek2_7s > czas_monterow)
                {
                sek2 = 0;
                proces[2] = 0;
                wynik = 1;
                if(start == 5)  //do sytuacji startowej
                    start = 6;
                }   
                                    
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
    break;
    
    case 1:
            if(sek3 > czas_na_transport_preta & PINA.4 == 0)  //czekaj az pret sie przetransportuje i na lance
                {               
                PORTB.5 = 1; //si³ownik ma³y chwytania prêcika
                sek3 = 0;
                proces[3] = 2;
                } 
    break;
    
    case 2:
            if(sek3 > 100)
                {
                PORTB.6 = 1; //silownik obrotowy na ktorym jest maly chwytajacy precik
                PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
                sek3 = 0;
                proces[3] = 3;
                } 
    break;

    case 3:
            if(sek3 > 100)  
                {
                PORTB.1 = 1; //si³ownik chwytania lancy
                PORTB.2 = 1; //wkladanie do lancy precika z grzybkiem
                sek3 = 0;
                proces[3] = 4;
                } 
    break;
    
    case 4:
            if(sek3 > 100)  
                {
                PORTB.0 = 0; //zacisniecie szczek w lancy - silownik z boku
                sek3 = 0;
                proces[3] = 5;
                } 
    break;
    
    case 5:
            if(sek3 > 100)  
                {
                PORTB.5 = 0; //si³ownik ma³y chwytania prêcika - puszczenie precika
                PORTB.1 = 0; //si³ownik chwytania lancy - puszczenie
                sek3 = 0;
                proces[3] = 6;
                }
    break;
        
    case 6: 
            if(sek3 > 100)  
                {
                PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem  
                sek3 = 0;       
                proces[3] = 7;
                }
    break;
       
    case 7:
            if(sek3 > 100)  
                {
                sek3 = 0;
                proces[3] = 8;
                } 
    break;
    
    case 8: 
            if(sek3 > 100)  
                {  
                PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
                sek3 = 0;       
                proces[3] = 9;
                }
    break;
                   
    case 9:
            if(sek3_7s > czas_monterow)
                {
                sek3 = 0;
                proces[3] = 0;
                wynik = 1;
                il_pretow_gwintowanych--;   
                licznik_pucharow++;
                wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow);
                wyswietl_ilosc_spoznien_monterzy(licznik_spoznien_monter_1,licznik_spoznien_monter_2);
                if(start == 7)  //do sytuacji startowej
                    {
                    start = 8;
                    monter_1_time = 0;
                    monter_2_time = 0;
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

void zerowanie_procesow()
{
if(skonczony_proces[0] == 1 & start == 2)
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        klej_slave = czekaj_na_klej_slave();
        if(z == 1 & klej == 1 & klej_slave == 1)
            {
            odpytaj_parametry_z_panelu();
            skonczony_proces[0] = 0;
            jest_pret_pod_czujnikami = 0;
            start = 3;
            }
        }
        
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & start == 4) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        klej_slave = czekaj_na_klej_slave();
        if(z == 1 & klej == 1 & klej_slave == 1)
            {
            odpytaj_parametry_z_panelu();
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            start = 5;
            jest_pret_pod_czujnikami = 0;
            }
        }
      
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & start == 6) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        klej_slave = czekaj_na_klej_slave();
        if(z == 1 & klej == 1 & klej_slave == 1)
            { 
            
            odpytaj_parametry_z_panelu();
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            skonczony_proces[2] = 0;
            jest_pret_pod_czujnikami = 0;
            start = 7;
            }
        }
      
if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & skonczony_proces[3] == 1 & start == 8) 
        {
        z = czekaj_na_guzik_start();
        klej = czekaj_na_klej();
        klej_slave = czekaj_na_klej_slave();
        
        if(monterzy_skonczyli == 1)
            {
            PORTE.6 = 1; //manipulator wykonal pivexin
            licznik++;
            if(licznik == 100)
                {
                PORTE.6 = 0;
                licznik = 0;
                monterzy_skonczyli = 2;
                }
            }
                                                                                                  // & PINF.4 == 0
        if(z == 1 & klej == 1 & klej_slave == 1 & monterzy_skonczyli == 2 & tasma_przejechala == 1)
            {
            odpytaj_parametry_z_panelu();       //jak il_pretow == 3
            if(il_pretow_gwintowanych > 3)
                {
                jest_pret_pod_czujnikami = 0;
                skonczony_proces[0] = 0;
                }
            if(il_pretow_gwintowanych > 1)
                skonczony_proces[2] = 0;
            if(il_pretow_gwintowanych > 0)
                {
                skonczony_proces[1] = 0;
                skonczony_proces[3] = 0; 
                monterzy_skonczyli = 0;
                monter_1_skonczyl = 0;
                monter_2_skonczyl = 0;
                monter_1_time = 0;
                monter_2_time = 0;
                }
            if(il_pretow_gwintowanych == 0)
                {
                komunikat_6_na_panel();            
                wylacz_maszyne();
                z = 0;
                start = 0;
                }
                
            lcd_clear();
            lcd_gotoxy(0,0);
            itoa(il_pretow_gwintowanych,dupa1);       
            lcd_puts(dupa1);

            }
        }
}


void kontrola_monterow()
{
if(start == 8 & monterzy_skonczyli == 0)
    {
    if(PINF.2 == 0 & monter_1_skonczyl == 0)
        {
        if(monter_1_time > czas_monterow)
           licznik_spoznien_monter_1++; 
        monter_1_skonczyl = 1;
        }

    
    if(PINF.3 == 0 & monter_2_skonczyl == 0)
        {
        if(monter_2_time > czas_monterow)
           licznik_spoznien_monter_2++;
        monter_2_skonczyl = 1;    
        }
    if(monter_1_skonczyl == 1 & monter_2_skonczyl == 1)
       monterzy_skonczyli = 1; 
    }
}


void wznowienie_pracy_po_wykonaniu_zadania()
{
if(start == 0)
         {  
         if(z == 0)
            z = czekaj_na_guzik_start();
         else
            {
            odpytaj_parametry_z_panelu();
            licznik_pucharow = 0;
            skonczony_proces[0] = 0;
            skonczony_proces[1] = 0;
            skonczony_proces[2] = 0;
            skonczony_proces[3] = 0;
            licznik_pucharow = 0;
            wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow);
            start = 1;
            
            }
         }
}

void wyswietl(int i)
{
char *dupa;

lcd_gotoxy(0,0);
itoa(i,dupa);
lcd_puts(dupa);

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

// USART1 initialization
// USART1 disabled
//UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

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

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTG Bit 4
// RD - PORTD Bit 6
// EN - PORTD Bit 7
// D4 - PORTG Bit 0
// D5 - PORTG Bit 1
// D6 - PORTG Bit 2
// D7 - PORTG Bit 3
// Characters/line: 16
lcd_init(16);

//WE
//PINA.0    czujnik ciœnienia
//PINA.1    czujnik widzenia grzybka
//PINA.2    czujnik 1 widzenia prêta gwintowanego na rynnie
//PINA.3    czujnik 2 widzenia prêta gwintowanego na rynnie
//PINA.4    czujnik od silnika grzebieni
//PINA.5    sygnal braku kleju - informacja z dozownika kleju - nie wykorzystuje
//PINA.6    sygnal gotowosci do pracy dozownika kleju
//PINA.7    wolne

//PINF.0    wlacznik tasmociagu monterow 1
//PINF.1    wlacznik tasmociagu monterow 2
//PINF.2    monter 1 wykonal
//PINF.3    monter 2 wykonal
//PINF.4    czujnik indukcyjny widzacy wieze - ju¿ go nie ma
//PINF.5    czujnik czy dokrecil grzybka
//PINF.6    wolne
//PINF.7    wolne

//WY
//PORTB.0   zaciskanie grzybka w lancy
//PORTB.1   si³ownik chwytania lancy
//PORTB.2   wkladanie do lancy precika z grzybkiem
//PORTB.3   silownik przytrzymujacy grzybka od gory
//PORTB.4   silownik pozycjonujacy preta jeszcze na zjezdzalni
//PORTB.5   si³ownik ma³y chwytania prêcika
//PORTB.6   silownik obrotowy na ktorym jest maly chwytajacy precik
//PORTB.7   silownik dociskajacy pret na grzebieniach

//PORTC.0   ciœnienie do dozownika kleju
//PORTC.1   silownik pobierania grzybow duzy
//PORTC.2   silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
//PORTC.3   silownik na ktorym jest silnik dokrecajacy grzybki
//PORTC.4   silownik trzymajcy strzelanie klejem
//PORTC.5   si³ownik 3 kolejkuj¹cy na rynnie
//PORTC.6   si³ownik 2 kolejkuj¹cy na rynnie  //na pewno podupcona kolejnoœæ
//PORTC.7   si³ownik 1 kolejkuj¹cy na rynnie

//PORTD.0   silnik przenosnika pretow 
//PORTD.1   taœmoci¹g monterów 1
//PORTD.2   kana³ 1 RS232
//PORTD.3   kana³ 1 RS232
//PORTD.4   orientator grzybkow
//PORTD.5   dozownik kleju zasilanie 220V   
//PORTD.6   taœmoci¹g monterów 2 
//PORTD.7   silnik dokrecajacy grzybki

//PORTE.0   kana³ 0 RS232
//PORTE.1   kana³ 0 RS232
//PORTE.2   silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem  
//PORTE.3   podpiêty do listwy zaworowej ale nie podpiêty ciœnieniowo
//PORTE.4   wlaczenie lania kleju
//PORTE.5   sekwencja startowa pivexin
//PORTE.6   manipulator wykonal pivexin
//PORTE.7   sygnal synchronizacji dla procesora slave
 
//PROCESY
//proces_0 - kolejkowanie prêta na zje¿d¿alni
//proces_1 - nak³adanie kleju
//proces_2 - nakrecanie grzybka
//proces_3 - pobieranie grzybka i wsadzanie do lancy


delay_ms(8000); //bo panel sie inicjalizuje
putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

//zmienne startowe
PORTB.3 = 1;   //do gory silownik przytrzumujacy grzybka od gory
start = 0;
czas_monterow = 0;
monter_1_skonczyl = 0;
monter_2_skonczyl = 0;
monterzy_skonczyli = 0;
czas_na_transport_preta = 500;
jest_pret_pod_czujnikami = 0;
stala_czasowa = 62;
il_pretow_gwintowanych = 5;  //minimum dac 5 w panelu
tasma_przejechala = 1;  //na razie bo nie jestesmy poloczeni
czas_silnika_dokrecajacego_grzybki = 65;
licznik = 0;
licznik_pucharow = 0;
licznik_spoznien_monter_1 = 0;
licznik_spoznien_monter_2 = 0;


z = 0; //do panela
d = 0;
dd = 0;
klej = 0;
klej_slave = 0;

while(start == 0)
    start = ustawienia_startowe();
    
while (1)
      { 
      sterowanie_tasmociagami_monterow();
      orientator_grzybkow();
      wznowienie_pracy_po_wykonaniu_zadania();
      procesy();
      kontrola_monterow();
      zerowanie_procesow();   
      }
}


//
//16 mhz procek
//Clock value: 15,625 kHz
//co   16mhz/15,625khz zwieksza licznik
//czyli co [1/1024]s wchodzi do tej petli  
//czyli 1024 wejscia do tej petli to 1s
//49s to okolo 7 * 430;
//434 to 7s
//zatem 1s to okolo 62 

