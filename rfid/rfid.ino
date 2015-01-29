/*
 * MFRC522 - Library to use ARDUINO RFID MODULE KIT 13.56 MHZ WITH TAGS SPI W AND R BY COOQROBOT.
 * The library file MFRC522.h has a wealth of useful info. Please read it.
 * The functions are documented in MFRC522.cpp.
 *
 * Based on code Dr.Leong   ( WWW.B2CQSHOP.COM )
 * Created by Miguel Balboa (circuitito.com), Jan, 2012.
 * Rewritten by Søren Thing Andersen (access.thing.dk), fall of 2013 (Translation to English, refactored, comments, anti collision, cascade levels.)
 * Released into the public domain.
 *
 * Sample program showing how to read data from a PICC using a MFRC522 reader on the Arduino SPI interface.
 *----------------------------------------------------------------------------- empty_skull
 * Aggiunti pin per arduino Mega
 * add pin configuration for arduino mega
 * http://mac86project.altervista.org/
 ----------------------------------------------------------------------------- Nicola Coppola
 * Pin layout should be as follows:
 * Signal     Pin              Pin               Pin
 *            Arduino Uno      Arduino Mega      MFRC522 board
 * ------------------------------------------------------------
 * Reset      9                5                 RST
 * SPI SS     10               53                SDA
 * SPI MOSI   11               51                MOSI
 * SPI MISO   12               50                MISO
 * SPI SCK    13               52                SCK
 *
 * The reader can be found on eBay for around 5 dollars. Search for "mf-rc522" on ebay.com.
 */

#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance.

byte readCard[4];
const int servo_signal = 6;
int open = 0;

void close_lock()
{
  // Move away from the button, I.E. turn to angle 30 degrees.
  for (int i = 0; i < 100; i++)
  {
    digitalWrite(servo_signal, HIGH);
    delayMicroseconds(2100);
    digitalWrite(servo_signal, LOW);
    delayMicroseconds(17900);
  }
}

void open_lock()
{
  // Move away from the button, I.E. turn to angle 30 degrees.
  for (int i = 0; i < 100; i++)
  {
    digitalWrite(servo_signal, HIGH);
    delayMicroseconds(600);
    digitalWrite(servo_signal, LOW);
    delayMicroseconds(19400);
  }
}
void setup() {
  pinMode(servo_signal, OUTPUT); 

  
  Serial.begin(9600); // Initialize serial communications with the PC
  SPI.begin();      // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522 card
  Serial.println("Scan PICC to see UID and type...");
  close_lock();   // On power up, move the servo to the right position.
}

void change()
{
  if (open == 0)
  {
    Serial.println("Door is closed, opening door\n");
    open_lock();
    open = 1;
    delay(2000);
  }
  else if (open == 1)
  {
    Serial.println("Door is open, closing door\n");
    close_lock();
    open = 0;
    delay(2000);
  }
}
void loop() {
  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }

  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  // There are Mifare PICCs which have 4 byte or 7 byte UID care if you use 7 byte PICC
  // I think we should assume every PICC as they have 4 byte UID
  // Until we support 7 byte PICCs
  Serial.println("Scanned PICC's UID:");
  for (int i = 0; i < 4; i++) {  // 
    readCard[i] = mfrc522.uid.uidByte[i];
    Serial.print(readCard[i], HEX);
    if (i == 3) change();
  }

  // Dump debug info about the card. PICC_HaltA() is automatically called.
  //mfrc522.PICC_DumpToSerial(&(mfrc522.uid));
}
