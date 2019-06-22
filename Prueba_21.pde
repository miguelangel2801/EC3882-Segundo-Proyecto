/////////////////////////////////////////////

import processing.serial.*;         // Importamos la libreria Serial


//Variables de impresión
// Declara e inciializza variables para graficar
int cha0, cha1, cha2, cha3, cha01=300,cha11=300, cha21=300,cha31=300,alto=1000, ancho;
float x1=10,x2=10;
String[] lines;

//Variables para adquisición de datos
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int GR=1;
//variables selectoras de niveles de amplitud
// SI se escoge arreglos con i=0 se tiene escala 1v, i=1:3v, i=2:0.3v
// Lo arreglos contienen las escalas que se usan para convertir un numero
// de una escala a otra por medio de la funcion map
int k=0;
boolean boton1presionado=false;
float SNA1 []={0, 0, 0};    //valor mas pequeño de la escala actual 
float SNA2 []={255, 255, 255};  // Valor más grande de la escala actual
float SNA3 []={10, 10, 10};  // Valor más pequeño de la escala deseada
float SNA4 []={590, 590, 590}; //Valor más grande de la escala deseada 
char SND[]={590, 408, 590};
String Amplitud[]= {"1 V", "3 V", "0.3 V"};
String Frec[]= {"0.1 s", "10ms", "1 ms"};

//Variables para selector de escala de tiempo
//Calibramos con una señal de 10Hz 
//ts[0] es la escala de 0.1s
//ts[1] e la escala de 0.01s
//ts[2] es la escala de 1ms
//float[] ts={10*92/2000,10*920/2000,10*9200/2000};
int j=1; 
float[] ts={0.35,3.5,35};
int[] tl={1998,199,19};
int[] ne={1999,200,20};//Fin de contador
//Variables de Stop
boolean stop=true;
//Variables CH1 y CH2
boolean ch1=true;
boolean ch2=true;
boolean ch3=false;
boolean ch4=false;
//boolean ch3=true;
//boolean ch4=true;
char AD1; //Arreglo donde guardaré lo correspondiente al canal analogico 1
char[] AD2=new char[2]; //Arreglo donde guardaré lo correspondiente al canal analogico 1
char Dig1;
char Dig2;
 int n; //Contador
char[] nivel=new char[2];
byte [][] datos= new byte[2000][10];
byte[] clear= {0,0,0,0};
int counter=0;
char[] ANALOGICO1=new char[2000];
char[] ANALOGICO2=new char[2000];
char[] DIGITAL1=new char[2000];
char[] DIGITAL2=new char[2000];
int flag=0;
int n1;
//PARA LAS IMAGENES
 PImage photo0;
 PImage photo1;
 PImage photo2;
 PImage photo3;
 int luz=0;
void setup()
{
  
  size(810, 600);
  alto = height;
  ancho= width;
  background(255,255,255);
  dibujo();
  
  //String portName = Serial.list()[0];   //Se abre el puerto serial el numero 3 puede variar cada vez
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 115200);  //se configura el puerto y la velocidad en baudios

}
  
