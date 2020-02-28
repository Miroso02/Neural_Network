class Neuron {
  int weightsN;
  float[] weights;
  
  public Neuron(int wN) {
    weightsN = wN;
    weights = new float[weightsN];
    for(int i = 0; i < weightsN; i++) {
      weights[i] = random(-10, 10);
    }
  }
  
  float countValue(float[] input) {
    float value = 0;
    for(int i = 0; i < weightsN; i++) {
      value += weights[i] * input[i];
    }
    return value;
  }
  
  void newWeights(Neuron n) {
    float[] genes = n.weights;
    for (int i = 0; i < weights.length; i++) {
      weights[i] = genes[i] + random(-1, 1);
    }
  }
}