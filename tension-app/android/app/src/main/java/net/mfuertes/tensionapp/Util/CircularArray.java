package net.mfuertes.tensionapp.Util;

public class CircularArray {
    private static final int SUM = 0;
    private static final int COUNT = 1;

    int[] elements;
    int index = 0;

    public CircularArray(int size){
        elements = new int[size];
    }

    public void add(int element){
        if (index == elements.length) index = 0;
        elements[index] = element;
        index++;
    }

    public int calculaMedia(){
        final int[] val = calculaMediaSeparada();
        return val[COUNT] > 0 ? val[SUM]/val[COUNT] : 0;
    }


    public int[] calculaMediaSeparada(){
        int averageArrayAvg = 0;
        int averageArrayCnt = 0;
        for (int i = 0; i < elements.length; i++) {
            if (elements[i] > 0) {
                averageArrayAvg += elements[i];
                averageArrayCnt++;
            }
        }
        return new int[]{averageArrayAvg, averageArrayCnt};
    }
}
