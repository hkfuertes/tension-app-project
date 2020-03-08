package net.mfuertes.tensionapp;

import android.hardware.Camera;
import net.mfuertes.tensionapp.Util.CircularArray;
import java.util.concurrent.atomic.AtomicBoolean;


public class HRCallback implements Camera.PreviewCallback {
    private static final String TAG = "HRCallback";

    private final OnBeatChanged onFrameChanged;

    public interface OnBeatChanged {
        void onChanged(int beat);
    }

    // Estamos procesando
    private static final AtomicBoolean processing = new AtomicBoolean(false);

    // Indices y array para la media de imagenes
    private CircularArray imgArray = new CircularArray(4);

    // Indices y array para la media de beats
    private CircularArray beatsArray = new CircularArray(3);

    // Numero de Beats y starting time.
    private static double beats = 0;
    private static long startTime = 0;

    public enum TYPE {
        SUBIENDO, BAJANDO
    }

    private static TYPE currentType = TYPE.SUBIENDO;


    public HRCallback(OnBeatChanged onFrameChanged) {
        this.onFrameChanged = onFrameChanged;
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
        int imgAvg = ImageProcessing.decodeYUV420SPtoRedAvg(data.clone(), size.height, size.width);


        if (imgAvg == 0 || imgAvg == 255) {
            processing.set(false);
            return;
        }

        // Calculamnos la media
        int rollingAverage = imgArray.calculaMedia();

        TYPE newType = currentType;

        // Si la media obtenida es menor que la media que teniamos guardada, cambiamos hacia abajo.
        if (imgAvg < rollingAverage) {
            newType = TYPE.SUBIENDO;
            // Sumamos uno al numero de cambio/beats ocurridos
            if (newType != currentType){
                beats++;
            }

            // Si la media obtenida es mayor que la media que teniamos guardada, cambiamos hacia arriba.
        } else if (imgAvg > rollingAverage) {
            newType = TYPE.BAJANDO;
        }

        // Metemos la media de la imagen en el array de medias.
        imgArray.add(imgAvg);

        if (newType != currentType) {
            currentType = newType;
        }

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
            beatsArray.add(dpm);

            // Calculamos la media de los ultimos "beatsArraySize" valores.
            int beatsAvg = beatsArray.calculaMedia();
            onFrameChanged.onChanged(beatsAvg);
            startTime = System.currentTimeMillis();
            beats = 0;
        }
        processing.set(false);
    }
}
