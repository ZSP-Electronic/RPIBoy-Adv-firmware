#include <USBComposite.h>

#define JSX PB1
#define JSY PB0
#define JCX
#define JCY

#define LOAD    PA5
#define SEROUT  PA3
//#define HCCLK   PA4

USBXBox360 XBox360;

uint8_t butDataArray[8] = {0, 0, 0, 0, 0, 0, 0, 0};
int16_t joySX = 0;
int16_t joySY = 0;

void setup() {
  XBox360.begin();
  //Serial.begin(9600);
  pinMode(JSX, INPUT_ANALOG);
  pinMode(JSY, INPUT_ANALOG);

  pinMode(LOAD, OUTPUT);
  pinMode(HCCLK, OUTPUT);
  pinMode(SEROUT, INPUT);
  delay(1000);

  XBox360.setManualReportMode(1);
}

void loop() {
  joySX = map(analogRead(JSX), 0, 4095, -32767, 32767);
  joySY = map(analogRead(JSY), 0, 4095, -32767, 32767);

  //joySX = analogRead(JSX);
  //joySY = analogRead(JSY);

  updateBut();

  XBox360.X(joySX);
  XBox360.Y(joySY);

/*
  Serial.print(joySX);
  Serial.print(" ");
  Serial.print(joySY);
  Serial.print("\t");
  */

  for (int i = 0; i < 8; i++)
  {
    XBox360.button(i+5, butDataArray[i]);
    /*
    Serial.print(butDataArray[i]);
    Serial.print(" ");
    */
  }
  //Serial.println();

  XBox360.send();
}

/* Function to run the update for the buttons from the 74HC165 */
void updateBut(void)
{
  int i, x;

  digitalWrite(LOAD, LOW);    //Pull Load input LOW to load H into Q7
  for (x = 0; x < 10; x++) {} //Wait 10 cycles
  digitalWrite(LOAD, HIGH);    //Pull Load HIGH

  //Read pin then AND or OR with MSB
  butDataArray[0] =  !digitalRead(SEROUT);

  digitalWrite(HCCLK, LOW);  //Pull CLK Low

  for (i = 1; i < 9; i++)
  {
    digitalWrite(HCCLK, HIGH);  //Pull CLK HIGH
    for (x = 0; x < 10; x++) {} //Wait 10 cycles
    digitalWrite(HCCLK, LOW);  //Pull CLK LOW
    //Read pin then AND or OR
    butDataArray[i] = !digitalRead(SEROUT);
  }
}
