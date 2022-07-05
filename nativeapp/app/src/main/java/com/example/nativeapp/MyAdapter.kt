package com.example.nativeapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MyAdapter(var num:Int) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    private var flutterView: FlutterView? = null
    private var flutterEngine: FlutterEngine? = null

    fun changeNum(n:Int){
        this.num=n;
        var mc= flutterEngine?.dartExecutor?.let { MethodChannel(it.binaryMessenger,"num") };
        if (mc != null) {
            mc.invokeMethod("update",num)
        }
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): RecyclerView.ViewHolder {
        val mView = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_card, parent, false)

        flutterView = FlutterView(parent.context)
        flutterEngine = FlutterEngineCache.getInstance().get("flutter_view_id")
        return MyViewHolder(mView)
    }

    override fun onBindViewHolder(
        holder: RecyclerView.ViewHolder,
        position: Int
    ) {
        print(position)
        holder as MyViewHolder
        if (position+num == 3+num) {
            holder.cardView.addView(flutterView)
            flutterEngine?.let { flutterView?.attachToFlutterEngine(it)}
            println(position.toString()+" flutter")
        }
        else if(position==9){
            holder.cardText.text = (position+num).toString()
            println("kotlin")
        }
        else{
            holder.cardText.text = (position+num).toString()
            println("kotlin")
        }
    }

    override fun getItemCount(): Int {
        return 10
    }

    class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var cardView: FrameLayout = itemView.findViewById(R.id.layout_card)
        var cardText: TextView = itemView.findViewById(R.id.text_card)
    }
}