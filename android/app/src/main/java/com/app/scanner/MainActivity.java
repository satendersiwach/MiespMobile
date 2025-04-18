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

        // ***************************************************//
        // 1. Get barcode scanner type
        // ***************************************************//
        {

			/*if (mReaderManager != null)
			{
				BcReaderType myReaderType =  mReaderManager.GetReaderType();
				e1.setText(myReaderType.toString());
			}*/

        }

        // ***************************************************//
        // 2. Enable/Disable barcode reader service
        // ***************************************************//
        {

			/*if (mReaderManager != null)
			{
				ClResult clRet = mReaderManager.SetActive(false);
				boolean bRet = mReaderManager.GetActive();
				clRet = mReaderManager.SetActive(true);
				bRet = mReaderManager.GetActive();
			}*/

        }

        // ***************************************************//
        // 3. Get/Set output data format (keystroke)
        //    Decoded data Post-production, add decoded type、decode data、length prefix/postfix string or return char...etc
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				ReaderOutputConfiguration settings = new ReaderOutputConfiguration();

				// step2: this action does mean set output format to default
				mReaderManager.Set_ReaderOutputConfiguration(settings);

				// step3: or user can skip step2 to get settings by using Get_ReaderOutputConfiguration
				mReaderManager.Get_ReaderOutputConfiguration(settings);

				// step4: or user can skip step2 and step3 to set more detail items directly.
				settings.autoEnterWay = OutputEnterWay.PreffixData;
				settings.autoEnterChar = OutputEnterChar.Return; //OutputEnterChar.valueOf(100);
				settings.showCodeLen = Enable_State.TRUE;
				settings.showCodeType= Enable_State.TRUE;
				settings.szPrefixCode="";
				settings.szSuffixCode="";
				settings.useDelim = ':';

				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_ReaderOutputConfiguration(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_ReaderOutputConfiguration was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_ReaderOutputConfiguration was InvalidParameter", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_ReaderOutputConfiguration was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_ReaderOutputConfiguration was Ok", Toast.LENGTH_SHORT).show();
			}
			*/
        }

        // ***************************************************//
        // 4. Get/Set notification
        //    Flash LED、Vibrate、Beep sound when decode barcode data
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				NotificationParams settings = new NotificationParams();

				// step2: this action does mean get current settings of notificaion
				mReaderManager.Get_NotificationParams(settings);

				// step3: or skip step2 to set detail items
				settings.ReaderBeep = BeepType.Hwandsw;
				settings.enableVibrator = Enable_State.FALSE;
				settings.ledDuration = 2000; //ms
				settings.vibrationCounter = 1; //500ms * count

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_NotificationParams(settings);

				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_NotificationParams was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_NotificationParams was InvalidParameter", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_NotificationParams was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_NotificationParams was Ok", Toast.LENGTH_SHORT).show();
			}
			*/
        }

        // ***************************************************//
        // 5. get/set UserPreference
        //    For example, get/set scan duration time、security level、redundancy level…etc
        // ***************************************************//
        {
            if (mReaderManager != null)
            {
                BcReaderType myReaderType =  mReaderManager.GetReaderType();

                // step1: new a class, the object is set to default value
                UserPreference settings = new UserPreference();

                // step2: this action does mean get current settings of UserPreference
                mReaderManager.Get_UserPreferences(settings);

                // step3: items are not supported exactly, so user can check...
                if (Enable_State.NotSupport == settings.displayMode)
                {
                    //1D does not support
                }

                //settings.addonSecurityLevel = 7;
                settings.laserOnTime = 3000;
                //settings.negativeBarcodes = InverseType.AutoDetect;
                //settings.scanAngle = ScanAngleType.Wide;
                //settings.securityLevel = SecurityLevel.Three;
                //settings.pickListMode = Enable_State.FALSE;
                //settings.timeoutBetweenSameSymbol = 2000;
                //settings.displayMode = Enable_State.FALSE;
                //settings.redundancyLevel = RedundancyLevel.Four;
                //settings.transmitCodeIdChar = TransmitCodeIDType.AimCodeId;
                //settings.triggerMode = TriggerType.ContinuousMode;
                //settings.triggerMode = TriggerType.AutoAimMode;
                //settings.triggerMode = TriggerType.LevelMode;

                // Change to Trigger Presentation Mode
                settings.triggerMode = TriggerType.PresentationMode;
                settings.timeoutPresentationMode = 10 * 60 * 1000; // ms
                settings.triggerPresentationMode = Enable_State.TRUE;

                // Change to Level Mode
                settings.triggerMode = TriggerType.LevelMode;
                settings.triggerPresentationMode = Enable_State.FALSE;

                //settings.interCharGapSize = InterCharacterGapSize.Normal;
                //settings.decodingAimingPattern = Enable_State.TRUE;
                //settings.decodingIllumination  = Enable_State.TRUE;
                //settings.decodingIlluminationPowerLevel = IlluminationPowerLevel.Zero;


                // step4
                // Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
                // if user get Err_InvalidParameter, it means user put wrong value into items
                // if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
                // if user get S_OK, it means set settings is successful.
                ClResult clRet = mReaderManager.Set_UserPreferences(settings);
                if (ClResult.S_ERR == clRet)
                    Toast.makeText(this, "Get_UserPreferences was failed", Toast.LENGTH_SHORT).show();
                else if (ClResult.Err_InvalidParameter == clRet)
                    Toast.makeText(this, "Get_UserPreferences was InvalidParameter",	Toast.LENGTH_SHORT).show();
                else if (ClResult.Err_NotSupport == clRet)
                    Toast.makeText(this, "Get_UserPreferences was NotSupport", Toast.LENGTH_SHORT).show();
                else if (ClResult.S_OK == clRet)
                    Toast.makeText(this, "Get_UserPreferences was successful", Toast.LENGTH_SHORT).show();
            }
        }


        // ***************************************************//
        // 6. get/set status(enable or disable) of all symbologies
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Decoders settings = new Decoders();

				// step2: get status of all symbologies
				mReaderManager.Get_Decoders_Status(settings);

				// step3: Not all items are supported exactly, so user can check first...
				if (Enable_State.NotSupport == settings.enableAustrailianPostal) {
					// 1D does not support
				}

				// example: disable all
				settings.enableAustrailianPostal = Enable_State.FALSE;
				settings.enableAztec = Enable_State.FALSE;
				settings.enableChinese2Of5 = Enable_State.FALSE;
				settings.enableCodabar = Enable_State.FALSE;
				settings.enableCode11 = Enable_State.FALSE;
				settings.enableCode128 = Enable_State.FALSE;
				settings.enableCode39 = Enable_State.FALSE;
				settings.enableCode93 = Enable_State.FALSE;
				settings.enableCompositeCC_AB = Enable_State.FALSE;
				settings.enableCompositeCC_C = Enable_State.FALSE;
				settings.enableCompositeTlc39 = Enable_State.FALSE;
				settings.enableDataMatrix = Enable_State.FALSE;
				settings.enableDutchPostal = Enable_State.FALSE;
				settings.enableEanJan13 = Enable_State.FALSE;
				settings.enableEanJan8 = Enable_State.FALSE;
				settings.enableGs1128 = Enable_State.FALSE;
				settings.enableGs1DataBar14 = Enable_State.FALSE;
				settings.enableGs1DataBarExpanded = Enable_State.FALSE;
				settings.enableGs1DataBarLimited = Enable_State.FALSE;
				settings.enableGs1DatabarToUpcEan = Enable_State.FALSE;

				settings.enableIndustrial2Of5 = Enable_State.FALSE;
				settings.enableInterleaved2Of5 = Enable_State.FALSE;
				settings.enableIsbt128 = Enable_State.FALSE;
				settings.enableJapanPostal = Enable_State.FALSE;
				settings.enableKorean3Of5 = Enable_State.FALSE;
				settings.enableMatrix2Of5 = Enable_State.FALSE;
				settings.enableMaxiCode = Enable_State.FALSE;
				settings.enableMicroPDF417 = Enable_State.FALSE;
				settings.enableMicroQR = Enable_State.FALSE;
				settings.enableMsi = Enable_State.FALSE;
				settings.enablePDF417 = Enable_State.FALSE;
				settings.enableQRcode = Enable_State.FALSE;
				settings.enableTriopticCode39 = Enable_State.FALSE;

				settings.enableUccCoupon = Enable_State.FALSE;
				settings.enableUKPostal = Enable_State.FALSE;
				settings.enableUpcA = Enable_State.FALSE;
				settings.enableUpcE = Enable_State.FALSE;
				settings.enableUpcE1 = Enable_State.FALSE;
				settings.enableUPUFICSPostal = Enable_State.FALSE;
				settings.enableUSPlanet = Enable_State.FALSE;
				settings.enableUSPostnet = Enable_State.FALSE;
				settings.enableUSPSPostal = Enable_State.FALSE;
				//settings.enablePlessey = Enable_State.FALSE;
				//settings.enableTelepen = Enable_State.FALSE;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Decoders_Status(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Decoders_Status was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Decoders_Status was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Decoders_Status was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Decoders_Status was successful", Toast.LENGTH_SHORT).show();

				// you can set to default after doing steps above
				//mReaderManager.Set_Decoders_Status(new Decoders());
			}
			*/
        }


        // ***************************************************//
        // 7-0. get/set CodaBar
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Codabar settings = new Codabar();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.clsiEditing = Enable_State.FALSE;
				settings.enable = Enable_State.TRUE;
				settings.length1 = 4;
				settings.length2 = 55;
				settings.transmitCheckDigit = Enable_State.TRUE;
				//settings.notisEditingType = NOTISEditingType.ABCD_Upper;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/
        }

        // ***************************************************//
        // 7-1. get/set Industrial 2 Of 5 (same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Industrial2Of5 settings = new Industrial2Of5();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.length1 = 5;
				settings.length2 = 30;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        // 7-2. get/set Interleaved 2 Of 5(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				BcReaderType myReaderType =  mReaderManager.GetReaderType();

				// step1: new a class, the object is set to default value
				Interleaved2Of5 settings = new Interleaved2Of5();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.length1 = 5;
				settings.length2 = 30;
				settings.convertToEan13 = Enable_State.FALSE;
				settings.transmitCheckDigit =Enable_State.FALSE;
				settings.checkDigitVerification = I20f5CheckDigitVerification.Modulo_10;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        // 7-3. set/get Composite Symbology(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Composite settings = new Composite();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: 修改細項
				settings.enableCc_AB = Enable_State.FALSE;
				settings.enableCc_C = Enable_State.FALSE;
				settings.enableEmulationMode = Enable_State.FALSE;
				settings.enableTlc39 = Enable_State.TRUE;
				settings.enableUpcMode = UpcMode.NeverLinksUPC;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        //  7-4. get/set Chinese 2 of 5(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Chinese2Of5 settings = new Chinese2Of5();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        // 7-5. get/set Matrix 2 of 5(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				Matrix2Of5 settings = new Matrix2Of5();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable =Enable_State.TRUE;
				settings.checkDigitVerification = Enable_State.FALSE;
				settings.transmitCheckDigit = Enable_State.FALSE;
				settings.redundancy = Enable_State.TRUE;
				settings.length1 = 5;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        //  7-6. get/set Code 39(same usage as above)
        // ***************************************************//
        {
            if (mReaderManager != null)
            {

                // step1: new a class, the object is set to default value
                Code39 settings = new Code39();

                // step2: to check does barcode scanner support this symbology
                if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
                {
                    // barcode scanner of device does not support this kind of symbology
                    return;
                }

                // step3: if barcode scanner support this symbology，then user can change attribute
                settings.enable = Enable_State.TRUE;
                settings.fullASCII = Enable_State.TRUE;
                settings.checkDigitVerification = Enable_State.FALSE;
                settings.transmitCheckDigit = Enable_State.FALSE;
                settings.convertToCode32 = Enable_State.FALSE;
                settings.convertToCode32Prefix = Enable_State.FALSE;

                // step4
                // Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
                // if user get Err_InvalidParameter, it means user put wrong value into items
                // if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
                // if user get S_OK, it means set settings is successful.
                ClResult clRet = mReaderManager.Set_Symbology(settings);
                if (ClResult.S_ERR == clRet)
                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
                else if (ClResult.Err_InvalidParameter == clRet)
                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
                else if (ClResult.Err_NotSupport == clRet)
                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
                else if (ClResult.S_OK == clRet)
                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
            }
        }

        // ***************************************************//
        //  7-7. get/set TriopticCode 39(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				TriopticCode39 settings = new TriopticCode39();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.FALSE;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        //  7-8. get/set Code 93(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Code93 settings = new Code93();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.length1 = 10;
				settings.length2 = 20;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        // 7-9. get/set ISBT 128(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				ISBT128 settings = new ISBT128();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.concatenation = ISBTConcatenationType.Enable;
				settings.concatenationRedundancy = 5;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        //  7-10. get/set Code 128(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Code128 settings = new Code128();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}


				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        //  7-11. get/set GS1 128(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				GS1128 settings = new GS1128();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.fieldSeparator = '%';

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        //  7-12. get/set Msi(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				Msi settings = new Msi();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.length1 = 4;
				settings.length2 = 55;
				settings.checkDigitAlgorithm = DigitAlgorithm.Modulo_10_11;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.checkDigitOption = MsiDigitOption.OneDigit;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/

        }

        // ***************************************************//
        //  7-13. get/set Ean8(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Ean8 settings = new Ean8();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.addon2 = AddonsType.IgnoresAddons;
				settings.addon5 = AddonsType.AutoDiscriminate;
				settings.convertToEan13 = Enable_State.FALSE;
				settings.transmitCheckDigit = Enable_State.TRUE;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-14. get/set Ean13(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Ean13 settings = new Ean13();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.addon2 = AddonsType.AutoDiscriminate;
				settings.addon5 = AddonsType.IgnoresAddons;
				settings.convertToISBN = Enable_State.TRUE;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.booklandISBNFormat=ISBNFormat.ISBN_10;


				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-15. get/set GS1 DataBar 14(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				GS1DataBar14 settings = new GS1DataBar14();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.convertToUpcEan = Enable_State.FALSE;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-16. get/set GS1 DataBar Expanded(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				GS1DataBarExpanded settings = new GS1DataBarExpanded();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.fieldSeparator = '"';

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/


        }

        // ***************************************************//
        //  7-17. get/set GS1 DataBar Limited(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				GS1DataBarLimited settings = new GS1DataBarLimited();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.convertToUpcEan = Enable_State.FALSE;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-18. get/set UccCoupon(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UccCoupon settings = new UccCoupon();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/

        }

        // ***************************************************//
        //  7-19. get/set UpcA(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UpcA settings = new UpcA();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.addon2 = AddonsType.AutoDiscriminate;
				settings.addon5 = AddonsType.AutoDiscriminate;
				settings.convertToEan13 = Enable_State.FALSE;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.transmitSystemNumber = Preamble.SysNumAndCtyCode;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/
        }

        // ***************************************************//
        //  7-20. get/set UpcE(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UpcE settings = new UpcE();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.addon2 = AddonsType.AutoDiscriminate;
				settings.addon5 = AddonsType.AutoDiscriminate;
				settings.convertToUpcA = Enable_State.FALSE;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.transmitSystemNumber = Preamble.SysNumAndCtyCode;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-21. get/set UpcE1(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UpcE1 settings = new UpcE1();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.addon2 = AddonsType.AutoDiscriminate;
				settings.addon5 = AddonsType.AutoDiscriminate;
				settings.convertToUpcA = Enable_State.FALSE;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.transmitSystemNumber = Preamble.None;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
			}
			*/


        }

        // ***************************************************//
        //  7-22. get/set Code11(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				Code11 settings = new Code11();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}

				// step3: if barcode scanner support this symbology，then user can change attribute
				settings.enable = Enable_State.TRUE;
				settings.transmitCheckDigit = Enable_State.TRUE;
				settings.numberOfCheckDigits = NumberOfCheck.Two;
				settings.length1 = 4;
				settings.length2 = 55;

				// step4
				// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
				// if user get Err_InvalidParameter, it means user put wrong value into items
				// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
				// if user get S_OK, it means set settings is successful.
				ClResult clRet = mReaderManager.Set_Symbology(settings);
				if (ClResult.S_ERR == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_InvalidParameter == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
				else if (ClResult.Err_NotSupport == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
				else if (ClResult.S_OK == clRet)
					Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

			}
			*/


        }

        // ***************************************************//
        // 7-23. get/set USPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				USPostal settings = new USPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enablePlanet = Enable_State.TRUE;
					settings.enablePostnet = Enable_State.TRUE;
					settings.transmitCheckDigit = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-24. get/set UKPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UKPostal settings = new UKPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.FALSE;
					settings.transmitCheckDigit = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-25. get/set JapanPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				JapanPostal settings = new JapanPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.FALSE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-26. get/set AustralianPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				AustralianPostal settings = new AustralianPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-27. get/set DutchPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				DutchPostal settings = new DutchPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-28. get/set USPSPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				USPSPostal settings = new USPSPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-29. get/set UPUFICSPostal(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				UPUFICSPostal settings = new UPUFICSPostal();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }


        // ***************************************************//
        // 7-30. get/set PDF417(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				PDF417 settings = new PDF417();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;
					settings.escapeCharacter = Enable_State.FALSE;
					settings.transmitControlHeader = Enable_State.FALSE;
					settings.transmitMode = TransmitMode.TransmitAnySymbolInSet;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-31. get/set MicroPDF417(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				MicroPDF417 settings = new MicroPDF417();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;
					settings.code128Emulation = Enable_State.FALSE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-32. get/set DataMatrix(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				DataMatrix settings = new DataMatrix();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;
					settings.mirrorImage = MatrixMirrorImage.Auto;
					settings.fieldSeparator = 'A';

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-33. get/set MaxiCode(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				MaxiCode settings = new MaxiCode();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-34. get/set QRCode(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				QRCode settings = new QRCode();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-35. get/set MicroQR(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				MicroQR settings = new MicroQR();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-36. get/set Aztec(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				Aztec settings = new Aztec();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }

        // ***************************************************//
        // 7-37. get/set Korean3Of5(same usage as above)
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{

				// step1: new a class, the object is set to default value
				Korean3Of5 settings = new Korean3Of5();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();

				}
			}
			*/
        }


        // ***************************************************//
        // 7-37. get/set Plessey (same usage as above)
        // ***************************************************//
		/*
		{
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Plessey settings = new Plessey();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;
					settings.unconventionalStop = Enable_State.TRUE;
					settings.transmitCheckDigit = Enable_State.TRUE;
					settings.length1 = 10;
					settings.length2 = 55;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
				}
			}
		}
		*/


        // ***************************************************//
        // 7-37. get/set Telepen (same usage as above)
        // ***************************************************//
		/*
		{
			if (mReaderManager != null)
			{
				// step1: new a class, the object is set to default value
				Telepen settings = new Telepen();

				// step2: to check does barcode scanner support this symbology
				if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
				{
					// barcode scanner of device does not support this kind of symbology
					return;
				}
				else if (ClResult.S_OK == mReaderManager.Get_Symbology(settings)) {

					// step3: if barcode scanner support this symbology，then user can change attribute
					settings.enable = Enable_State.TRUE;
					settings.format = TelepenFormat.Numeric;
					settings.length1 = 10;
					settings.length2 = 55;

					// step4
					// Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
					// if user get Err_InvalidParameter, it means user put wrong value into items
					// if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
					// if user get S_OK, it means set settings is successful.
					ClResult clRet = mReaderManager.Set_Symbology(settings);
					if (ClResult.S_ERR == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_InvalidParameter == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
					else if (ClResult.Err_NotSupport == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
					else if (ClResult.S_OK == clRet)
						Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
				}
			}
		}
		*/

        // ***************************************************//
        //  8. software trigger
        // ***************************************************//
        {

            // software way to scan barcode (ex, create a button (call this API inside onClick))
            // if decode barcode successfully, app will get an intent "Intent_SOFTTRIGGER_DATA"
            // get decoded data from intent.getStringExtra() (it does need to implement a BroadcastReceiver (see below))
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

        // ***************************************************//
        //  9. reset to default(include all symbologies and Notification、UserPreferences、ReaderOutputConfiguration
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				if (ClResult.S_ERR == mReaderManager.ResetReaderToDefault())
				{
					Toast.makeText(this, "ResetReaderToDefault was failed",
							Toast.LENGTH_SHORT).show();
				}
				else {
					Toast.makeText(this, "ResetReaderToDefault was done!",
							Toast.LENGTH_SHORT).show();
				}
			}
			*/
        }

        // ***************************************************//
        //  10. get version of barcode reader service
        // ***************************************************//
        {
			/*
			if (mReaderManager != null)
			{
				String ver = mReaderManager.Get_BarcodeServiceVer();
			}
			*/
        }

        // ***************************************************//
        //  11. for special case , get data from keyboard emulation(not from intent) after software trigger
        // ***************************************************//
        {
			/*
			// software way to scan barcode (ex, create a button (call this API inside onClick))
			// if decode barcode successfully, app will get an intent "Intent_SOFTTRIGGER_DATA"
			// get decoded data from intent.getStringExtra() (it does need to implement a BroadcastReceiver (see below))
			if (mReaderManager != null)
			{
				Thread sThread = new Thread(new Runnable() {

					@Override
					public void run() {
						mReaderManager.SoftwareTriggerAndGetDataFromKeyboardEmulation();
					}
				});
				sThread.setPriority( Thread.MAX_PRIORITY );
				sThread.start();

			}
			*/

        }

    }
//    private void ExeSampleCode()
//    {
//        {
//            if (mReaderManager != null)
//            {
//                BcReaderType myReaderType =  mReaderManager.GetReaderType();
//
//                // step1: new a class, the object is set to default value
//                UserPreference settings = new UserPreference();
//
//                // step2: this action does mean get current settings of UserPreference
//                mReaderManager.Get_UserPreferences(settings);
//
//                // step3: items are not supported exactly, so user can check...
//                if (Enable_State.NotSupport == settings.displayMode)
//                {
//                    //1D does not support
//                }
//
//                //settings.addonSecurityLevel = 7;
//                settings.laserOnTime = 3000;
//                //settings.negativeBarcodes = InverseType.AutoDetect;
//                //settings.scanAngle = ScanAngleType.Wide;
//                //settings.securityLevel = SecurityLevel.Three;
//                //settings.pickListMode = Enable_State.FALSE;
//                //settings.timeoutBetweenSameSymbol = 2000;
//                //settings.displayMode = Enable_State.FALSE;
//                //settings.redundancyLevel = RedundancyLevel.Four;
//                //settings.transmitCodeIdChar = TransmitCodeIDType.AimCodeId;
//                //settings.triggerMode = TriggerType.ContinuousMode;
//                //settings.triggerMode = TriggerType.AutoAimMode;
//                //settings.triggerMode = TriggerType.LevelMode;
//
//                // Change to Trigger Presentation Mode
//                settings.triggerMode = TriggerType.PresentationMode;
//                settings.timeoutPresentationMode = 10 * 60 * 1000; // ms
//                settings.triggerPresentationMode = Enable_State.TRUE;
//
//                // Change to Level Mode
//                settings.triggerMode = TriggerType.LevelMode;
//                settings.triggerPresentationMode = Enable_State.FALSE;
//
//                //settings.interCharGapSize = InterCharacterGapSize.Normal;
//                //settings.decodingAimingPattern = Enable_State.TRUE;
//                //settings.decodingIllumination  = Enable_State.TRUE;
//                //settings.decodingIlluminationPowerLevel = IlluminationPowerLevel.Zero;
//
//
//                // step4
//                // Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
//                // if user get Err_InvalidParameter, it means user put wrong value into items
//                // if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
//                // if user get S_OK, it means set settings is successful.
//                ClResult clRet = mReaderManager.Set_UserPreferences(settings);
//                if (ClResult.S_ERR == clRet)
//                    Toast.makeText(this, "Get_UserPreferences was failed", Toast.LENGTH_SHORT).show();
//                else if (ClResult.Err_InvalidParameter == clRet)
//                    Toast.makeText(this, "Get_UserPreferences was InvalidParameter",	Toast.LENGTH_SHORT).show();
//                else if (ClResult.Err_NotSupport == clRet)
//                    Toast.makeText(this, "Get_UserPreferences was NotSupport", Toast.LENGTH_SHORT).show();
//                else if (ClResult.S_OK == clRet)
//                    Toast.makeText(this, "Get_UserPreferences was successful", Toast.LENGTH_SHORT).show();
//            }
//        }
//        {
//            if (mReaderManager != null)
//            {
//
//                // step1: new a class, the object is set to default value
//                Code39 settings = new Code39();
//
//                // step2: to check does barcode scanner support this symbology
//                if (ClResult.Err_NotSupport == mReaderManager.Get_Symbology(settings))
//                {
//                    // barcode scanner of device does not support this kind of symbology
//                    return;
//                }
//
//                // step3: if barcode scanner support this symbology�Athen user can change attribute
//                settings.enable = Enable_State.TRUE;
//                settings.fullASCII = Enable_State.TRUE;
//                settings.checkDigitVerification = Enable_State.FALSE;
//                settings.transmitCheckDigit = Enable_State.FALSE;
//                settings.convertToCode32 = Enable_State.FALSE;
//                settings.convertToCode32Prefix = Enable_State.FALSE;
//
//                // step4
//                // Set settings and check retrun value, if user get ClResult.S_ERR, it means failed,
//                // if user get Err_InvalidParameter, it means user put wrong value into items
//                // if user get Err_NotSupport, it means the barcode reader does not support this kind of settings
//                // if user get S_OK, it means set settings is successful.
//                ClResult clRet = mReaderManager.Set_Symbology(settings);
//                if (ClResult.S_ERR == clRet)
//                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was failed", Toast.LENGTH_SHORT).show();
//                else if (ClResult.Err_InvalidParameter == clRet)
//                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was InvalidParameter",	Toast.LENGTH_SHORT).show();
//                else if (ClResult.Err_NotSupport == clRet)
//                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was NotSupport", Toast.LENGTH_SHORT).show();
//                else if (ClResult.S_OK == clRet)
//                    Toast.makeText(this, "Set_Symbology " + settings.getClass().getSimpleName() + " was successful", Toast.LENGTH_SHORT).show();
//            }
//        }
//        if (mReaderManager != null)
//        {
//            Thread sThread = new Thread(new Runnable() {
//
//                @Override
//                public void run() {
//                    mReaderManager.SoftScanTrigger();
//                }
//            });
//            sThread.setPriority( Thread.MAX_PRIORITY );
//            sThread.start();
//        }
//    }

    private final BroadcastReceiver myDataReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(GeneralString.Intent_SOFTTRIGGER_DATA)) {

                // extra string from intent
                decoded_data = intent.getStringExtra(GeneralString.BcReaderData);
                Log.d("ScannerData", "Intent_SOFTTRIGGER_DATA Decoded Data: " + decoded_data);

                if (pendingResult != null) {
                    pendingResult.success(decoded_data);
                    pendingResult = null; // Reset after sending response
                }


            }
            else if (intent.getAction().equals(GeneralString.Intent_PASS_TO_APP)){
                // If user disable KeyboardEmulation, barcode reader service will broadcast Intent_PASS_TO_APP

                // extra string from intent
                decoded_data = intent.getStringExtra(GeneralString.BcReaderData);
                Log.d("ScannerData", "Intent_PASS_TO_APP Decoded Data: " + decoded_data);

                if (pendingResult != null) {
                    pendingResult.success(decoded_data);
                    pendingResult = null; // Reset after sending response
                }

//                // show decoded data
//                mDecodeCount++;
//                e1.setText("[" + mDecodeCount + "]   " + data);

            }
            else if(intent.getAction().equals(GeneralString.Intent_READERSERVICE_CONNECTED)){
                // Make sure this app bind to barcode reader service , then user can use APIs to get/set settings from barcode reader service

                BcReaderType myReaderType = mReaderManager.GetReaderType();
//                e1.setText(myReaderType.toString());


                ReaderOutputConfiguration settings = new ReaderOutputConfiguration();
                mReaderManager.Get_ReaderOutputConfiguration(settings);
                settings.enableKeyboardEmulation = KeyboardEmulationType.None;
                settings.autoEnterWay = OutputEnterWay.Disable;
                settings.autoEnterChar = OutputEnterChar.None;
                settings.showCodeLen = Enable_State.TRUE;
                settings.showCodeType = Enable_State.TRUE;
                settings.szPrefixCode = "";
                settings.szSuffixCode = "";
                settings.useDelim = ':';

                mReaderManager.Set_ReaderOutputConfiguration(settings);

                mReaderManager.SetActive(true);

                Log.d("ScannerData", "Intent_READERSERVICE_CONNECTED Called ");

            }


//            if (intent.getAction().equals(GeneralString.Intent_SOFTTRIGGER_DATA)) {
//                decoded_data = intent.getStringExtra(GeneralString.BcReaderData);
//                Log.d("ScannerData", "Decoded Data: " + decoded_data);
//
//                if (pendingResult != null) {
//                    pendingResult.success(decoded_data);
//                    pendingResult = null; // Reset after sending response
//                }
//            }
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
        Log.d("ScannerData", "Decode Data : "+arg0);
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