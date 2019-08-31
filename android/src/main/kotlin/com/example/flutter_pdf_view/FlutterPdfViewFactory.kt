package com.example.flutter_pdf_view

import java.util.concurrent.atomic.AtomicInteger

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Bitmap.createBitmap
import android.os.ParcelFileDescriptor
import android.view.View

import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.graphics.pdf.PdfRenderer
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.StandardMessageCodec
import java.io.File
import java.util.*
import android.graphics.pdf.PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY
import android.widget.ImageView


class FlutterPdfViewFactory(private val activityState: AtomicInteger, private val pluginRegistrar: Registrar) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return FlutterPdfView(id, context, activityState, pluginRegistrar)
    }
}

class FlutterPdfView(private val id: Int, private val context: Context, private val activityState: AtomicInteger, private val registrar: Registrar, private val args: Dictionary<String, Any>): PlatformView, MethodCallHandler {
    override fun getView(): View {
        // create a new renderer
        print(args)
        val renderer = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val file = File(args["path"] as String)
            val fileDescriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
            val renderer = PdfRenderer(fileDescriptor)

            val imageView = ImageView(context)

            val pageCount = renderer.getPageCount()
            for (i in 0 until pageCount) {
                val page = renderer.openPage(i)

                // say we render for showing on the screen
                val bitmap = createBitmap(page.width, page.height, Bitmap.Config.ARGB_8888)
                page.render(bitmap, null, null, RENDER_MODE_FOR_DISPLAY)

                // do stuff with the bitmap
                

                // close the page
                page.close()
            }

            renderer.close()
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }
    }

    override fun dispose() {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
}