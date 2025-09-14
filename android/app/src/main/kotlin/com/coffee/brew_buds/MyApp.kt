package com.coffee.brew_buds

import android.app.Application
import com.navercorp.nid.NaverIdLoginSDK
import com.coffee.brew_buds.R

class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // strings.xml 또는 Gradle resValue로 주입된 값 사용
        NaverIdLoginSDK.initialize(
            this,
            getString(R.string.client_id),
            getString(R.string.client_secret),
            getString(R.string.client_name)
        )
    }
}