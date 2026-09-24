package co.parakey.parakey_sdk_flutter

import androidx.activity.ComponentActivity
import co.parakey.sdk.Parakey
import co.parakey.sdk.ParakeyError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ParakeySdkFlutterPlugin :
    FlutterPlugin,
    ActivityAware,
    ParakeyHostApi {
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        ParakeyHostApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        ParakeyHostApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override suspend fun configure(tokenBundle: String) {
        Parakey.configure(tokenBundle).throwIfError()
    }

    override suspend fun deconfigure() {
        Parakey.deconfigure()
    }

    override suspend fun showScan() {
        Parakey.showScan(requireActivity()).throwIfError()
    }

    override suspend fun unlock(deviceId: String) {
        Parakey.unlock(requireActivity(), deviceId).throwIfError()
    }

    override fun setTheme(theme: ThemeMessage) {
        Parakey.theme(
            actionLight = theme.actionLight?.toInt(),
            actionDark = theme.actionDark?.toInt(),
            titleLight = theme.titleLight?.toInt(),
            titleDark = theme.titleDark?.toInt(),
        )
    }

    private fun requireActivity(): ComponentActivity =
        activityBinding?.activity as? ComponentActivity
            ?: throw FlutterError("noAndroidActivity", "No activity available to present UI")
}

private fun ParakeyError?.throwIfError() {
    if (this != null) throw FlutterError(id)
}
