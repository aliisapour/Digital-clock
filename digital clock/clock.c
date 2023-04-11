#include <mega32.h>
#include <delay.h>
#include <lcd.h>
#include <stdlib.h>

// hex porta ra baraye lcd tarif mikonim
#asm
.equ __lcd_port=0x1B;  
#endasm

unsigned char k;
void main(void){



char str_second[1],str_minute[1],str_hour[1],str_sadsecond[1];
int second,minute,hour; 
int counter; 
int TIM;  
int ERROR=70;
int adad=0; 
int shomarande;       
int timer=0;
int sadsecond ;
        
lcd_init(16);
lcd_gotoxy(4,0);
lcd_puts("HH MM SS");
     

DDRB = 0XFF;
DDRD = 0XF0;
PORTD.0 = 1;
PORTD.1 = 1;
PORTD.2 = 1;


U:{if(timer==1){
lcd_clear();
          
lcd_gotoxy(3,0);
lcd_puts("CHRONOMETER");
     
   second=0;
       while(1){             
sadsecond++;

 if(sadsecond==10){sadsecond=0;second++;}
if(second==60){second=0;minute++;}
if(minute==60){minute=0;hour++;}
if(hour==24){hour=0;}
//////////////////////////////////////
itoa(hour,str_hour);
lcd_gotoxy(2,1);
if(hour<10)
lcd_puts("0");
lcd_puts(str_hour);
lcd_putchar(' ');
lcd_gotoxy(4,1);
lcd_putchar(':');
///////////////////////////////////////
itoa(minute,str_minute);
lcd_gotoxy(5,1);
if(minute<10)
lcd_puts("0");
lcd_puts(str_minute);
lcd_putchar(' ');
lcd_gotoxy(7,1);
lcd_putchar(':');
///////////////////////////////////////
itoa(second,str_second);
lcd_gotoxy(8,1);
if(second<10)
lcd_puts("0");
lcd_puts(str_second);
lcd_putchar(' ');
lcd_gotoxy(10,1);
lcd_putchar(':');

//////////////////////////////////////
  itoa(sadsecond,str_sadsecond);
lcd_gotoxy(11,1);
if(sadsecond<10)
lcd_puts("0");
lcd_puts(str_sadsecond);
lcd_putchar(' ');

 delay_ms(100); 
 }
        }
      } 


A:{
lcd_gotoxy(4,0);
lcd_puts("HH MM SS");
       
counter=0;
while(1) {

if (ERROR==1){ERROR=70;counter=2;} 
if (ERROR==2){ERROR=70;counter=4;}
k = 10;
PORTD = 0XF0;
//ROW1
PORTD.4 = 0;
delay_ms(5);
if(PIND.0 == 0){k = 1;while(PIND.0 == 0);}
if(PIND.1 == 0){k = 2;while(PIND.1 == 0);}
if(PIND.2 == 0){k = 3;while(PIND.2 == 0);}
PORTD.4 = 1;
//ROW2
PORTD.5 = 0;
delay_ms(5);
if(PIND.0 == 0){k = 4;while(PIND.0 == 0);}
if(PIND.1 == 0){k = 5;while(PIND.1 == 0);}
if(PIND.2 == 0){k = 6;while(PIND.2 == 0);}
PORTD.5 = 1;
//ROW3
PORTD.6 = 0;
delay_ms(5);
if(PIND.0 == 0){k = 7;while(PIND.0 == 0);}
if(PIND.1 == 0){k = 8;while(PIND.1 == 0);}
if(PIND.2 == 0){k = 9;while(PIND.2 == 0);}
PORTD.6 = 1;
//ROW4
PORTD.7 = 0;
delay_ms(5);
if(PIND.0 == 0){k = 11;while(PIND.0 == 0);}
if(PIND.1 == 0){k = 0;while(PIND.1 == 0);}    
if(PIND.2 == 0){k = 12;while(PIND.2 == 0);}          
PORTD.7 = 1;
if(k != 10){ if (k!=11){TIM = k; }
if (k==11){timer=1;sadsecond=0;goto U;}
if(k==12){lcd_clear();goto A;}
             
PORTB=k;
counter=counter+1;
if(counter==1){hour=TIM;};
if(counter==2){hour=hour*10+TIM;} ; 
itoa(hour,str_hour);
lcd_gotoxy(4,1); 
lcd_puts(str_hour);
lcd_putchar(' ');
lcd_gotoxy(6,1);
lcd_putchar(':');

if(counter==3){minute=TIM;} ;
if(counter==4){minute=10*minute+TIM;};
itoa(minute,str_minute);
lcd_gotoxy(7,1);
lcd_puts(str_minute);
lcd_putchar(' ');
lcd_gotoxy(9,1);
lcd_putchar(':');
               
if(counter==5){second=TIM;};
if(counter==6){second=second*10+TIM;break;};
itoa(second,str_second);
lcd_gotoxy(10,1);
lcd_puts(str_second);
lcd_putchar(' ');
lcd_gotoxy(9,1);
lcd_putchar(':');
             
};
          
}
}  
          
if(hour>24){PORTB=14;goto A;}
if(minute>59){ERROR=1;PORTB=14;goto A;} 
if(second>59){ERROR=2;PORTB=14;goto A;}
             
PORTB=13;
 


   DDRC.1=0xFF ;
   DDRC.0=0xFF ;
                 
while(1){
         
second++;

if(second==60){second=0;minute++;}
if(minute==60){minute=0;hour++;}
if(hour==24){hour=0;}

if(second==0&minute==15){PORTC.1=1;shomarande=0;goto D;}
if(second==0&minute==30){PORTC.1=1;shomarande=0;goto D;}
if(second==0&minute==45){PORTC.1=1;shomarande=0;goto D;}
if(second==0&minute==0){PORTC.1=0;PORTC.0=1;PORTC.1=1;shomarande=0;goto D;}

D:{shomarande++;}
if (shomarande == 3){PORTC.0=0;PORTC.1=0;}


//////////////////////////////////////
itoa(hour,str_hour);
lcd_gotoxy(4,1);
if(hour<10)
lcd_puts("0");
lcd_puts(str_hour);
lcd_putchar(' ');
lcd_gotoxy(6,1);
lcd_putchar(':');
///////////////////////////////////////
itoa(minute,str_minute);
lcd_gotoxy(7,1);
if(minute<10)
lcd_puts("0");
lcd_puts(str_minute);
lcd_putchar(' ');
lcd_gotoxy(9,1);
lcd_putchar(':');
///////////////////////////////////////
itoa(second,str_second);
lcd_gotoxy(10,1);
if(second<10)
lcd_puts("0");
lcd_puts(str_second);
lcd_putchar(' ');
lcd_gotoxy(9,1);
lcd_putchar(':');
//////////////////////////////////////

 delay_ms(1000);
  



    }   
      
     
    } 




