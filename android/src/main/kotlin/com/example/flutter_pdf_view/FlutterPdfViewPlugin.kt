package com.example.flutter_pdf_view


import android.app.Activity
import android.content.Context
import android.content.Intent
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

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_pdf_view")
      channel.setMethodCallHandler(FlutterPdfViewPlugin(registrar.context(), registrar.activity()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "openPdfFile") {
      print(call.argument<String>("path"))
      val uri = FileProvider.getUriForFile(context, "io.cloudacy.flutter_pdf_view.provider", File(call.argument<String>("path")));
      val intent = Intent(Intent.ACTION_VIEW)
              .setDataAndType(uri,"application/pdf")
              .setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

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
