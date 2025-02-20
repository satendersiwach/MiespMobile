package com.app.scanner;
import com.cipherlab.barcode.*;
import com.cipherlab.barcode.decoder.*;
import com.cipherlab.barcode.decoderparams.*;
import com.cipherlab.barcodebase.*;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.widget.Toast;
import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import  io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements ReaderCallback {
    public String decoded_data=null;
    private static final String CHANNEL = "com.example.temp/rfid";
    private IntentFilter filter;
    private ReaderManager mReaderManager;
    private Thread mMyThread2 = null;
    private boolean mIsRunning = false;
    private ReaderCallback mReaderCallback = null;
    private MethodChannel.Result pendingResult;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Removed the UI-related line setContentView(R.layout.activity_main);

        // Initialize the ReaderManager
        mReaderManager = ReaderManager.InitInstance(this);
        mReaderCallback = this;

        // Set up the filter for actions related to scanner data
        filter = new IntentFilter();
        filter.addAction(GeneralString.Intent_SOFTTRIGGER_DATA);
        filter.addAction(GeneralString.Intent_PASS_TO_APP);
        filter.addAction(GeneralString.Intent_READERSERVICE_CONNECTED);

        // Register the receiver to listen for scanner data
        registerReceiver(myDataReceiver, filter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        // Stop any running thread or related tasks
        mIsRunning = false;

        // If the thread was running, attempt to stop it (if needed)
        if (mMyThread2 != null && mMyThread2.isAlive()) {
            try {
                mMyThread2.join(5000); // Allow 5 seconds for the thread to terminate cleanly
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // ***************************************************//
        // Unregister BroadcastReceiver before app closes
        // ***************************************************//
        unregisterReceiver(myDataReceiver);

        // ***************************************************//
        // Release resources related to ReaderManager before app closes
        // ***************************************************//
        if (mReaderManager != null) {
            mReaderManager.Release();
        }
    }

    private void ExeSampleCode()
    {
        if (mReaderManager != null)
        {
            Thread sThread = new Thread(new Runnable() {

                @Override
                public void run() {
                    mReaderManager.SoftScanTrigger();
                }
            });
            sThread.setPriority( Thread.MAX_PRIORITY );
            sThread.start();
        }
    }

    private final BroadcastReceiver myDataReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(GeneralString.Intent_SOFTTRIGGER_DATA)) {
                decoded_data = intent.getStringExtra(GeneralString.BcReaderData);
                Log.d("ScannerData", "Decoded Data: " + decoded_data);

                if (pendingResult != null) {
                    pendingResult.success(decoded_data);
                    pendingResult = null; // Reset after sending response
                }
            }
        }
    };


    public class SoftScanTriggerRunnable implements Runnable {
        @Override
        public void run() {
            int iSleepTime = 3000;  // Delay between scans (in milliseconds)

            while (mIsRunning) {  // This loop continues while mIsRunning is true
                try {
                    // Trigger the scanner to perform a soft scan
                    mReaderManager.SoftScanTrigger();

                    // Sleep for the specified amount of time before triggering the next scan
                    Thread.sleep(iSleepTime);

                } catch (Exception e) {
                    e.printStackTrace();  // Log any exceptions for debugging purposes
                }
            }
        }
    }
    @Override
    public IBinder asBinder() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void onDecodeComplete(String arg0) throws RemoteException {
        // TODO Auto-generated method stub
        //e1.setText(arg0);
        Toast.makeText(this, "Decode Data " + arg0, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("configureRFID")) {
                        decoded_data = null;
                        pendingResult = result; // Store result to send data later
                        configureRFID();
                    } else {
                        result.notImplemented();
                    }
                });
    }
    private void configureRFID() {
        // Your RFID configuration logic here
        Log.e("Hi", "Configuring ");
        Log.d("Hell","configureRFID method invoked from Flutter");

        try{
            ExeSampleCode();
        } catch (java.lang.Exception e) {
            Toast.makeText(this, "Error in configureRFID: " + e.getMessage(), Toast.LENGTH_SHORT).show();
            Log.e("Exception", e.getMessage());
        }
        finally {
            Log.e("Hi", "ExeSampleCode has run");
        }
    }
}