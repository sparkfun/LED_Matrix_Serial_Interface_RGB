// Writing to the RGB Serial Backpack Matrix from SparkFun Electronics
// by Ryan Owens
// Copyright SparkFun Electronics

//Define the "Normal" Colors
#define BLACK  0
#define RED  0xE0
#define GREEN  0x1C
#define BLUE  0x03
#define ORANGE  RED|GREEN
#define MAGENTA  RED|BLUE
#define TEAL  BLUE|GREEN
#define WHITE (RED|GREEN|BLUE)-0xA0

//Define the SPI Pin Numbers
#define DATAOUT 11//MOSI
#define DATAIN  12//MISO 
#define SPICLOCK  13//sck
#define SLAVESELECT 10//ss

//Define the variables we'll need later in the program
char color_buffer [64]; 

void setup() 
{  
  //SPI Bus setup
  SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR1);	//Enable SPI HW, Master Mode, divide clock by 16    //SPI Bus setup
  
  //Set the pin modes for the RGB matrix
  pinMode(DATAOUT, OUTPUT);
  pinMode(DATAIN, INPUT);
  pinMode(SPICLOCK,OUTPUT);
  pinMode(SLAVESELECT,OUTPUT);
  
  //Make sure the RGB matrix is deactivated
  digitalWrite(SLAVESELECT,HIGH); 

} 
 
void loop() 
{
  //Load colors into the first row color buffer array. 
  //This will be the array of colors sent to the RGB matrix.
  color_buffer[0]=BLACK;
  color_buffer[1]=RED;
  color_buffer[2]=GREEN;
  color_buffer[3]=BLUE;
  color_buffer[4]=ORANGE;
  color_buffer[5]=MAGENTA;
  color_buffer[6]=TEAL;
  color_buffer[7]=WHITE;
  
  //Activate the RGB Matrix
  digitalWrite(SLAVESELECT, LOW);
  //Send the color buffer to the RGB Matrix
  for(int LED=0; LED<64; LED++){
    spi_transfer(color_buffer[LED]);
  }
  //Deactivate the RGB matrix.
  digitalWrite(SLAVESELECT, HIGH);
  while(1);
  //delay(100); // allow some time for the Serial data to be sent 
} 

//Use this command to send a single color value to the RGB matrix.
//NOTE: You must send 64 color values to the RGB matrix before it displays an image!
char spi_transfer(volatile char data)
{
  SPDR = data;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait for the end of the transmission
  {
  };
  return SPDR;                    // return the received byte
}
