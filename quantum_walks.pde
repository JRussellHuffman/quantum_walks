String[] quantumCorpusLoad;
String[] finalQuantumArray;
color black = color(0);
color white = color(255);
int canvasWidth = 2000;
int canvasHeight = 2000;
int startingX;
int startingY;
int shots = 8192; //max is 8192
int lineSize = 20;
Boolean simulate = false; // true for simulated data. false for real data
String dataSource = "ibmq_athens";

int activeLine = 0;


void setup() {
  frameRate(120);
  size(2000,2000);
  loadPixels();
  if (simulate) {
    createReadings();
  } else {
    parseCorpus();
  }
  ;
  background(255);
  
  startingX = canvasWidth/2;
  startingY = canvasHeight/2;
  
  //render it all at once
  for (int i = 0; i < shots; i++) {
    drawLine(finalQuantumArray[i]);
  }
  
}

void createReadings() {
  Simulator simulator = new Simulator(0.1);
  
  QuantumCircuit phiPlus = new QuantumCircuit(4, 4);
  
  for (int i = 0; i < 4; i++) {
    phiPlus.h(i);
    phiPlus.measure(i, i);
  }

  List<String> measurements = new ArrayList();
  for (int i = 0; i < shots; i++) {
    Map<String,Integer> counts = (Map)simulator.simulate(phiPlus, 1, "counts");
    String firstKey = counts.keySet().iterator().next();
    measurements.add(firstKey);
  }
  finalQuantumArray = measurements.toArray(new String[0]);
  //println(finalQuantumArray);
}

void parseCorpus() {
  quantumCorpusLoad = loadStrings("output-"+dataSource+".txt");
  finalQuantumArray = quantumCorpusLoad[0].replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
}


void drawLine(String n) {
  
  //for my 4 bits, the order is up, right, down, left

  
  //if (simulate) {
    char qb0 = n.charAt(0);
    char qb1 = n.charAt(1);
    char qb2 = n.charAt(2);
    char qb3 = n.charAt(3);
    
   if (!simulate) {
    qb0 = n.charAt(1);
    qb1 = n.charAt(2);
    qb2 = n.charAt(3);
    qb3 = n.charAt(4);
  }
  
  
  
  int binary1='1';
  char c = (char)binary1; 
  
  //if the line is off the page, reset it
  if(startingX > canvasWidth) {
    startingX = 0;
  }
  
  if(startingY > canvasHeight) {
    startingY = 0;
  }
  
  if(startingX < 0) {
    startingX = canvasWidth;
  }
  
  if(startingY < 0) {
    startingY = canvasHeight;
  }

  if (qb0 == c) {
    //println("moving up");
    line(startingX,startingY, startingX, startingY - lineSize);
    startingY -=lineSize;
  } 
  if (qb1 == c) {
    //println("moving down");
    line(startingX,startingY, startingX, startingY + lineSize);
    startingY +=lineSize;
  }
  if (qb2 == c) {
    //println("moving right");
    line(startingX,startingY, startingX + lineSize, startingY);
    startingX +=lineSize;
  } 

  if (qb3 == c) {
    //println("moving left");
    line(startingX,startingY, startingX - lineSize, startingY);
    startingX -=lineSize;
  }
  
}
