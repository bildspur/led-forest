class ExampleScene extends Scene
{
  // Der easing faktor. Je höher, desto schneller verändert die LED ihre Farbe.
  // 1 => sofortige änderung
  // 0.5 => in 2 frames
  // 0.25 => in 4 frames
  // Formel: 1 / fadeSpeed = frames bis zur totalen Änderung.
  float fadeSpeed = 0.01666; // 60 frames
  
  // Hue Wert, den wir speichern. Diesen passen wir bei jedem Update an.
  int h = 0;

  /* 
   * Update wird 60 Mal in der Sekunde aufgerufen.
   */
  public void update()
  {
    // Um nicht alle 60 Mal etwas zu verändern (würde zu stark blinken), skippen wir immer 60 Frames.
    // % bedeuted Modulo und gibt den Rest einer Division zurück. Somit wird immer dann ein update gemacht,
    // wenn die frameCount Zahl / 60 den Rest 0 ergiebt (also durch 60 teilbar ist). Somit wird nur jede Sekunde
    // ein update gemacht.
    if (frameCount % 60 != 0)
      return; // beendet die Momentane Funktion

    // Der Folgende Teil wird nur jede Sekunde ausgeführt:

    /*
     * tubes: List die alle LED Tubes beinhaltet.
     * Jede "tube" beinhaltet eine Liste von LEDs.
     * Jede LED hat eine "FadeColor" welche die Farbe (HSB Modus) bestimmt.
     * Die Farbe kann über "fade(farbe, easing)" gesetzt werden.
     * Oder auch nur die jeweiligen Komponenten (H, S, B): fadeH, fadeS, fadeB.
     */

    // Um jede LED zu verändern, muss über alle Tubes iteriert werden:
    for (int j = 0; j < tubes.size(); j++)
    {
      // j => index der momentanen Tube. Damit kann man die Tube aus der Liste holen:
      Tube t =  tubes.get(j);
      
      // Nun iterieren wir über jede LED der momentanen Tube t.
      for (int i = 0; i < t.leds.size(); i++)
      {
        // i => index der momentanen LED.
        LED led = t.leds.get(i);
        
        // um die color komponenten H und S langsam zu verändern, führen wir die zwei Funktionen aus:
        led.c.fadeH((h + ((360 / tubes.size()) * j)) % 360, fadeSpeed);
        
        // um einen Sättigungsverlauf in den LED Stab zu bringen, 
        // passen wir die Sättigung so an, dass der Index der LED
        // die Settigung beinflusst. (je höher der index, desto weniger sättigung).
        led.c.fadeS((4*i), fadeSpeed);
      }
    }
    
    // Anpassen des Hue Wert in 50er Schritten:
    h += 300;
    
    // sofern h zu gross wird, müssen wir es wieder auf 0 zurücksetzen.
    if(h > 360)
    {
       h = h % 360; // wir übernehmen den rest der divison. Somit erhalten wir bei 400 / 360 => 40
    }
  }
}