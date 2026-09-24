package co.parakey.parakey_sdk_flutter_example

import android.app.Application
import co.parakey.sdk.Parakey

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        Parakey.initialize(this)
    }
}
