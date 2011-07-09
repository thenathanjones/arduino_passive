#include <WProgram.h>
#include <NECIRrcv.h>

#define IR_PIN 2
#define UP_PIN 6
#define DOWN_PIN 7

#define MOVEMENT_TIME 300

#define VOLUME_UP 0xF609FD02
#define VOLUME_UP2 0xFF00FD02
#define VOLUME_DOWN 0xFE01FD02
#define VOLUME_DOWN2 0xFC03FD02
#define CHANGE_INPUT 0xFD02FD02

NECIRrcv ir(IR_PIN);

unsigned long ircode;

void volumeUp()
{
  digitalWrite(UP_PIN, LOW);
  delay(MOVEMENT_TIME);
  digitalWrite(UP_PIN, HIGH);
}

void volumeDown()
{
  digitalWrite(DOWN_PIN, LOW);
  delay(MOVEMENT_TIME);
  digitalWrite(DOWN_PIN, HIGH);
}

void toggleOutput()
{
  Serial.println("Switch it around!");
}

void handleUnknownCode()
{
  Serial.print("WTF was that? 0x");
  Serial.println(ircode, HEX);
}

void setup()
{
  Serial.begin(9600) ;
  Serial.println("Passive Attenuator Control") ;
  
  pinMode(UP_PIN, OUTPUT);
  pinMode(DOWN_PIN, OUTPUT);
  
  digitalWrite(UP_PIN, HIGH);
  digitalWrite(DOWN_PIN, HIGH);
  
  ir.begin() ;
}

void loop()
{
  while (ir.available()) {
    ircode = ir.read() ;
    
    switch (ircode)
    {
      case VOLUME_UP:
      case VOLUME_UP2:
      volumeUp();
      break;
      case VOLUME_DOWN:
      case VOLUME_DOWN2:
      volumeDown();
      break;
      case CHANGE_INPUT:
      toggleOutput();
      break;
      default:
      handleUnknownCode();
      break;
    }
  }
}
