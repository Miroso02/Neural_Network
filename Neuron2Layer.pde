class NeuronLayer {
  int numOfNeurons;
  Neuron[] neurons;
  
  public NeuronLayer(int numNlast, int numN) {
    numOfNeurons = numN;
    neurons = new Neuron[numN];
    
    for (int i = 0; i < numN; i++) {
      neurons[i] = new Neuron(numNlast);
    }
  }
  
  float[] countValue(float[] input) {
     float[] value = new float[numOfNeurons];
     for(int i = 0; i < numOfNeurons; i++) {
       value[i] = neurons[i].countValue(input);
     }
     return value;
  }
  
  void newNeurons(NeuronLayer nl) {
    for(int i = 0; i < numOfNeurons; i++) {
      neurons[i].newWeights(nl.neurons[i]);
    }
  }
}