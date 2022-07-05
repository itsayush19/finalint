package com.example.nativeapp

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import org.json.JSONObject
import org.json.JSONTokener
import java.io.IOException

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        //making flutter engine
        FlutterEngine(this).let {
            it.navigationChannel.setInitialRoute("/")
            it.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache
                .getInstance()
                .put("flutter_fragment_id", it)

            var mc=MethodChannel(it.dartExecutor.binaryMessenger, "my_channel")
            mc.setMethodCallHandler{ call,result->
                when(call.method){
                    //APi call
                    "callApi"->{
                        println("Entered")
                        val url="https://api.openweathermap.org/data/2.5/weather?q="+call.argument("data")+"&appid=c486bbcc84c0215de8bea7817e30d13a"
                        println(url)
                        val request=Request.Builder().url(url).build()
                        val client =OkHttpClient()
                        client.newCall(request).enqueue(object: Callback{
                            override fun onResponse(call: Call, response: Response) {
                                var body=response.body
                                val jsonObject=JSONTokener(body?.string()).nextValue() as JSONObject
                                println(jsonObject["name"])
                                //println(response.body?.string())
                                result.success(
                                    jsonObject.toString()
                                )
                            }
                            override fun onFailure(call: Call, e: IOException) {
                                TODO("Not yet implemented")
                                println("Failed")
                                result.success(
                                    "Failed"
                                )
                            }
                        })
                    }
                    else->{
                        println("MainActivity failed")
                    }
                }

            }
        }


        //flutter fragment declare
        val flutterFragment = FlutterFragment
            .withCachedEngine("flutter_fragment_id")
            .build<FlutterFragment>()
        loadFragment(HomeFragment())
        val bottomNav=findViewById<BottomNavigationView>(R.id.bottomNav)
        bottomNav.setOnNavigationItemSelectedListener {
        val f=   when(it.itemId){
                R.id.home->{
                    HomeFragment()
                }
               R.id.message->{
                   flutterFragment
               }
               R.id.settings->{
                   SettingsFragment()
               }
            else->{
                HomeFragment()
            }
            }
            loadFragment(f)
            return@setOnNavigationItemSelectedListener true
        }

    }

    private  fun loadFragment(fragment: Fragment){
        val transaction = supportFragmentManager.beginTransaction()
        transaction.replace(R.id.container,fragment)
        transaction.addToBackStack(null)
        transaction.commit()
    }


}