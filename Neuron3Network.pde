class NeuronNetwork {
  int numOfLayers;
  NeuronLayer[] layers;
  
  public NeuronNetwork(int parametersN, int... structure) {
    numOfLayers = structure.length;
    
    layers = new NeuronLayer[numOfLayers];
    
    layers[0] = new NeuronLayer(structure[0], parametersN);
    for(int i = 1; i < numOfLayers; i++) {
      layers[i] = new NeuronLayer(structure[i], structure[i - 1]);
    }
  }
  
  float[] countValue(float[] input) {
    for(NeuronLayer nl : layers) {
      input = nl.countValue(input);
    }
    return input;
  }
  
  void newLayers(NeuronNetwork nn) {
    for(int i = 0; i < numOfLayers; i++) {
      layers[i].newNeurons(nn.layers[i]);
    }
  }
}