package net.mfuertes.tensionapp;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "net.mfuertes.tensionapp/channel";
    private static final int PULSE_CODE = 0x42;
    private MethodChannel.Result _result;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            this._result = result;
                            if (call.method.equals("startPulseActivity")) {
                                Intent intent = new Intent(this, HeartRateMonitor.class);
                                startActivityForResult(intent, PULSE_CODE);
                                //result.success("AcitivityLaunched!");
                            } else if (call.method.equals("startSerialActivity")) {
                                Intent intent = new Intent(this, SerialActivity.class);
                                startActivityForResult(intent, PULSE_CODE);
                                //result.success("AcitivityLaunched!");
                            } else
                                result.notImplemented();
                        }
                );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // Check which request we're responding to
        if (requestCode == PULSE_CODE) {
            // Make sure the request was successful
            if (resultCode == RESULT_OK) {
                _result.success(data.getIntExtra(HeartRateMonitor.BPM_KEY,-1));
            }
        }
    }
}
