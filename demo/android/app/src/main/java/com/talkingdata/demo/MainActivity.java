package com.talkingdata.demo;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.tendcloud.tenddata.TalkingDataSDK;

public class MainActivity extends AppCompatActivity {
    @SuppressLint("StaticFieldLeak")
    static Context context;
    
    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        context = getApplicationContext();

        WebView webView = findViewById(R.id.webview);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadUrl("https://talkingdata.github.io/TalkingData_Assets/index.html");
        webView.setWebViewClient(new MyWebviewClient());
    }
    
    class MyWebviewClient extends WebViewClient {
        @Override
        public void onPageFinished(WebView view, String url) {
            view.loadUrl("javascript:setWebViewFlag()");
            TalkingDataSDK.onPageBegin(MainActivity.context, url);
        }
        
        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            String url = request.getUrl().toString();
            try {
                String decodedURL = java.net.URLDecoder.decode(url, "UTF-8");
                TalkingDataSDKHybrid.getInstance().execute(MainActivity.this, decodedURL, view);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        }
    }
}
