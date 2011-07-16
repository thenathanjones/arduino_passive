#include <WProgram.h>
#include <NECIRrcv.h>

#define IR_PIN 4
#define UP_PIN 6
#define DOWN_PIN 7

#define MOVEMENT_TIME 300

#define VOLUME_UP 0xE41B6086
#define VOLUME_DOWN 0xE21D6086
#define CHANGE_INPUT 0xFD02FD02

NECIRrcv ir(IR_PIN);

unsigned long irCode;

void volumeUp()
{
  Serial.println("Volume Up");
  digitalWrite(UP_PIN, LOW);
  delay(MOVEMENT_TIME);
  digitalWrite(UP_PIN, HIGH);
}

void volumeDown()
{
  Serial.println("Volume Down");
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
  Serial.println(irCode, HEX);
}

void setupMotorControl()
{
  pinMode(UP_PIN, OUTPUT);
  pinMode(DOWN_PIN, OUTPUT);
  digitalWrite(UP_PIN, HIGH);
  digitalWrite(DOWN_PIN, HIGH);
}

void setupIR()
{
  ir.begin();
}

void setup()
{
  Serial.begin(9600) ;
  Serial.println("Passive Attenuator Control") ;
  
  setupMotorControl();
  
  setupIR();
}

void loop()
{
  while (ir.available()) {
    irCode = ir.read() ;
    
    switch (irCode)
    {
      case VOLUME_UP:
      volumeUp();
      break;
      case VOLUME_DOWN:
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
