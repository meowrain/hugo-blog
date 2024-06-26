---
title: Java Spring笔记05 工厂模式 设计模式
subtitle:
date: 2024-05-23T12:16:38+08:00
slug: b5d8f62
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Spring
  - Java
categories:
  - Java
    - Spring
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

# 工厂模式的三种形态

工厂模式通常有三种形态：

● 第一种：简单工厂模式（Simple Factory）：不属于23种设计模式之一。简单工厂模式又叫做：静态 工厂方法模式。简单工厂模式是工厂方法模式的一种特殊实现。

● 第二种：工厂方法模式（Factory Method）：是23种设计模式之一。

● 第三种：抽象工厂模式（Abstract Factory）：是23种设计模式之一。



# 简单工厂模式

简单工厂模式的角色包括三个：

● 抽象产品 角色

● 具体产品 角色

● 工厂类 角色

抽象产品角色：
```java
package com.powernode.factory;

/**
 * 武器（抽象产品角色）
 * @author 动力节点
 * @version 1.0
 * @className Weapon
 * @since 1.0
 **/
public abstract class Weapon {
    /**
     * 所有的武器都有攻击行为
     */
    public abstract void attack();
}
```


具体产品角色：
```java
package com.powernode.factory;

/**
 * 坦克（具体产品角色）
 * @author 动力节点
 * @version 1.0
 * @className Tank
 * @since 1.0
 **/
public class Tank extends Weapon{
    @Override
    public void attack() {
        System.out.println("坦克开炮！");
    }
}

```


```java
package com.powernode.factory;

/**
 * 战斗机（具体产品角色）
 * @author 动力节点
 * @version 1.0
 * @className Fighter
 * @since 1.0
 **/
public class Fighter extends Weapon{
    @Override
    public void attack() {
        System.out.println("战斗机投下原子弹！");
    }
}

```

```java
package com.powernode.factory;

/**
 * 匕首（具体产品角色）
 * @author 动力节点
 * @version 1.0
 * @className Dagger
 * @since 1.0
 **/
public class Dagger extends Weapon{
    @Override
    public void attack() {
        System.out.println("砍他丫的！");
    }
}

```


工厂类角色：
```java
package com.powernode.factory;

/**
 * 工厂类角色
 * @author 动力节点
 * @version 1.0
 * @className WeaponFactory
 * @since 1.0
 **/
public class WeaponFactory {
    /**
     * 根据不同的武器类型生产武器
     * @param weaponType 武器类型
     * @return 武器对象
     */
    public static Weapon get(String weaponType){
        if (weaponType == null || weaponType.trim().length() == 0) {
            return null;
        }
        Weapon weapon = null;
        if ("TANK".equals(weaponType)) {
            weapon = new Tank();
        } else if ("FIGHTER".equals(weaponType)) {
            weapon = new Fighter();
        } else if ("DAGGER".equals(weaponType)) {
            weapon = new Dagger();
        } else {
            throw new RuntimeException("不支持该武器！");
        }
        return weapon;
    }
}

```


测试程序（客户端程序）：

