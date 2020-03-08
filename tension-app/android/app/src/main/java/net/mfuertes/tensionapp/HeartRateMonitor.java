package net.mfuertes.tensionapp;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.hardware.Camera;
import android.hardware.Camera.PreviewCallback;
import android.os.Bundle;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import java.util.concurrent.atomic.AtomicBoolean;

import static android.content.ContentValues.TAG;


/**
 * This class extends Activity to handle a picture preview, process the preview
 * for a red values and determine a heart beat.
 * 
 * @author Justin Wetherell <phishman3579@gmail.com>
 */
public class HeartRateMonitor extends AppCompatActivity implements SurfaceHolder.Callback{

    public static final String BPM_KEY = "BPM_KEY";
    private SurfaceHolder _previewHolder = null;
    private Camera camera = null;
    @SuppressLint("StaticFieldLeak")
    private ImageView image = null;
    @SuppressLint("StaticFieldLeak")
    private TextView text = null;


    private WakeLock wakeLock = null;

    private SurfaceView _preview;

    private int _beat = -1;
    private HRCallback _previewCallback = new HRCallback((beat) -> {
        text.setText(beat+" bpm");
        this._beat = beat;
    });

    /**
     * {@inheritDoc}
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        setTitle("Medición de Pulso");

        camera = Camera.open();


        this._preview = findViewById(R.id.preview);
        _previewHolder = _preview.getHolder();
        _previewHolder.addCallback(this);
        //_previewHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

        //image = findViewById(R.id.image);
        text = findViewById(R.id.text);
        Button button = findViewById(R.id.save_button);
        button.setOnClickListener(view -> {
            if(_beat != -1){
                Toast.makeText(this, "Pulso: "+_beat+" bpm", Toast.LENGTH_LONG).show();
                Intent returnIntent = getIntent();
                returnIntent.putExtra(BPM_KEY, _beat);
                setResult(Activity.RESULT_OK, returnIntent );
                finish();
            }
        });

        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        wakeLock = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK, ":DoNotDimScreen");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.close:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }


    @Override
    public void onResume() {
        super.onResume();

        wakeLock.acquire(10*60*1000L /*10 minutes*/);

        camera = Camera.open();
        _preview.invalidate();

    }

    @Override
    public void onPause() {
        super.onPause();

        wakeLock.release();

        camera.setPreviewCallback(null);
        camera.stopPreview();
        camera.release();
        camera = null;
    }

    @Override
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
        try {
            camera.setPreviewDisplay(_previewHolder);
            camera.setPreviewCallback(_previewCallback);
        } catch (Throwable t) {
            Log.e("Preview-surfaceCallback", "Exception in setPreviewDisplay()", t);
        }
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        Camera.Parameters parameters = camera.getParameters();
        parameters.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
        Camera.Size size = getSmallestPreviewSize(width, height, parameters);
        if (size != null) {
            parameters.setPreviewSize(size.width, size.height);
            Log.d(TAG, "Using width=" + size.width + " height=" + size.height);
        }
        camera.setParameters(parameters);
        camera.startPreview();
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {

    }

    public static Camera.Size getSmallestPreviewSize(int width, int height, Camera.Parameters parameters) {
        Camera.Size result = null;

        for (Camera.Size size : parameters.getSupportedPreviewSizes()) {
            if (size.width <= width && size.height <= height) {
                if (result == null) {
                    result = size;
                } else {
                    int resultArea = result.width * result.height;
                    int newArea = size.width * size.height;

                    if (newArea < resultArea) result = size;
                }
            }
        }

        return result;
    }
}
