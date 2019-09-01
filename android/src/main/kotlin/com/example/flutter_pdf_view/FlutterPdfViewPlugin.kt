package com.example.flutter_pdf_view


import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.support.v4.app.ActivityCompat
import android.support.v4.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class FlutterPdfViewPlugin(context: Context, activity: Activity): MethodCallHandler {
  private val activity = activity
  private val context = context


  companion object {

    val REQUEST_CODE = 445784

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_pdf_view")
      channel.setMethodCallHandler(FlutterPdfViewPlugin(registrar.context(), registrar.activity()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "openPdfFile") {
      ActivityCompat.requestPermissions(activity, mutableListOf<String>(Manifest.permission.READ_EXTERNAL_STORAGE), REQUEST_CODE);
      print(call.argument<String>("path"))
      val uri = FileProvider.getUriForFile(context, "io.cloudacy.flutter_pdf_view.provider", File(call.argument<String>("path")));
      val intent = Intent(Intent.ACTION_VIEW)
              .setDataAndType(uri,"application/pdf")
              .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

      activity.startActivity(intent)

      result.success(null)
    } else {
      result.notImplemented()
    }
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }
}
