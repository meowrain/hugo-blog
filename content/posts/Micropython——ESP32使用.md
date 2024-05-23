---
title: Micropython——ESP32使用
subtitle:
date: 2024-05-23T12:06:22+08:00
slug: 4a6a66b
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 嵌入式
  - micropython
  - 单片机
categories:
  - 单片机
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: true
lightgallery: true
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

# Pin引脚类的应用

```python
from machine import Pin

# 创建一个输出引脚在0引脚
p0 = Pin(0,Pin.OUT)

# 给P0引脚线输出低电平，再输出高电平
p0.value(0)
p0.value(1)

# 给P0引脚线输出低电平，再输出高电平
p0.on()
p0.off()

# 给P0引脚先输出低电平，再输出高电平
p0.low()
p0.high()

#再P2创建一个输入引脚，并设置上拉电阻
p2 = Pin(2,Pin.IN,Pin.PULL_UP)

# 打印P2的值
print(p2.value())
```





## 软件设计1-点亮一个LED

```python
from machine import Pin
# 构建 pin_12 引脚对象，GPIO12输出
pin_12 = Pin(12,Pin.OUT)
#使Pin12输出高电平
pin_12.high()
```





## 软件设计2-闪烁的LED

```python
from machine import Pin
# 导入time模块
import time
# 构建pin12引脚对象，GPIO12输出
pin_12 = Pin(12,Pin.OUT)
while True:
    pin_12.high()
    time.sleep(1) #延时1秒
    pin_12.low()

```



## 软件设计3-流水灯

![image-20230804104818368](https://static.meowrain.cn/i/2023/08/04/hc2j7w-3.webp)



```python
import time
from machine import Pin


# 定义GPIO引脚对象
pin_index_list = [13,12,14,27,26]
# 定义led对象列表
led_pin_list = []

# 添加LED引脚对象
for i in pin_index_list:
    led_pin_list.append(Pin(i,Pin.Out))

# 初始化引脚对象
for led_pin in led_pin_list:
    led_pin.low() #初始化为关灯状态

while True:
    #逐个点亮LED
    for led_pin in led_pin_list:
        led_pin.high()
        time.sleep(0.5) #延时0.5s
    
    # 逐个熄灭LED
    for led_pin in led_pin_list:
        led_pin.low()
        time.sleep(0.5) #延时0.5
```



## 软件设计3-数码管显示

![image-20230804111141168](https://static.meowrain.cn/i/2023/08/04/idpom0-3.webp)

![image-20230804111728969](https://static.meowrain.cn/i/2023/08/04/ih7fvk-3.webp)

![image-20230804111901074](https://static.meowrain.cn/i/2023/08/04/ii8njz-3.webp)



# 按键消抖

![image-20230804163539194](https://static.meowrain.cn/i/2023/08/04/r1o4t2-3.webp)

![image-20230804163639200](https://static.meowrain.cn/i/2023/08/04/r29kt0-3.webp)

![image-20230804163804560](https://static.meowrain.cn/i/2023/08/04/r397gx-3.webp)

![image-20230804163824846](https://static.meowrain.cn/i/2023/08/04/r3dfh4-3.webp)

```python
import time
from machine import Pin

# 定义按键输入引脚
pin_button = Pin(14,Pin.IN,Pin.PULL_DOWN) 
## 这里按钮接的是电源正极，按下按钮会传递一个高电平，所以我们要使用下拉电阻

# 定义LED输出引脚
pin_led = Pin(2,Pin.OUT)

# 记录LED是否修改过的状态
status = 0

while True:
    if pin_button.value() == 1:
        # 按键消抖
        time.sleep_ms(80)
        # 延时结束后，继续判断状态
        if pin_button.value() == 1 and status == 0:
            status = 1
            pin_led.value(not pin_led.value())
        elif pin_button.value() == 0
            status = 0
            
            
```

# PWM

## PWM 呼吸灯

![image-20230804164936647](https://static.meowrain.cn/i/2023/08/04/r9zwtv-3.webp)

![image-20230804203741120](https://static.meowrain.cn/i/2023/08/04/xp0wis-3.webp)



```python
from machine import Pin,PWM

#创建PWM对象
led = PWM(Pin(12),freq=20000,duty=512)

led.freq() #获取当前频率

led.freq(1000) #设置频率

led.duty() #获取当前占空比

led.duty(200) # 设置占空比

led.duty_u16(12345) # 使用 duty_u16方法

led.duty_ns() #使用duty_ns 方法

led.deinit() #关闭引脚的PWM
```

呼吸灯代码：

```python
import time
from machine import Pin,PWM

# 定义PWM对象
led = PWM(Pin(12,Pin.OUT),freq=1000)
while True:
    # 由暗到亮
    for i in range(1024):
        led.duty(i)
        time.sleep_ms(1)
    # 由亮到灭
    for i in range(1023,0,-1):
        led.duty(i)
        time.sleep_ms(1)
```

## PWM 控制舵机

> 下面是舵机的驱动原理

![image-20230804205343515](https://static.meowrain.cn/i/2023/08/04/xyk79v-3.webp)

> **注意**：舵机单独供电，要和单片机共地
>
> ![image-20230804205519341](https://static.meowrain.cn/i/2023/08/04/xzm0fd-3.webp)
>
> 

![image-20230804205741358](https://static.meowrain.cn/i/2023/08/04/y0xm5b-3.webp)

![image-20230804205807659](https://static.meowrain.cn/i/2023/08/04/y1bnpz-3.webp)



```python
import time
from machine import Pin,PWM

# 定义PWM控制对象
my_servo = PWM(Pin(13))

#定义舵机频率
my_servo.freq(50)

# 使用不通的占空比方法控制转动角度
# duty(),0-1023
# 转动到0° 1023*0.5/20
my_servo.duty(1023*0.5/20);
# duty_u16() 0-65535
# 转动到90° 65535*1.5/20
# myservo.duty(65535*1.5/20)

```