void draw() {


    byte[] inBuffer = new byte[4];   // Se determinan la cantidad de bytes esperados: tamaño de buffer
      if(stop == true){  
      for(n=0;n<=ne[j];n=n+1)
       { 
       datos[n]=clear;  
       ANALOGICO1[n]=0;
       ANALOGICO2[n]=0;
   //    DIGITAL1[n]=0;
     //  DIGITAL2[n]=0;
       }
    
      
     }
      
       
        
            //Si el Buffer esta lleno
        for(counter=0;counter<=ne[j];n1=0)
          {
            while (myPort.available() > 0 && flag==0) {  // Cada vez que haya algo en el puerto se lee
            inBuffer = myPort.readBytes();  // Y se guarda en inBuffer
             myPort.readBytes(inBuffer);
            
            if (inBuffer != null) {
            
            datos[counter]=inBuffer;
          // println(binary(datos[counter][0]),binary(datos[counter][1]),binary(datos[counter][2]),binary(datos[counter][3]));
            counter=counter+1;
               
            }
            }
            }

      //Guardo ahora lo que leo en 8 bits en 2 arreglos de 16 bits (uno para cada AD)
       
      
      //Traduccion de datos 
      counter=0;
      flag=1;
      if(stop==false)n=ne[j]+1; else n=0;
     //  int p=0;
      while(n<=ne[j]){ //ciclo para Traducir protocolo de comunicacion
         
          //if (datos[n][p]==47){
                   nivel[0]=char(datos[n][1]);
                   nivel[1]=char(datos[n][2]);
                   println(int(nivel[0]),int(nivel[1]));
                  ANALOGICO1[counter]= char(int(map(abs(nivel[0]),0,255, 10, 300)));//Se convierte la data de niveles de 0 a 4095 hacia 10 a alto-10
                 // ANALOGICO1[counter]=(600- ANALOGICO1[counter]);
                  ANALOGICO2[counter]= char(int(map(abs(nivel[1]),0,255, 300, 590)));    // Se guarda en cha0 y cha1 los canales analogicos 
                  //ANALOGICO2[counter]=char(600-ANALOGICO1[counter]);
                  println(int(ANALOGICO1[counter]),int(ANALOGICO2[counter]));
                  DIGITAL1[counter]=char(datos[n][0]);
                  DIGITAL2[counter]=char(datos[n][3]);                 
                  //DIGITAL1[counter]= 600-byte(Dig1);
                  //DIGITAL2[counter]= 600-byte(Dig2); 
                  counter=counter+1;
                 // Las variables SNA1 determinan que escala de amplitud estamos usando
      n=n+1;
          // }else p++;
           //if(p>=5) p=0;
         }
               

                        //Gaficar en pantalla 
                        flag=1;
                        x1=10;
                       // x2=10+ts[j];
                       AD1=ANALOGICO1[10];
                       Dig1=DIGITAL1[10];
                       Dig2=DIGITAL2[10];
                        dibujo();
                        int cursor=0;
                        
             while(cursor<= tl[j])
             {
                  
                       //if (flag de stop == 0) cursor=tl[j];
                      // si se presiona el boton stop no imprimie si se presiona otra vez sigue imprimiendo despues de refrescar
                       stroke(#FF00FF); //Imprime linea magenta.
                       if(GR==0 && ch1 != false && (ANALOGICO1[cursor]>=10 && ANALOGICO1[cursor]<=alto-10) ) line(x1, ANALOGICO1[cursor],x1+ts[j], ANALOGICO1[cursor+1]);  //Si se presiona ch1 se muestra o se oculta la señal despues de refrescar o
                                                                                                    //point(x1,ANALOGICO1[cursor]);
                                                                                                    //si la señal se va a salir de la pantalla no la imprime
                       //                                                                           // La señal se imprime como lineas que unen dos puntos
                       stroke(255, 255, 0); //Imprime linea amarilla
                       if(GR==0 && ch2 != false && (ANALOGICO2[cursor]>=10 && ANALOGICO2[cursor]<=alto-10) ) line(x1, ANALOGICO2[cursor], x1+ts[j], ANALOGICO2[cursor+1]);
                       
                      
                      
                       x1=x1+ts[j];  //ts es la variable que determina que escala de tiemp estamos usando
                      // x2=x1+ts[j]; //0.7 wscala de 0.1s
                                      
                                 
               
                    cursor=cursor+1;
                    
       }
  
      flag=0;
//x2=10+ts[j];
}
    
     
     


//Funciones usadas en Draw

void mouseClicked()  // Cada vez que se hace click se llama esta funcion y se evalua que boton fue presionaso y se despliega su funconalidad
{
  //Boton1    
  if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,35,85)==true)
  {
   if(GR==0) GR=1;
   else GR=0;
       dibujo(); 
  }
   if(buttomPressed(mouseX, mouseY,ancho-50-35,ancho-50+35,195,245)==true)
  {
   if(stop==true){
     stop=false;}else if(stop==false){
                         stop=true;
                         x1=10;
                         x2=10;
                         dibujo();
                          }                      
  }
}

