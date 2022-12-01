package net.archethic.yubikit_android

import android.util.Log
import com.yubico.yubikit.core.smartcard.ApduException
import com.yubico.yubikit.core.smartcard.SW
import io.flutter.plugin.common.MethodChannel.Result

import com.yubico.yubikit.piv.InvalidPinException
import com.yubico.yubikit.piv.PivSession
import java.util.HashMap

enum class YubikitError(val code: String) {
    other("OTHER"),
    dataError("INVALID_DATA"),
    alreadyConnectedFailure("ALREADY_CONNECTED"),
    notConnectedFailure("NOT_CONNECTED"),
    unsupportedOperation("UNSUPPORTED_OPERATION"),
    invalidPin("INVALID_PIN"),
    authMethodBlocked("AUTH_METHOD_BLOCKED"),
    invalidMangementKey("INVALID_MANAGEMENT_KEY"),
    securityConditionNotSatisfied("SECURITY_CONDITION_NOT_SATISFIED"),
    deviceError("DEVICE_ERROR"),
}

fun guard( result: Result, task: () -> Unit) {
    try {
        task()
    } catch (e: Exception) {
        Log.d("GUARD", "exception", e)
        val error = when (e) {
            is InvalidPinException ->
                YubikitError.invalidPin
            is ApduException -> when (e.sw){
                SW.AUTH_METHOD_BLOCKED -> YubikitError.authMethodBlocked
                SW.SECURITY_CONDITION_NOT_SATISFIED -> YubikitError.securityConditionNotSatisfied
                else -> YubikitError.deviceError
            }
            else -> YubikitError.other
        }

        result.error(
            error.code,
            e.localizedMessage,
            null
        )
    }
}
