# scripts for testing KSM

## apps:

adapted for China app market.

| Category          | App          | Launch | Fraction |
| :--               | :--          |    --: |      --: |
| Communication     | Wechat       |      9 |       25 |
|                   | QQ           |      9 |          |
|                   | Phone        |      7 |          |
| Game              | King's Glory |     10 |       18 |
|                   | XiaoXiaoLe   |      8 |          |
| Social networking | Weibo        |      8 |       15 |
|                   | Baidu Tieba  |      7 |          |
| Multimedia        | Camera       |      5 |       11 |
|                   | iqiyi        |      4 |          |
|                   | Gallery      |      2 |          |
| Productivity      | Evernote     |      5 |        9 |
|                   | Adobe Reader |      2 |          |
|                   | Calender     |      2 |          |
| Browser           | Browser      |      8 |        8 |
| Navigation        | Maps         |      5 |        5 |
| News              | Toutiao      |      5 |        5 |
| Shopping          | Taobao       |      4 |        4 |
| Total             | 17 apps      |    100 |    100.0 |

| app             |        version | package                         |
| :--             |            :-- | :--                             |
| Wechat          |          6.7.3 | com.tencent.mm                  |
| qq              |          7.9.0 | com.tencent.mobileqq            |
| phone(contacts) |      8.1.0.301 | com.android.contacts            |
| kings glory     |       1.42.1.6 | com.tencent.tmgp.sgame          |
| xiaoxiaole      |           1.61 | com.happyelements.AndroidAnimal |
| weibo           |         8.11.2 | com.sina.weibo                  |
| tieba           |       9.8.8.13 | com.baidu.tieba                 |
| camera          |      8.0.0.201 | com.huawei.camera               |
| iqiyi           |         9.11.0 | com.qiyi.video                  |
| gallery         |      8.0.1.312 | com.android.gallery3d           |
| evernote        |          9.2.3 | com.evernote                    |
| adobe reader    |  18.0.0.181869 | com.adobe.reader                |
| calender        |      8.0.0.307 | com.android.calender            |
| browser         |   70.0.3538.80 | com.android.chrome              |
| maps            |         10.3.1 | com.google.android.apps.maps    |
| toutiao         |          6.9.9 | com.ss.android.article.news     |
| taobao          |          8.2.0 | com.taobao.taobao               |

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

This command block until the activity is started, so we
can measure the total time used to run this bench.

If the app is resumed. A warning say this will be printed:

```
Warning: Activity not started, its current task has been brought to the front
```
This is can be counted.



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

## reference

paper: [SmartLMK](https://dl.acm.org/citation.cfm?id=2894755)


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
