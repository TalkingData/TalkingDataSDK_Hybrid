package com.example.jrr.myapplication;

import android.annotation.SuppressLint;
import android.content.Context;
import android.webkit.WebView;

import com.tendcloud.tenddata.TalkingDataSDK;
import com.tendcloud.tenddata.TalkingDataProfileType;
import com.tendcloud.tenddata.TalkingDataGender;
import com.tendcloud.tenddata.TalkingDataProfile;
import com.tendcloud.tenddata.TalkingDataSearch;
import com.tendcloud.tenddata.TalkingDataShoppingCart;
import com.tendcloud.tenddata.TalkingDataOrder;
import com.tendcloud.tenddata.TalkingDataTransaction;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Map;

public class TalkingDataSDKHybrid {
    @SuppressLint("StaticFieldLeak")
    private static volatile TalkingDataSDKHybrid tdHybrid;
    private Context ctx;
    private String currencyPageName;
    
    private TalkingDataSDKHybrid() {
        com.tendcloud.tenddata.dz.a = 4;
    }
    
    public static TalkingDataSDKHybrid getInstance() {
        if (tdHybrid == null) {
            synchronized (TalkingDataSDKHybrid.class) {
                if (tdHybrid == null) {
                    tdHybrid = new TalkingDataSDKHybrid();
                }
            }
        }
        return tdHybrid;
    }
    
