# scripts for testing KSM

## apps:


adapted for China app market.

| Category          | App          |  Launch | Fraction |
| :--               | :--          |     --: |      --: |
| Communication     | Wechat       |      24 |       25 |
|                   | QQ           |      24 |          |
|                   | Phone        |      18 |          |
| Game              | King's Glory |  18 + 8 |       18 |
|                   | XiaoXiaoLe   | 14  + 6 |          |
| Social networking | Weibo        |  18 + 4 |       15 |
|                   | Baidu Tieba  |      16 |          |
| Multimedia        | Camera       |      12 |       11 |
|                   | iqiyi        |      12 |          |
|                   | Gallery      |       4 |          |
| Productivity      | Evernote     |      16 |        9 |
|                   | Adobe Reader |       4 |          |
|                   | Calender     |       4 |          |
| Browser           | Browser      |      20 |        8 |
| Navigation        | Maps         |      12 |        5 |
| News              | Toutiao      |   8 + 4 |        5 |
| Shopping          | Taobao       |      10 |        4 |
| Total             | 17 apps      |     256 |    100.0 |




                                        
# app startup time.

In [App startup time, Andorid
Developer](https://developer.android.com/topic/performance/vitals/launch-time).
Two simple methods are introduced to measure the app startup time. To be more
specific --- the time to inistal display

1. am

``` shell
adb shell am start -W <package name>/<Main activity name> \
 -c android.intent.category.LAUNCHER \
 -a android.intent.action.MAIN 
```

This is buggy. it sometimes gives very huge results, or get stuck and the app is
never launched.

2. logcat.

```
logcat -v V | grep "Displayed "
```
and then start iqiyi, you will see.

```
11-05 03:48:45.351 +0000   904  1417 I ActivityManager: Displayed com.qiyi.video/.WelcomeActivity: +2s314ms
11-05 03:48:51.674 +0000   904  1417 I ActivityManager: Displayed com.qiyi.video/org.qiyi.android.video.MainActivity: +1s808ms
```

The problem is that, first, there may be more than one activity started. in this
case, a welcome activity and a main activity are started, and two time are
reported. Second. When you resume an app, there will be no report.



## 

| Category          | App                  | Launch | Fraction |
| :--               | :--                  |    --: |      --: |
| Communication     | Gamil                |     24 |     25.8 |
|                   | SMS                  |     24 |          |
|                   | Phone                |     18 |          |
| Game              | Candy Crush Saga     |     18 |     18.0 |
|                   | Angrybirds Star Wars |     14 |          |
|                   | Subway Surfer        |     14 |          |
| Social networking | Facebook             |     18 |     14.8 |
|                   | Flipboard            |     16 |          |
|                   | Feedly               |      4 |          |
| Multimedia        | Camera               |     12 |     10.9 |
|                   | youtube              |     12 |          |
|                   | Gallery              |      4 |          |
| Productivity      | Evernote             |     16 |      9.4 |
|                   | Adobe Reader         |      4 |          |
|                   | Calender             |      4 |          |
| Browser           | Browser              |     20 |      7.8 |
| Navigation        | Google Maps          |     12 |      4.7 |
| News              | ESPN ScoreCenter     |      8 |      4.7 |
|                   | Weather              |      4 |          |
| Shopping          | Play Store           |     10 |      3.9 |
| Total             | 20 apps              |    256 |    100.0 |
