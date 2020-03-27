#define MAX 16

sbit LCD_RS at PORTC0_bit;
sbit LCD_EN at PORTC1_bit;
sbit LCD_D4 at PORTC4_bit;
sbit LCD_D5 at PORTC5_bit;
sbit LCD_D6 at PORTC6_bit;
sbit LCD_D7 at PORTC7_bit;

sbit LCD_RS_Direction at DDC0_bit;
sbit LCD_EN_Direction at DDC2_bit;
sbit LCD_D4_Direction at DDC4_bit;
sbit LCD_D5_Direction at DDC5_bit;
sbit LCD_D6_Direction at DDC6_bit;
sbit LCD_D7_Direction at DDC7_bit;


int value=0, ms=0, n =0;
char adc_l=0, adc_h=0;

void display(char n)
{
 DDRD = 0b11111111;
 PORTD &= 0b00000000;

switch(n)
{
case 0:PORTD|=0b00111111;break;               //codifica reprezentarea cifrei 0
case 1:PORTD|=0b00000110;break;               //codifica reprezentarea cifrei 1
case 2:PORTD|=0b01011011;break;               //codifica reprezentarea cifrei 2
case 3:PORTD|=0b01001111;break;               //codifica reprezentarea cifrei 3
case 4:PORTD|=0b01100110;break;               //codifica reprezentarea cifrei 4
case 5:PORTD|=0b01101101;break;               //codifica reprezentarea cifrei 5
case 6:PORTD|=0b01111101;break;               //codifica reprezentarea cifrei 6
}
}

void init_adc()
{
     ADMUX = 0b01000000;            //Referinta - AVCC
     ADCSRA = 0b10000111;           //Activare ADC; Prescaler = 128;
}


int readADC (char ch){
    ADMUX &= 0b11100000;             //Reseteazã canalul de conversie
    ADMUX |= ch;                     //Seteazã canalul conversiei
    ADCSRA |= (1<<6);                //Începe conversia
 while(ADCSRA & (1<<6));             //Asteaptã finalizarea conversiei
    adc_l = ADCL;
    adc_h = ADCH;
 return ((adc_h << 8) | adc_l);
}


void init_timer()
{
     SREG = 1<<7;                  //Global Interrupt Enable
     TCCR0 = 0b00001011;           //CTC(Clear Timer on Compare Match)-3,6
     TCNT0 = 0;                    //se reseteaza la 0 registrul de numarare
     OCR0 = 125;                   //valoarea la care se reseteaza TCNT0 la egalitatea dintre TCNT0 si OCR0
     TIMSK |= 0b00000010;          //daca TCNT0=OCR0, se genereaza o intrerupere
}


      int pot = 99;
void Timer0_OC_ISR() iv IVT_ADDR_TIMER0_COMP {
  if (ms == pot)
  {
    n++;
    switch(n){
      case 1:{ PORTA=0b00010000;
               pot=readADC(6)/4;
               break;
              }
      case 2:{ PORTA=0b00100000;
               pot=readADC(6)/4;
               break;
              }
      case 3:{ PORTA=0b00001000;
               pot=readADC(6)/4;
               break;
              }
      case 4:{ PORTA=0b10000000;
               pot=readADC(6)/4;
               n=0;
               break;
              }
  }
  ms = 0;
  }
  else ms++;
}


void LCD0()
{      int   i=0;
      Lcd_Init();                        // Initializeaza LCD
      Lcd_Cmd(_LCD_CLEAR);               // Clear display
      Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
      Lcd_Out(1,1,"Joc de") ;
      Lcd_Out(2,5,"zaruri") ;

      for (i=0;i<=4;i++)
      {
       Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);
        Delay_ms(100);
      }
      Delay_ms(300);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Cmd(_LCD_CURSOR_OFF);

      for (i=0;i<=24;i++)
      {
         Lcd_Out(1,4,"Pe locuri,fiti gata...");
         Lcd_Cmd(_LCD_SHIFT_LEFT);
          Delay_ms(7);
      }
     Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(2,5,"Start!!") ;
      Delay_ms(300);
      Lcd_Cmd(_LCD_CLEAR);
}

void LCD1(int crt,int nr1)
{
   char txt[2];
    txt[0] = nr1 / 10 % 10 + '0';
    txt[1] = nr1 % 10 + '0';
    txt[2] = '\0';
  if (crt == 1){
  Lcd_Cmd(_LCD_CLEAR);
  //Lcd_Out(1,1,"Este randul");
  Lcd_Out(1,1,"Jucatorul #1");
  Delay_ms(150);
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(1,1,"Punctaj #1: ");
  Lcd_Out(2,9,txt);
  Delay_ms(300);
  }
  else if (crt == 2){
   Lcd_Cmd(_LCD_CLEAR);
  //Lcd_Out(1,1,"Este randul");
  Lcd_Out(1,1,"Jucatorul #2");
  Delay_ms(150);
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(1,1,"Punctaj #2: ");
  Lcd_Out(2,9,txt);
  Delay_ms(300);
  }
}

void LCD2(int numar){
     if (numar == 1)
     {
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"A castigat #1");
        Delay_ms(300);
     }
     if (numar == 2)
     {
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"A castigat #2");
        Delay_ms(300);
     }
}

int arunc(int numar)
{
       int zar=0;
       int ms = 0;
      zar = (rand()% 6) + 1;          //calculeaza numarul 'la intamplare'  cuprins intre [1,6]
      numar = numar+zar;
      display(zar);
       if (zar == 6) {
          init_timer();
          init_adc();
          DDRA = 0b10111000;
          SREG |= 1<<7;
          }
      return(numar);
}


     int nr1=0;
     int nr2=0;
     int i = 0;

void main()
{
         int starePB0=0;
         int starePB1=0;
         int starePB2=0;
         int submit = 0;

     DDRC = 0b11111111;    //seteazã pinii de iesire
     DDRB = 0b11110000;    //seteazã pinii de iesire
     PORTB = 0b00000000;   //seteaza nivelul logic al pinilor PB0-PB2 cu rezistente de pull-up

      display(0);
      LCD0();
      delay_ms(90);

     for(;;)
      {
      if  ((nr1 < MAX) && (nr2 < MAX))
      {
      if (PINB & (1<<2))
      {
      if (PINB & (1<<1))
      {
           if (starePB1==0)
           {
              starePB1=1;
              PORTB ^= (1<<7);
              nr1=arunc(nr1);
              LCD1(1,nr1);
           }
      }else
      starePB1 = 0;
      
           if (starePB2 == 0)
           {
            starePB2 = 1;
            PORTB ^= (1<<7);
            submit = 1;
           }
      }
        else 
        {
          starePB2=0;
        }


      if (PINB & (1<<2))
      {
      if (PINB & (1<<0))
      {
        if (starePB0 == 0)
        {
           starePB0 = 1;
           PORTB |= (1<<7);
           nr2 = arunc(nr2);
           LCD1(2,nr2);
        }
       }
       else starePB0 = 0;
       
       if (starePB2 == 0)
           {
            starePB2 = 1;
            PORTB ^= (1<<7);
            submit = 0;
           }
      }
        else
        {
          starePB2=0;
          PORTB &= (1<<2);
        }
 }
  else 
       {
         if ((nr1 == MAX) && (nr2 != MAX))
            LCD2(1);
         if ((nr1 != MAX) && (nr2 == MAX))
            LCD2(2);
         if ((nr1 == MAX) && (nr2 == MAX))
         {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Egalitate!");
         }
       }
  }

}