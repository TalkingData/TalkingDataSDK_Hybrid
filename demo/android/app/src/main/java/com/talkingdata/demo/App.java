package com.talkingdata.demo;

import android.app.Application;

import com.tendcloud.tenddata.TalkingDataSDK;


public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        TalkingDataSDK.init(this, "DE40FB8A722D454B8981E2F842E6AAB6", "TalkingData", "custom");
    }
}