    public boolean execute(final Context context, final String url, final WebView webView) throws Exception {
        if (url.startsWith("talkingdata")) {
            this.ctx = context;
            String jsonStr = url.substring(12);
            JSONObject jsonObj = new JSONObject(jsonStr);
            String action = jsonObj.getString("action");
            JSONArray arguments = jsonObj.getJSONArray("arguments");
            if (action.equals("getDeviceId")) {
                getDeviceId(arguments, webView);
            } else if (action.equals("getOAID")) {
                getOAID(arguments, webView);
            } else {
                try {
                    Class<TalkingDataSDKHybrid> classType = TalkingDataSDKHybrid.class;
                    Method method = classType.getDeclaredMethod(action, JSONArray.class);
                    method.invoke(this, arguments);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return true;
        }
        return false;
    }
    
    private void getDeviceId(final JSONArray arguments, final WebView webView) throws JSONException {
        String deviceId = TalkingDataSDK.getDeviceId(ctx);
        String callBack = arguments.getString(0);
        webView.loadUrl("javascript:" + callBack + "('" + deviceId + "')");
    }
    
    private void getOAID(final JSONArray arguments, final WebView webView) throws JSONException {
        String oaid = TalkingDataSDK.getOAID(ctx);
        String callBack = arguments.getString(0);
        webView.loadUrl("javascript:" + callBack + "('" + oaid + "')");
    }
    
    @SuppressWarnings("unused")
    private void setVerboseLogDisable(final JSONArray arguments) {
        TalkingDataSDK.setVerboseLogDisable();
    }
    
    @SuppressWarnings("unused")
    private void setLocation(final JSONArray arguments) {
    }
    
    @SuppressWarnings("unused")
    private void onPage(final JSONArray arguments) throws JSONException {
        String pageName = arguments.getString(0);
        if (currencyPageName != null) {
            TalkingDataSDK.onPageEnd(ctx, currencyPageName);
        }
        currencyPageName = pageName;
        TalkingDataSDK.onPageBegin(ctx, pageName);
    }
    
    @SuppressWarnings("unused")
    private void onPageBegin(final JSONArray arguments) throws JSONException {
        String pageName = arguments.getString(0);
        currencyPageName = pageName;
        TalkingDataSDK.onPageBegin(ctx, pageName);
    }
    
    @SuppressWarnings("unused")
    private void onPageEnd(final JSONArray arguments) throws JSONException {
        String pageName = arguments.getString(0);
        currencyPageName = null;
        TalkingDataSDK.onPageEnd(ctx, pageName);
    }
    
    @SuppressWarnings("unused")
    private void onReceiveDeepLink(final JSONArray arguments) throws JSONException {
        String link = arguments.getString(0);
        TalkingDataSDK.onReceiveDeepLink(link);
    }
    
    @SuppressWarnings("unused")
    private void onRegister(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String profileJson = arguments.getString(1);
        TalkingDataProfile profile = profileFromJsonString(profileJson);
        String invitationCode = arguments.getString(2);
        TalkingDataSDK.onRegister(profileId, profile, invitationCode);
    }
    
    @SuppressWarnings("unused")
    private void onLogin(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String profileJson = arguments.getString(1);
        TalkingDataProfile profile = profileFromJsonString(profileJson);
        TalkingDataSDK.onLogin(profileId, profile);
    }
    
    @SuppressWarnings("unused")
    private void onProfileUpdate(final JSONArray arguments) throws JSONException {
        String profileJson = arguments.getString(0);
        TalkingDataProfile profile = profileFromJsonString(profileJson);
        TalkingDataSDK.onProfileUpdate(profile);
    }
    
    @SuppressWarnings("unused")
    private void onCreateCard(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String method = arguments.getString(1);
        String content = arguments.getString(2);
        TalkingDataSDK.onCreateCard(profileId, method, content);
    }
    
    @SuppressWarnings("unused")
    private void onFavorite(final JSONArray arguments) throws JSONException {
        String category = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onFavorite(category, content);
    }
    
    @SuppressWarnings("unused")
    private void onShare(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onShare(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onPunch(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String punchId = arguments.getString(1);
        TalkingDataSDK.onPunch(profileId, punchId);
    }
    
    @SuppressWarnings("unused")
    private void onSearch(final JSONArray arguments) throws JSONException {
        String searchJson = arguments.getString(0);
        TalkingDataSearch search = searchFromJsonString(searchJson);
        TalkingDataSDK.onSearch(search);
    }
    
    @SuppressWarnings("unused")
    private void onContact(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onContact(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onPay(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String orderId = arguments.getString(1);
        int amount = arguments.getInt(2);
        String currencyType = arguments.getString(3);
        String paymentType = arguments.getString(4);
        String itemId = arguments.getString(5);
        int itemCount = arguments.getInt(6);
        TalkingDataSDK.onPay(profileId, orderId, amount, currencyType, paymentType, itemId, itemCount);
    }
    
    @SuppressWarnings("unused")
    private void onChargeBack(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String orderId = arguments.getString(1);
        String reason = arguments.getString(2);
        String type = arguments.getString(3);
        TalkingDataSDK.onChargeBack(profileId, orderId, reason, type);
    }
    
    @SuppressWarnings("unused")
    private void onReservation(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String reservationId = arguments.getString(1);
        String category = arguments.getString(2);
        int amount = arguments.getInt(3);
        String term = arguments.getString(4);
        TalkingDataSDK.onReservation(profileId, reservationId, category, amount, term);
    }
    
    @SuppressWarnings("unused")
    private void onBooking(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String bookingId = arguments.getString(1);
        String category = arguments.getString(2);
        int amount = arguments.getInt(3);
        String content = arguments.getString(4);
        TalkingDataSDK.onBooking(profileId, bookingId, category, amount, content);
    }
    
    @SuppressWarnings("unused")
    private void onViewItem(final JSONArray arguments) throws JSONException {
        String itemId = arguments.getString(0);
        String category = arguments.getString(1);
        String name = arguments.getString(2);
        int unitPrice = arguments.getInt(3);
        TalkingDataSDK.onViewItem(itemId, category, name, unitPrice);
    }
    
    @SuppressWarnings("unused")
    private void onAddItemToShoppingCart(final JSONArray arguments) throws JSONException {
        String itemId = arguments.getString(0);
        String category = arguments.getString(1);
        String name = arguments.getString(2);
        int unitPrice = arguments.getInt(3);
        int amount = arguments.getInt(4);
        TalkingDataSDK.onAddItemToShoppingCart(itemId, category, name, unitPrice, amount);
    }
    
    @SuppressWarnings("unused")
    private void onViewShoppingCart(final JSONArray arguments) throws JSONException {
        String shoppingCartJson = arguments.getString(0);
        TalkingDataShoppingCart shoppingCart = shoppingCartFromJsonString(shoppingCartJson);
        TalkingDataSDK.onViewShoppingCart(shoppingCart);
    }
    
    @SuppressWarnings("unused")
    private void onPlaceOrder(final JSONArray arguments) throws JSONException {
        String orderJson = arguments.getString(0);
        TalkingDataOrder order = orderFromJsonString(orderJson);
        String profileId = arguments.getString(1);
        TalkingDataSDK.onPlaceOrder(order, profileId);
    }
    
    @SuppressWarnings("unused")
    private void onOrderPaySucc(final JSONArray arguments) throws JSONException {
        String orderJson = arguments.getString(0);
        TalkingDataOrder order = orderFromJsonString(orderJson);
        String paymentType = arguments.getString(1);
        String profileId = arguments.getString(2);
        TalkingDataSDK.onOrderPaySucc(order, paymentType, profileId);
    }
    
    @SuppressWarnings("unused")
    private void onCancelOrder(final JSONArray arguments) throws JSONException {
        String orderJson = arguments.getString(0);
        TalkingDataOrder order = orderFromJsonString(orderJson);
        TalkingDataSDK.onCancelOrder(order);
    }
    
    @SuppressWarnings("unused")
    private void onCredit(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        int amount= arguments.getInt(1);
        String content = arguments.getString(2);
        TalkingDataSDK.onCredit(profileId, amount, content);
    }
    
    @SuppressWarnings("unused")
    private void onTransaction(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String transactionJson = arguments.getString(1);
        TalkingDataTransaction transaction = transactionFromJsonString(transactionJson);
        TalkingDataSDK.onTransaction(profileId, transaction);
    }
    
    @SuppressWarnings("unused")
    private void onCreateRole(final JSONArray arguments) throws JSONException {
        String name = arguments.getString(0);
        TalkingDataSDK.onCreateRole(name);
    }
    
    @SuppressWarnings("unused")
    private void onLevelPass(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String levelId = arguments.getString(1);
        TalkingDataSDK.onLevelPass(profileId, levelId);
    }
    
    @SuppressWarnings("unused")
    private void onGuideFinished(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onGuideFinished(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onLearn(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String course = arguments.getString(1);
        long begin = arguments.getLong(2);
        int duration = arguments.getInt(3);
        TalkingDataSDK.onLearn(profileId, course, begin, duration);
    }
    
    @SuppressWarnings("unused")
    private void onPreviewFinished(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onPreviewFinished(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onRead(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String book = arguments.getString(1);
        long begin = arguments.getLong(2);
        int duration = arguments.getInt(3);
        TalkingDataSDK.onRead(profileId, book, begin, duration);
    }
    
    @SuppressWarnings("unused")
    private void onFreeFinished(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onFreeFinished(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onAchievementUnlock(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String achievementId = arguments.getString(1);
        TalkingDataSDK.onAchievementUnlock(profileId, achievementId);
    }
    
    @SuppressWarnings("unused")
    private void onBrowse(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        long begin = arguments.getLong(2);
        int duration = arguments.getInt(3);
        TalkingDataSDK.onBrowse(profileId, content, begin, duration);
    }
    
    @SuppressWarnings("unused")
    private void onTrialFinished(final JSONArray arguments) throws JSONException {
        String profileId = arguments.getString(0);
        String content = arguments.getString(1);
        TalkingDataSDK.onTrialFinished(profileId, content);
    }
    
    @SuppressWarnings("unused")
    private void onEvent(final JSONArray arguments) throws JSONException {
        String eventId = arguments.getString(0);
        String eventDataJson = arguments.getString(1);
        Map<String, Object> eventData = mapFromJsonString(eventDataJson);
        TalkingDataSDK.onEvent(ctx, eventId, eventData);
    }
    
    @SuppressWarnings("unused")
    private void setGlobalKV(final JSONArray arguments) throws JSONException {
        String key = arguments.getString(0);
        Object value = arguments.get(1);
        TalkingDataSDK.setGlobalKV(key, value);
    }
    
    @SuppressWarnings("unused")
    private void removeGlobalKV(final JSONArray arguments) throws JSONException {
        String key = arguments.getString(0);
        TalkingDataSDK.removeGlobalKV(key);
    }
    
    private TalkingDataProfileType profileTypeFromInt(final int type) {
        switch (type) {
            case 1:
                return TalkingDataProfileType.REGISTERED;
            case 2:
                return TalkingDataProfileType.SINA_WEIBO;
            case 3:
                return TalkingDataProfileType.QQ;
            case 4:
                return TalkingDataProfileType.QQ_WEIBO;
            case 5:
                return TalkingDataProfileType.ND91;
            case 6:
                return TalkingDataProfileType.WEIXIN;
            case 11:
                return TalkingDataProfileType.TYPE1;
            case 12:
                return TalkingDataProfileType.TYPE2;
            case 13:
                return TalkingDataProfileType.TYPE3;
            case 14:
                return TalkingDataProfileType.TYPE4;
            case 15:
                return TalkingDataProfileType.TYPE5;
            case 16:
                return TalkingDataProfileType.TYPE6;
            case 17:
                return TalkingDataProfileType.TYPE7;
            case 18:
                return TalkingDataProfileType.TYPE8;
            case 19:
                return TalkingDataProfileType.TYPE9;
            case 20:
                return TalkingDataProfileType.TYPE10;
            default:
                return TalkingDataProfileType.ANONYMOUS;
        }
    }
    
    private TalkingDataGender genderFromInt(final int gender) {
        switch (gender) {
            case 1:
                return TalkingDataGender.MALE;
            case 2:
                return TalkingDataGender.FEMALE;
            default:
                return TalkingDataGender.UNKNOWN;
        }
    }
    
    private Map<String, Object> mapFromJsonString(String json) {
        Map<String, Object> result = new HashMap<>();
        try {
            JSONObject jsonObj = new JSONObject(json);
            Iterator<String> keys = jsonObj.keys();
            String key;
            Object value;
            while (keys.hasNext()) {
                key = keys.next();
                value = jsonObj.get(key);
                result.put(key, value);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return result;
    }

    private TalkingDataProfile profileFromJsonString(String json) {
        try {
            JSONObject profileJson = new JSONObject(json);
            TalkingDataProfile profile = TalkingDataProfile.createProfile();
            profile.setName(profileJson.optString("name", null));
            if (profileJson.has("type")) {
                int type = profileJson.optInt("type", 0);
                profile.setType(profileTypeFromInt(type));
            }
            if (profileJson.has("gender")) {
                int gender = profileJson.optInt("gender", 0);
                profile.setGender(genderFromInt(gender));
            }
            if (profileJson.has("age")) {
                profile.setAge(profileJson.optInt("age", 0));
            }
            profile.setProperty1(profileJson.opt("property1"));
            profile.setProperty2(profileJson.opt("property2"));
            profile.setProperty3(profileJson.opt("property3"));
            profile.setProperty4(profileJson.opt("property4"));
            profile.setProperty5(profileJson.opt("property5"));
            profile.setProperty6(profileJson.opt("property6"));
            profile.setProperty7(profileJson.opt("property7"));
            profile.setProperty8(profileJson.opt("property8"));
            profile.setProperty9(profileJson.opt("property9"));
            profile.setProperty10(profileJson.opt("property10"));
            return profile;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private TalkingDataSearch searchFromJsonString(String json) {
        try {
            JSONObject searchJson = new JSONObject(json);
            TalkingDataSearch search = TalkingDataSearch.createSearch();
            search.setCategory(searchJson.optString("category", null));
            search.setContent(searchJson.optString("content", null));
            search.setItemId(searchJson.optString("itemId", null));
            search.setItemLocationId(searchJson.optString("itemLocationId", null));
            search.setDestination(searchJson.optString("destination", null));
            search.setOrigin(searchJson.optString("origin", null));
            if (searchJson.has("startDate")) {
                search.setStartDate(searchJson.optLong("startDate", 0));
            }
            if (searchJson.has("endDate")) {
                search.setEndDate(searchJson.optLong("endDate", 0));
            }
            return search;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private TalkingDataShoppingCart shoppingCartFromJsonString(String json) {
        try {
            JSONObject shoppingCartJson = new JSONObject(json);
            TalkingDataShoppingCart shoppingCart = TalkingDataShoppingCart.createShoppingCart();
            JSONArray items = shoppingCartJson.getJSONArray("items");
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                shoppingCart.addItem(item.getString("itemId"), item.getString("category"), item.getString("name"), item.getInt("unitPrice"), item.getInt("amount"));
            }
            return shoppingCart;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private TalkingDataOrder orderFromJsonString(String json) {
        try {
            JSONObject orderJson = new JSONObject(json);
            TalkingDataOrder order = TalkingDataOrder.createOrder(orderJson.getString("orderId"), orderJson.getInt("total"), orderJson.getString("currencyType"));
            JSONArray items = orderJson.getJSONArray("items");
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                order.addItem(item.getString("itemId"), item.getString("category"), item.getString("name"), item.getInt("unitPrice"), item.getInt("amount"));
            }
            return order;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private TalkingDataTransaction transactionFromJsonString(String json) {
        try {
            JSONObject transactionJson = new JSONObject(json);
            TalkingDataTransaction transaction = TalkingDataTransaction.createTransaction();
            transaction.setTransactionId(transactionJson.optString("transactionId", null));
            transaction.setCategory(transactionJson.optString("category", null));
            transaction.setAmount(transactionJson.optInt("amount", 0));
            transaction.setPersonA(transactionJson.optString("personA", null));
            transaction.setPersonB(transactionJson.optString("personB", null));
            transaction.setStartDate(transactionJson.optLong("startDate", 0));
            transaction.setEndDate(transactionJson.optLong("endDate", 0));
            transaction.setContent(transactionJson.optString("content", null));
            transaction.setCurrencyType(transactionJson.optString("currencyType", null));
            return transaction;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
