package com.coffee.brew_buds

import android.os.Bundle
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.navercorp.nid.oauth.OAuthLoginCallback
import com.navercorp.nid.oauth.NidOAuthLogin
import com.navercorp.nid.NaverIdLoginSDK

class MainActivity : FlutterFragmentActivity() {

    private lateinit var channel: MethodChannel
    private var pendingResult: MethodChannel.Result? = null

    private val naverLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result: ActivityResult ->
        val r = pendingResult ?: return@registerForActivityResult
        pendingResult = null

        if (result.resultCode == RESULT_OK) {
            val map = mapOf(
                "accessToken" to (NaverIdLoginSDK.getAccessToken() ?: ""),
                "refreshToken" to (NaverIdLoginSDK.getRefreshToken() ?: ""),
                "expiresAt"   to (NaverIdLoginSDK.getExpiresAt()?.toString() ?: ""),
                "tokenType"   to (NaverIdLoginSDK.getTokenType() ?: ""),
                "state"       to (NaverIdLoginSDK.getState().toString())
            )
            r.success(map)
        } else {
            val code = NaverIdLoginSDK.getLastErrorCode().code
            val desc = NaverIdLoginSDK.getLastErrorDescription()
            r.error("LOGIN_FAIL", "errorCode=$code, desc=$desc", null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.brewbuds/naver_login"
        )
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "login" -> {
                    if (pendingResult != null) {
                        result.error("BUSY", "Login already in progress", null)
                        return@setMethodCallHandler
                    }
                    pendingResult = result
                    // 네이버앱/커스텀탭 자동 선택
                    NaverIdLoginSDK.authenticate(this, naverLauncher) // 권장 호출 방식
                }
                "logout" -> {
                    NaverIdLoginSDK.logout()
                    result.success(true)
                }
                "unlink" -> {
                    // 서버쪽 토큰까지 삭제 (성공/실패에 상관없이 로컬 로그아웃은 수행)
                    NidOAuthLogin().callDeleteTokenApi(object : OAuthLoginCallback {
                        override fun onSuccess() {
                            NaverIdLoginSDK.logout()
                            result.success(true)
                        }

                        override fun onFailure(httpStatus: Int, message: String) {
                            // 그래도 로컬 토큰은 비움
                            NaverIdLoginSDK.logout()
                            val code = NaverIdLoginSDK.getLastErrorCode().code
                            val desc = NaverIdLoginSDK.getLastErrorDescription()
                            result.error("UNLINK_FAIL", "code=$code, desc=$desc", null)
                        }

                        override fun onError(errorCode: Int, message: String) {
                            onFailure(errorCode, message)
                        }
                    })
                }
                else -> result.notImplemented()
            }
        }
    }
}