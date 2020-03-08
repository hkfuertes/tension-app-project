package net.mfuertes.tensionapp;

import android.hardware.Camera;
import android.util.Log;

import java.util.concurrent.atomic.AtomicBoolean;

import static android.content.ContentValues.TAG;

public class HRCallback implements Camera.PreviewCallback {

    private final OnBeatChanged onFrameChanged;

    public interface OnBeatChanged{
        void onChanged(int beat);
    }

    private static final int SUM = 0;
    private static final int COUNT = 1;

    // Estamos procesando
    private static final AtomicBoolean processing = new AtomicBoolean(false);

    // Indices y array para la media de imagenes
    private static int averageIndex = 0;
    private static final int averageArraySize = 4;
    private static final int[] averageArray = new int[averageArraySize];

    // Indices y array para la media de beats
    private static int beatsIndex = 0;
    private static final int beatsArraySize = 3;
    private static final int[] beatsArray = new int[beatsArraySize];

    // Numero de Beats y starting time.
    private static double beats = 0;
    private static long startTime = 0;

    public static enum TYPE {
        SUBIENDO, BAJANDO
    }

    private static TYPE currentType = TYPE.SUBIENDO;

    public HRCallback(OnBeatChanged onFrameChanged){
        this.onFrameChanged = onFrameChanged;
    }


    private int _calculaMedia(int[] valArray){
        final int[] val = _calculaMediaSeparada(valArray);
        return val[COUNT] > 0 ? val[SUM]/val[COUNT] : 0;
    }


    private int[] _calculaMediaSeparada(int[] valArray){
        int averageArrayAvg = 0;
        int averageArrayCnt = 0;
        for (int i = 0; i < valArray.length; i++) {
            if (valArray[i] > 0) {
                averageArrayAvg += valArray[i];
                averageArrayCnt++;
            }
        }
        return new int[]{averageArrayAvg, averageArrayCnt};
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void onPreviewFrame(byte[] data, Camera cam) {
        if (data == null) throw new NullPointerException();
        Camera.Size size = cam.getParameters().getPreviewSize();
        if (size == null) throw new NullPointerException();

        if (!processing.compareAndSet(false, true)) return;


        // Obtenemos la media de los pixeles rojos de de imagen (0 -255)
        int imgAvg = ImageProcessing.decodeYUV420SPtoRedAvg(data.clone(),  size.height, size.width);

        Log.i(TAG, "imgAvg="+imgAvg);
        if (imgAvg == 0 || imgAvg == 255) {
            processing.set(false);
            return;
        }

        // Calculamnos la media
        int rollingAverage = _calculaMedia(averageArray);

        TYPE newType = currentType;

        // Si la media obtenida es menor que la media que teniamos guardada, cambiamos hacia abajo.
        if (imgAvg < rollingAverage) {
            newType = TYPE.BAJANDO;
            // Sumamos uno al numero de cambio/beats ocurridos
            if (newType != currentType) beats++;

        // Si la media obtenida es mayor que la media que teniamos guardada, cambiamos hacia arriba.
        } else if (imgAvg > rollingAverage) newType = TYPE.SUBIENDO;


        // Metemos la media de la imagen en el array de medias.
        if (averageIndex == averageArraySize) averageIndex = 0;
        averageArray[averageIndex] = imgAvg;
        averageIndex++;

        // Transitioned from one state to another to the same
        if (newType != currentType) currentType = newType;

        //----------------------------------------------------------------------------------------//

        // Controlamos el tiempo anterior
        long endTime = System.currentTimeMillis();
        // Controlamos el tiempo inicial anterior y compromabos que han pasado 10 segundos antes de hacer nada.
        double totalTimeInSecs = (endTime - startTime) / 1000d;
        if (totalTimeInSecs >= 10) {
            // Dividimos el numero de beats entre el entre los segundos.
            double bps = (beats / totalTimeInSecs);
            int dpm = (int) (bps * 60d);
            // Si no esta en un rango entre 30 y 180 lo deshechamos
            if (dpm < 30 || dpm > 180) {
                startTime = System.currentTimeMillis();
                beats = 0;
                processing.set(false);
                return;
            }

            // Guardamos en un array los ultimos "beatsArraySize" valores.
            if (beatsIndex == beatsArraySize) beatsIndex = 0;
            beatsArray[beatsIndex] = dpm;
            beatsIndex++;

            // Calculamos la media de los ultimos "beatsArraySize" valores.
            int beatsAvg = _calculaMedia(beatsArray);
            onFrameChanged.onChanged(beatsAvg);
            startTime = System.currentTimeMillis();
            beats = 0;
        }
        processing.set(false);
    }
}