```java
package com.powernode.factory;

/**
 * @author 动力节点
 * @version 1.0
 * @className Client
 * @since 1.0
 **/
public class Client {
    public static void main(String[] args) {
        Weapon weapon1 = WeaponFactory.get("TANK");
        weapon1.attack();

        Weapon weapon2 = WeaponFactory.get("FIGHTER");
        weapon2.attack();

        Weapon weapon3 = WeaponFactory.get("DAGGER");
        weapon3.attack();
    }
}

```
![](https://static.meowrain.cn/i/2024/01/10/sa7hww-3.webp)

简单工厂模式的优点：

● 客户端程序不需要关心对象的创建细节，需要哪个对象时，只需要向工厂索要即可，初步实现了责任的分离。客户端只负责“消费”，工厂负责“生产”。生产和消费分离。

简单工厂模式的缺点：

● 缺点1：工厂类集中了所有产品的创造逻辑，形成一个无所不知的全能类，有人把它叫做上帝类。显然工厂类非常关键，不能出问题，一旦出问题，整个系统瘫痪。

● 缺点2：不符合OCP开闭原则，在进行系统扩展时，需要修改工厂类。
> **Spring中的BeanFactory就使用了简单工厂模式。**


## 工厂方法模式

工厂方法模式既保留了简单工厂模式的优点，同时又解决了简单工厂模式的缺点。

工厂方法模式的角色包括：

● 抽象工厂角色

● 具体工厂角色

● 抽象产品角色

● 具体产品角色



```java
抽象产品角色
package com.powernode.factory;

/**
 * 武器类（抽象产品角色）
 * @author 动力节点
 * @version 1.0
 * @className Weapon
 * @since 1.0
 **/
public abstract class Weapon {
    /**
     * 所有武器都有攻击行为
     */
    public abstract void attack();
}

```

```java
具体产品角色
package com.powernode.factory;

/**
 * 具体产品角色
 * @author 动力节点
 * @version 1.0
 * @className Gun
 * @since 1.0
 **/
public class Gun extends Weapon{
    @Override
    public void attack() {
        System.out.println("开枪射击！");
    }
}

```

```java
具体产品角色
package com.powernode.factory;

/**
 * 具体产品角色
 * @author 动力节点
 * @version 1.0
 * @className Fighter
 * @since 1.0
 **/
public class Fighter extends Weapon{
    @Override
    public void attack() {
        System.out.println("战斗机发射核弹！");
    }
}

```

```java
抽象工厂角色
package com.powernode.factory;

/**
 * 武器工厂接口(抽象工厂角色)
 * @author 动力节点
 * @version 1.0
 * @className WeaponFactory
 * @since 1.0
 **/
public interface WeaponFactory {
    Weapon get();
}

```

```java
具体工厂角色
package com.powernode.factory;

/**
 * 具体工厂角色
 * @author 动力节点
 * @version 1.0
 * @className GunFactory
 * @since 1.0
 **/
public class GunFactory implements WeaponFactory{
    @Override
    public Weapon get() {
        return new Gun();
    }
}

```


```java
具体工厂角色
package com.powernode.factory;

/**
 * 具体工厂角色
 * @author 动力节点
 * @version 1.0
 * @className FighterFactory
 * @since 1.0
 **/
public class FighterFactory implements WeaponFactory{
    @Override
    public Weapon get() {
        return new Fighter();
    }
}

```



```java
客户端
package com.powernode.factory;

/**
 * @author 动力节点
 * @version 1.0
 * @className Client
 * @since 1.0
 **/
public class Client {
    public static void main(String[] args) {
        WeaponFactory factory = new GunFactory();
        Weapon weapon = factory.get();
        weapon.attack();

        WeaponFactory factory1 = new FighterFactory();
        Weapon weapon1 = factory1.get();
        weapon1.attack();
    }
}

```

![](https://static.meowrain.cn/i/2024/01/10/sd4p26-3.webp)

如果想扩展一个新的产品，只要新增一个产品类，再新增一个该产品对应的工厂即可，例如新增：匕首
```java
package com.powernode.factory;

/**
 * @author 动力节点
 * @version 1.0
 * @className Dagger
 * @since 1.0
 **/
public class Dagger extends Weapon{
    @Override
    public void attack() {
        System.out.println("砍丫的！");
    }
}
```

```java
package com.powernode.factory;

/**
 * @author 动力节点
 * @version 1.0
 * @className DaggerFactory
 * @since 1.0
 **/
public class DaggerFactory implements WeaponFactory{
    @Override
    public Weapon get() {
        return new Dagger();
    }
}

```

```java
package com.powernode.factory;

/**
 * @author 动力节点
 * @version 1.0
 * @className Client
 * @since 1.0
 **/
public class Client {
    public static void main(String[] args) {
        WeaponFactory factory = new GunFactory();
        Weapon weapon = factory.get();
        weapon.attack();

        WeaponFactory factory1 = new FighterFactory();
        Weapon weapon1 = factory1.get();
        weapon1.attack();

        WeaponFactory factory2 = new DaggerFactory();
        Weapon weapon2 = factory2.get();
        weapon2.attack();
    }
}

```


执行结果如下：
![](https://static.meowrain.cn/i/2024/01/10/sdpm4r-3.webp)

我们可以看到在进行功能扩展的时候，不需要修改之前的源代码，显然工厂方法模式符合OCP原则。

> ocp原则详情见 https://meowrain.cn/archives/diveintodesignpatterns%E8%AF%BB%E4%B9%A6%E7%AC%94%E8%AE%B0
> 中的开闭原则

工厂方法模式的优点：

● 一个调用者想创建一个对象，只要知道其名称就可以了。 

● 扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。

● 屏蔽产品的具体实现，调用者只关心产品的接口。

工厂方法模式的缺点：

● 每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。


# 抽象工厂模式（了解）

抽象工厂模式相对于工厂方法模式来说，就是工厂方法模式是针对一个产品系列的，而抽象工厂模式是针对多个产品系列的，即工厂方法模式是一个产品系列一个工厂类，而抽象工厂模式是多个产品系列一个工厂类。

抽象工厂模式特点：抽象工厂模式是所有形态的工厂模式中最为抽象和最具一般性的一种形态。抽象工厂模式是指当有多个抽象角色时，使用的一种工厂模式。抽象工厂模式可以向客户端提供一个接口，使客户端在不必指定产品的具体的情况下，创建多个产品族中的产品对象。它有多个抽象产品类，每个抽象产品类可以派生出多个具体产品类，一个抽象工厂类，可以派生出多个具体工厂类，每个具体工厂类可以创建多个具体产品类的实例。每一个模式都是针对一定问题的解决方案，工厂方法模式针对的是一个产品等级结构；而抽象工厂模式针对的是多个产品等级结果。

抽象工厂中包含4个角色：

● 抽象工厂角色

● 具体工厂角色

● 抽象产品角色

● 具体产品角色

![](https://static.meowrain.cn/i/2024/01/10/shd7o4-3.webp)

抽象工厂模式代码如下：

第一部分：武器产品族

```java
package com.powernode.product;

/**
 * 武器产品族
 * @author 动力节点
 * @version 1.0
 * @className Weapon
 * @since 1.0
 **/
public abstract class Weapon {
    public abstract void attack();
}

```

---

```java
package com.powernode.product;

/**
 * 武器产品族中的产品等级1
 * @author 动力节点
 * @version 1.0
 * @className Gun
 * @since 1.0
 **/
public class Gun extends Weapon{
    @Override
    public void attack() {
        System.out.println("开枪射击！");
    }
}

```

---

```java
package com.powernode.product;

/**
 * 武器产品族中的产品等级2
 * @author 动力节点
 * @version 1.0
 * @className Dagger
 * @since 1.0
 **/
public class Dagger extends Weapon{
    @Override
    public void attack() {
        System.out.println("砍丫的！");
    }
}

```

---

第二部分：水果产品族
```java

package com.powernode.product;

/**
 * 水果产品族
 * @author 动力节点
 * @version 1.0
 * @className Fruit
 * @since 1.0
 **/
public abstract class Fruit {
    /**
     * 所有果实都有一个成熟周期。
     */
    public abstract void ripeCycle();
}

```

---


```java
package com.powernode.product;

/**
 * 水果产品族中的产品等级1
 * @author 动力节点
 * @version 1.0
 * @className Orange
 * @since 1.0
 **/
public class Orange extends Fruit{
    @Override
    public void ripeCycle() {
        System.out.println("橘子的成熟周期是10个月");
    }
}

```

---

```java
package com.powernode.product;

/**
 * 水果产品族中的产品等级2
 * @author 动力节点
 * @version 1.0
 * @className Apple
 * @since 1.0
 **/
public class Apple extends Fruit{
    @Override
    public void ripeCycle() {
        System.out.println("苹果的成熟周期是8个月");
    }
}

```

---


第三部分：抽象工厂类
```java
package com.powernode.factory;

import com.powernode.product.Fruit;
import com.powernode.product.Weapon;

/**
 * 抽象工厂
 * @author 动力节点
 * @version 1.0
 * @className AbstractFactory
 * @since 1.0
 **/
public abstract class AbstractFactory {
    public abstract Weapon getWeapon(String type);
    public abstract Fruit getFruit(String type);
}

```

---


第四部分：具体工厂类
```java
package com.powernode.factory;

import com.powernode.product.Dagger;
import com.powernode.product.Fruit;
import com.powernode.product.Gun;
import com.powernode.product.Weapon;

/**
 * 武器族工厂
 * @author 动力节点
 * @version 1.0
 * @className WeaponFactory
 * @since 1.0
 **/
public class WeaponFactory extends AbstractFactory{

    public Weapon getWeapon(String type){
        if (type == null || type.trim().length() == 0) {
            return null;
        }
        if ("Gun".equals(type)) {
            return new Gun();
        } else if ("Dagger".equals(type)) {
            return new Dagger();
        } else {
            throw new RuntimeException("无法生产该武器");
        }
    }

    @Override
    public Fruit getFruit(String type) {
        return null;
    }
}

```

```java
package com.powernode.factory;

import com.powernode.product.*;

/**
 * 水果族工厂
 * @author 动力节点
 * @version 1.0
 * @className FruitFactory
 * @since 1.0
 **/
public class FruitFactory extends AbstractFactory{
    @Override
    public Weapon getWeapon(String type) {
        return null;
    }

    public Fruit getFruit(String type){
        if (type == null || type.trim().length() == 0) {
            return null;
        }
        if ("Orange".equals(type)) {
            return new Orange();
        } else if ("Apple".equals(type)) {
            return new Apple();
        } else {
            throw new RuntimeException("我家果园不产这种水果");
        }
    }
}

```

---


第五部分：客户端程序

```java
package com.powernode.client;

import com.powernode.factory.AbstractFactory;
import com.powernode.factory.FruitFactory;
import com.powernode.factory.WeaponFactory;
import com.powernode.product.Fruit;
import com.powernode.product.Weapon;

/**
 * @author 动力节点
 * @version 1.0
 * @className Client
 * @since 1.0
 **/
public class Client {
    public static void main(String[] args) {
        // 客户端调用方法时只面向AbstractFactory调用方法。
        AbstractFactory factory = new WeaponFactory(); // 注意：这里的new WeaponFactory()可以采用 简单工厂模式 进行隐藏。
        Weapon gun = factory.getWeapon("Gun");
        Weapon dagger = factory.getWeapon("Dagger");

        gun.attack();
        dagger.attack();

        AbstractFactory factory1 = new FruitFactory(); // 注意：这里的new FruitFactory()可以采用 简单工厂模式 进行隐藏。
        Fruit orange = factory1.getFruit("Orange");
        Fruit apple = factory1.getFruit("Apple");

        orange.ripeCycle();
        apple.ripeCycle();
    }
}

```

执行结果：

![](https://static.meowrain.cn/i/2024/01/10/sjxh2y-3.webp)

抽象工厂模式的优缺点：
● 优点：当一个产品族中的多个对象被设计成一起工作时，它能保证客户端始终只使用同一个产品族中的对象。
● 缺点：产品族扩展非常困难，要增加一个系列的某一产品，既要在AbstractFactory里加代码，又要在具体的里面加代码。



