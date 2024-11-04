package com.talkingdata.demo;

import android.app.Application;

import com.tendcloud.tenddata.TalkingDataSDK;


public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        TalkingDataSDK.initSDK(this, "D0978C5B7C1C41E693D14DCA29D8B595", "TalkingData", "custom");
        TalkingDataSDK.startA(this);
    }
}