// Funcion encargada de todos los objetos mostrados en pantalla
void dibujo()
{
  clear();
  background(0);
  stroke(255, 255, 255);
  if(GR==0){
  line(ancho-100, 10, ancho-100, alto-10); //Linea vertical derecha
  line(10, 10, 10, alto-10); //Linea vertical izquierda
  line(10, 10, ancho-100, 10); // Linea horizontal izquierda
  line(10, alto-10, ancho-100, alto-10); //Linea Horzontal derecha
 //Lineas de escala
    stroke(0, 255, 255); 
    for(int i = 1; i<=7; i++)
    {
        line(10, 10+72.5*i, ancho-100, 10+72.5*i);
    }
    for(int i = 1; i<=9; i++)
    {
        line(10+70*i, 10, 10+70*i, alto-10);
    }
      
      //Lineas centrales 
   stroke(255,255,255);
   line(10+350, 10, 10+350, alto-10);
   line(10, 10+290, ancho-100, 10+290);
   if(stop==true){
   //fill(#FF0000);
     boton(ancho-50,210,"STOP", ancho-65, 215);
 
   }
   else  {
   //  fill(#00FF00);
     boton(ancho-50,210,"PLAY", ancho-65, 215);
   
   }
}
  else if (GR==1)
  {
    clear();
    background(#FFFFFF);
    stroke(#1DC11E);
    fill(#AF1F12);
    //ellipse(ancho/2-100,300,300,300);

 switch(Dig1){
   case 8:
   
   photo0 = loadImage("open.JPG");
    image(photo0, 0, 0);
   break;
   default:
   
   photo1 = loadImage("closed.JPG");
   image(photo1, 0, 0);
   break;
 }
  if(AD1>=250 && luz==1){
    luz=0;
   
  }else if(AD1>=250 && luz==0){
    luz=1;
  }
  switch(luz){
  case 0:
  photo2 = loadImage("on.JPG");
   image(photo2, 500, 0);
  break;
  case 1:
  photo3 = loadImage("off.JPG");
   image(photo3, 500, 0);
  break;
  default:
  break;
  }
  //image(photo2, 500, 0);
  
 
//dibujo();


  

    
  }
  


  //for(int i = 0; i<div; i++)
  //{
  //  line(ini, ((alto-30)/(div-1))*i+10, ini+10, ((alto-30)/(div-1))*i+10);
  //  text(5-i/2.0+"v", 0, ((alto-30)/(div-1))*i+15);
  //  line(((ancho-35)/(div-1))*i+25, alto-15, ((ancho-35)/(div-1))*i+25, alto-25);
  //  text(/*nf((ancho-30)/(div-1)*0.03*i, 1, 2)*/(i*2)+"s", ((ancho-35)/(div-1))*i+15, alto-0);
  //}
  stroke(0);
  fill(0,116,255);
  rect(ancho-50,50,84, 24);
  if(GR==0){
  
  boton(ancho-50,50,"CASA",ancho-68,55);
  }
  else if(GR==1)boton(ancho-50,50,"SEÑAL",ancho-68,55);
  
}



boolean buttomPressed(int mousex , int mousey, int mx, int x, int my, int y){ // Esta funcion evalua en qué boton te paraste al momento de clickear
   if((mousey>=my && mousey<= y) && (mousex>=mx && mousex<=x)) return true;  
     else return false;
}




void boton(int x, int y, String texto, int xt, int yt)  //dibujar un bonton
{
  stroke(0);
  fill(0,116,255);
  ellipse(x,y,70,70);
  fill(255);
  textSize(12);
  text(texto,xt,yt);
}
