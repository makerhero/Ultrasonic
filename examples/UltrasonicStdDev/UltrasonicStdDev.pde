/*
 * HCSR04Ultrasonic/examples/UltrasonicStdDev/UltrasonicStdDev.pde
 *
 * SVN Keywords
 * ----------------------------------
 * $Author: cnobile $
 * $Date: 2011-09-17 02:43:12 -0400 (Sat, 17 Sep 2011) $
 * $Revision: 29 $
 * ----------------------------------
 */

#include <Ultrasonic.h>

#define TRIGGER_PIN    12
#define ECHO_PIN       13

#define NUMBER_BUFFERS 3
#define BUFFER_SIZE    3

#define BUFFER_01      0
#define BUFFER_02      1
#define BUFFER_03      2

Ultrasonic ultrasonic(TRIGGER_PIN, ECHO_PIN);
bool disableSD = false;

// Only run 50 time so we can reburn the code easily.
#define CYCLES         50
size_t count = 0;


void setup()
  {
  Serial.begin(9600);
  Serial.println("Starting Ultasonic Test using standard deviation ...");

  /*
   * If NUMBER_BUFFERS is 2 then it must be followed by two size variables
   * one for each buffer to be created. The size variables do not need to be
   * the same value.
   *
   * Example: ultrasonic.sampleCreate(3, 20, 10, 3) is valid.
   *
   * Note: The minimum size for any buffer is 2. Using less than 2 will waist
   *       resources and the buffer will be ignored.
   */
  if(!ultrasonic.sampleCreate(NUMBER_BUFFERS, BUFFER_SIZE, BUFFER_SIZE,
      BUFFER_SIZE))
    {
    disableSD = true;
    Serial.println("Could not allocate memory.");
    }
  }

void loop()
  {
  float cmMsec, inMsec;
  float msStdDev, cmStdDev, inStdDev;
  long microsec = ultrasonic.timing();

  cmMsec = ultrasonic.convert(microsec, Ultrasonic::CM);
  inMsec = ultrasonic.convert(microsec, Ultrasonic::IN);

  if(count < CYCLES)
    {
    if(disableSD)
      {
      Serial.print("CM: ");
      Serial.print(cmMsec);
      Serial.print(", IN: ");
      Serial.println(inMsec);
      }
    else
      {
      msStdDev = ultrasonic.unbiasedStdDev((float) microsec, BUFFER_01);
      cmStdDev = ultrasonic.unbiasedStdDev(cmMsec, BUFFER_02);
      inStdDev = ultrasonic.unbiasedStdDev(inMsec, BUFFER_03);
      Serial.print(count + 1);
      Serial.print(") MS: ");
      Serial.print(microsec);
      Serial.print(", SD: ");
      Serial.print(msStdDev);
      Serial.print(", CM: ");
      Serial.print(cmMsec);
      Serial.print(", SD: ");
      Serial.print(cmStdDev, 2);
      Serial.print(", IN: ");
      Serial.print(inMsec);
      Serial.print(", SD: ");
      Serial.println(inStdDev, 2);
      }

    count++;
    }

  delay(1000);
  }
