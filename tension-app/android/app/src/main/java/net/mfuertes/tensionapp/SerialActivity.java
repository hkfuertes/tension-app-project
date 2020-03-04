package net.mfuertes.tensionapp;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.app.PendingIntent;
import android.bluetooth.BluetoothClass;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.hoho.android.usbserial.driver.UsbSerialDriver;
import com.hoho.android.usbserial.driver.UsbSerialPort;
import com.hoho.android.usbserial.driver.UsbSerialProber;
import com.hoho.android.usbserial.util.SerialInputOutputManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.Executors;

import static net.mfuertes.tensionapp.HeartRateMonitor.BPM_KEY;

public class SerialActivity extends AppCompatActivity implements SerialInputOutputManager.Listener {

    private int _beat=-1;
    private TextView _text;
    private ImageView _heart;
    private boolean _red = false;
    private SerialInputOutputManager usbIoManager;

    private static final String ACTION_USB_PERMISSION = "net.mfuertes.tensionapp.USB_PERMISSION";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_serial);
        setTitle("Medición de Pulso");

        _text = findViewById(R.id.text);
        _heart = findViewById(R.id.image);
        //_text.setText(_beat+"");
        Button button = findViewById(R.id.save_button);
        button.setOnClickListener(view -> {
            if(_beat != -1){
                finishAndReturn(_beat);
            }
        });

        try{
            start();
        }catch (IOException ex){
            Toast.makeText(this, "Conecte el USB y vuelva a intentarlo.",Toast.LENGTH_LONG).show();
            finishAndReturn(-1);
        }
    }

    void finishAndReturn(int beat){
        Toast.makeText(this, "Pulso: "+_beat+" bpm", Toast.LENGTH_LONG).show();
        Intent returnIntent = getIntent();
        returnIntent.putExtra(BPM_KEY, beat);
        setResult(Activity.RESULT_OK, returnIntent );
        finish();
    }

    private void start() throws IOException {
        // Find all available drivers from attached devices.
        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
        List<UsbSerialDriver> availableDrivers = UsbSerialProber.getDefaultProber().findAllDrivers(manager);
        if (availableDrivers.isEmpty()) {
            return;
        }

        // Open a connection to the first available driver.
        UsbSerialDriver driver = availableDrivers.get(0);
        UsbDevice device = driver.getDevice();
        PendingIntent permissionIntent =  PendingIntent.getBroadcast(this, 0, new Intent(ACTION_USB_PERMISSION), 0);
        IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
        registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                UsbDeviceConnection connection = manager.openDevice(driver.getDevice());
                if (connection == null) {
                    // add UsbManager.requestPermission(driver.getDevice(), ..) handling here
                    return;
                }

                try {
                    UsbSerialPort port = driver.getPorts().get(0); // Most devices have just one port (port 0)
                    port.open(connection);
                    port.setParameters(115200, 8, UsbSerialPort.STOPBITS_1, UsbSerialPort.PARITY_NONE);

                    usbIoManager = new SerialInputOutputManager(port, SerialActivity.this);
                    Executors.newSingleThreadExecutor().submit(usbIoManager);
                }catch (IOException ex){}
            }
        }, filter);

        manager.requestPermission(device, permissionIntent);

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
    protected void onStop() {
        usbIoManager.stop();
        super.onStop();
    }

    @Override
    public void onNewData(byte[] data) {
        try {
            JSONObject pulse = new JSONObject(new String(data));

            _beat = pulse.getInt("pulse");
            runOnUiThread(() -> {
                //_heart.setColorFilter(_red ? Color.RED : Color.BLACK);
                _text.setText(_beat + " bpm");
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }




    @Override
    public void onRunError(Exception e) {

    }
}
