package net.archethic.yubikit_android

import android.app.Activity
import android.content.Context
import android.nfc.NfcAdapter
import android.util.Log
import androidx.annotation.NonNull
import com.yubico.yubikit.android.YubiKitManager
import com.yubico.yubikit.android.transport.nfc.NfcConfiguration
import com.yubico.yubikit.android.transport.nfc.NfcNotAvailable
import com.yubico.yubikit.core.smartcard.ApduException
import com.yubico.yubikit.core.smartcard.SW.*
import com.yubico.yubikit.core.smartcard.SmartCardConnection
import com.yubico.yubikit.piv.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.security.KeyFactory
import java.security.interfaces.ECPublicKey
import java.security.spec.X509EncodedKeySpec
import java.util.*


/** YubikitAndroidPlugin */
class YubikitAndroidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var yubikitManager: YubiKitManager

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "net.archethic/yubidart")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        yubikitManager = YubiKitManager(context)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isNfcEnabled" -> {
                val adapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(context);

                result.success(adapter != null && adapter.isEnabled());
            }
            "pivCalculateSecret" -> {
                Log.d("PIV Calculate secret", "begin")

                val arguments = call.arguments as? HashMap<String, Any>
                val pin = arguments?.get("pin") as? String
                val slot = when (val rawSlot = arguments?.get("slot") as? Int) {
                    null -> null
                    else -> Slot.fromValue(rawSlot)
                }
                val peerPublicKey =
                    when (val rawPeerPublicKey = arguments?.get("peerPublicKey") as? ByteArray) {
                        null -> null
                        else -> KeyFactory.getInstance("EC")
                            .generatePublic(X509EncodedKeySpec(rawPeerPublicKey)) as ECPublicKey
                    }


                if (slot == null || peerPublicKey == null) {
                    result.error(
                        YubikitError.dataError.code,
                        "Data or format error",
                        call.arguments,
                    )
                    return
                }

                Log.d("PIV Calculate secret", "arguments parsed")
                yubikitManager.startNfcDiscovery(NfcConfiguration(), activity) { device ->
                    device.requestConnection(SmartCardConnection::class.java) { connectionResult ->
                        guard(result) {
                            Log.d("PIV Calculate secret", "device discovered")

                            val connection = connectionResult.getValue()
                            val piv = PivSession(connection)
                            Log.d("PIV Calculate secret", "piv session ok")

                            if (pin != null) {
                                piv.verifyPin(
                                    pin.toCharArray()
                                )
                            }

                            val secret = piv.calculateSecret(slot, peerPublicKey)
                            Log.d("PIV Calculate secret", "secret calculated : $secret")

                            result.success(secret)
                        }
                    }
                }
            }
            "pivGenerateKey" -> {
                Log.d("AUTHENT START", "GO")

                val arguments = call.arguments as? HashMap<String, Any>
                val pin = arguments?.get("pin") as? String
                val managementKey = arguments?.get("managementKey") as? ByteArray
                val managementKeyType =
                    when (val rawManagementKeyType = arguments?.get("managementKeyType") as? Int) {
                        null -> null
                        else -> ManagementKeyType.fromValue(rawManagementKeyType.toByte())
                    }
                val slot = when (val rawSlot = arguments?.get("slot") as? Int) {
                    null -> null
                    else -> Slot.fromValue(rawSlot)
                }
                val keyType = when (val rawKeyType = arguments?.get("type") as? Int) {
                    null -> null
                    else -> KeyType.fromValue(rawKeyType)
                }
                val pinPolicy = when (val rawPinPolicy = arguments?.get("pinPolicy") as? Int) {
                    null -> null
                    else -> PinPolicy.fromValue(rawPinPolicy)
                }
                val touchPolicy =
                    when (val rawTouchPolicy = arguments?.get("touchPolicy") as? Int) {
                        null -> null
                        else -> TouchPolicy.fromValue(rawTouchPolicy)
                    }

                if (pin == null || managementKey == null || managementKeyType == null || slot == null || keyType == null || pinPolicy == null || touchPolicy == null) {
                    result.error(
                        YubikitError.dataError.code,
                        "Data or format error",
                        call.arguments,
                    )
                    return
                }

                Log.d("AUTHENTICATE", "BEFORE")

                yubikitManager.startNfcDiscovery(NfcConfiguration(), activity) { device ->
                    device.requestConnection(SmartCardConnection::class.java) { connectionResult ->
                        guard(result) {
                            val connection = connectionResult.getValue()
                            val piv = PivSession(connection)
                            Log.d("AUTHENTICATE", "GO")
                            piv.authenticate(
                                managementKeyType,
                                managementKey,
                            )
                            piv.verifyPin(
                                pin.toCharArray()
                            )
                            val publicKey = piv.generateKey(
                                slot,
                                keyType,
                                pinPolicy,
                                touchPolicy,
                            )

                            Log.d("AUTHENTICATE", "DONE")
                            result.success(publicKey.encoded)
                        }
                    }
                }
            }
            "pivGetCertificate" -> {
                Log.d("PIV Get Certificate", "Start")

                val arguments = call.arguments as? HashMap<String, Any>
                val pin = arguments?.get("pin") as? String
                val slot = when (val rawSlot = arguments?.get("slot") as? Int) {
                    null -> null
                    else -> Slot.fromValue(rawSlot)
                }


                if (pin == null || slot == null) {
                    result.error(
                        YubikitError.dataError.code,
                        "Data or format error",
                        call.arguments,
                    )
                    return
                }

                Log.d("PIV Get Certificate", "Params parsed")

                yubikitManager.startNfcDiscovery(NfcConfiguration(), activity) { device ->
                    device.requestConnection(SmartCardConnection::class.java) { connectionResult ->
                        guard(result) {
                            val connection = connectionResult.getValue()
                            val piv = PivSession(connection)
                            Log.d("PIV Get Certificate", "GO")
                            piv.verifyPin(
                                pin.toCharArray()
                            )
                            Log.d("PIV Get Certificate", "Authentication OK")
                            val certificate = piv.getCertificate(slot)
                            Log.d("PIV Get Certificate", "DONE")
                            result.success(certificate.encoded)
                        }
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
