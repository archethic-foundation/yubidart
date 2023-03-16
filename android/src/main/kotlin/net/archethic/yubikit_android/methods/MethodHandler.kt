package net.archethic.yubikit_android.methods

import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface MethodHandler {
     fun handle(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result);
}
