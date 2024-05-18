# Java面向对象基础(初级)


# Java面向对象基础(初级)

&gt; 对面向对象和面向过程的理解
&gt;
&gt; [谈谈你对面向过程和面向对象的理解_智十七°的博客-CSDN博客_面向对象和面向过程的理解](https://blog.csdn.net/weixin_45812336/article/details/121717294)

## **面向对象的三大特征**

**封装** (Encapsulation)
**继承** (Inheritance)
**多态** (Polymorphism)

## 初识对象和类

![image-20221207221107547](https://static.meowrain.cn/i/2022/12/08/a3swjm-3.png)

![image-20221207221135590](https://static.meowrain.cn/i/2022/12/08/a3yslr-3.png)

![image-20221207221142578](https://static.meowrain.cn/i/2022/12/08/a409p0-3.png)

![image-20221207222150537](https://static.meowrain.cn/i/2022/12/08/aa0a4k-3.png)

## 初次使用对象和类

&gt; 如下，在下面这个代码中，我创建了一个猫类，然后利用猫类创建了两个猫对象，一个赋值给cat01，一个赋值给cat02

```Java
package cn.meowrain.Object_;

public class relean_01 {
    public static void main(String[] args) {
        //创建两猫对象
        Cat cat01 = new Cat();
        cat01.name = &#34;小花&#34;;
        cat01.age = 1;
        cat01.color = &#34;花色&#34;;
        Cat cat02 = new Cat();
        cat02.name = &#34;小白&#34;;
        cat02.age = 2;
        cat02.color = &#34;白色&#34;;
        //访问对象属性
        System.out.println(cat01.name);
        System.out.println(cat02.name);
        cat01.eat();
        cat02.eat();
    }
}

class Cat {
    public String name;
    public int age;
    public String color;
    public void eat(){
        System.out.println(name &#43; &#34;吃饭&#34;);
    }
    public void drink(){
        System.out.println(name &#43; &#34;喝水&#34;);
    }
}
```

&gt; **new Cat()**  //创建一只猫对象
&gt;
&gt; **Cat cat01 = new Cat();**//把创建的猫对象赋值给cat01
&gt;
&gt; cat01是对象名(对象引用)



### 如何创建一个对象

```java
1) 先声明再创建
Cat cat ; //声明对象 cat
cat = new Cat(); //创建
2) 直接创建
Cat cat = new Cat();
```

&gt; **补充：Java中实例化对象是什么意思**
&gt;
&gt; 在Java语言中使用**new关键字创建/构造对象的过程叫做类的实例化**，该过程的本质，会在[内存](https://so.csdn.net/so/search?q=内存&amp;spm=1001.2101.3001.7020)空间的**堆区申请一块存储区域**，用于**记录该对象独有的成员变量信息**。
&gt;
&gt; 通俗点就是，实例化：使用关键字new来创建对象。
&gt;
&gt; 例如：
&gt; Person person = new Person();
&gt;
&gt; 这样的语句称为创建对象。
&gt;
&gt; 对象是根据类创建的。在Java中使用关键字new创建对象。
&gt;
&gt; new Person(); 是 声明一个Person类型的对象，在堆区区域。
&gt;
&gt; new Person(); ()是指创建Person类型的对象后，自动调用Person类中的构造方法，来进行成员变量的初始化。
&gt;
&gt; Person person ，Person为类名，person 为引用变量名。
&gt; ————————————————
&gt; 版权声明：本文为CSDN博主「智十七°」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
&gt; 原文链接：https://blog.csdn.net/weixin_45812336/article/details/113954823

## 对象在内存中的存在形式

![image-20221207222229633](https://static.meowrain.cn/i/2022/12/08/aaheb6-3.png)



## 属性，成员变量

```java
package cn.meowrain.Object_;

public class relearn_02 {
}
class Hunman {
    //下面都属于Human类的属性
    String name; 
    double salary;
    int age;
    String country;
}
```

&gt;  **属性是类的一个组成部分，一般是基本数据类型,也可是引用类型(对象，数组)。上面这个代码中的`name`,`salary`等都是这个`Human`类的属性**
&gt;
&gt;  ---
&gt;
&gt;  **属性的定义语法同变量，**
&gt;
&gt;  **示例：访问修饰符 属性类型 属性名**
&gt;
&gt;  &gt; 访问修饰符详情见[Java 访问修饰符 - 喵雨の小屋|木更老婆！！！ (meowrain.cn)](https://meowrain.cn/archives/java-fang-wen-xiu-shi-fu)
&gt;
&gt;  ---
&gt;
&gt;  **属性的定义类型可以为任意类型，包含基本类型或引用类型**
&gt;
&gt;  &gt; 基本数据类型和引用数据类型详见[Java数据类型：基本数据类型和引用数据类型 (biancheng.net)](http://c.biancheng.net/view/5672.html)
&gt;  &gt;
&gt;  &gt; ![Java数据类型结构图](https://static.meowrain.cn/i/2022/12/08/ae0mrh-3.jpg)
&gt;  &gt;
&gt;  &gt; [Java数据类型（八种基本数据类型 &#43; 四种引用数据类型）_火火笔记的博客-CSDN博客_引用数据类型有哪几种](https://blog.csdn.net/weixin_42428778/article/details/109603769)
&gt;
&gt;  ---
&gt;
&gt;  属性如果不赋值，有默认值，规则和数组一致。
&gt;
&gt;  具体: ==**int 0，short 0, byte 0, long 0, float 0.0,double 0.0，char \u0000， boolean false，String null**==

### 如何访问属性

&gt; 基本语法 
&gt;
&gt; **对象名.属性名;**

示范：

```java
package cn.meowrain.Object_;

public class relearn_02 {
    Human human01 = new Human();
    human01.name = &#34;mike&#34;;
    human01.age = 20;
    System.out.println(human.name &#43; &#34;is&#34; &#43; human01.age &#43; &#34;years old&#34;)
}
class Hunman {
    //下面都属于Human类的属性
    String name; 
    double salary;
    int age;
    String country;
}
```

## 类和对象的内存分配机制

我们定义一个人类(Person)(包括 名字,年龄)

```java
package cn.meowrain.Object_;

public class relearn_03 {
    public static void main(String[] args) {
        Person p1 = new Person();
        p1.age = 10;
        p1.name = &#34;小明&#34;;
        Person p2 = p1;
        System.out.println(p2.age);
        
    }
}
class Person {
    public int age;
    public String name;
    
}
```

&gt; 问题：`p2.age` 究竟是多少，画出内存图
&gt;
&gt; ![image-20221207224810174](https://static.meowrain.cn/i/2022/12/08/apujhh-3.png)

### Java 内存的结构分析 

1) **栈： 一般存放基本数据类型(局部变量)** 
2) **堆： 存放对象(Cat cat , 数组等)** 
3) **方法区：常量池(常量，比如字符串)， 类加载信息**

#### Java 创建对象的流程简单分析

![image-20221207230136236](https://static.meowrain.cn/i/2022/12/08/bljtzj-3.png)

![image-20221207230219768](https://static.meowrain.cn/i/2022/12/08/bm1vkd-3.png)

## 方法重载

&gt; java中允许同一个类中，多个同名方法的存在，但是要求形参列表不一致

&gt; 通过重载，我们减轻了起名的麻烦

案例：

```java
package cn.meowrain.Object_;

public class relearn_06 {
    public static void main(String[] args) {
        rel rel = new rel();
        int m = rel.getSum(1,2,3);
        System.out.println(m);
        int n = rel.getSum(1,2);
        
    }
}
class rel {
    public int getSum(int n1,int n2){
        return n1&#43;n2;
    }
    public int getSum(int n1,int n2,int n3){
        return n1&#43;n2&#43;n3;
    }
}
```

### 可变参数

&gt; java允许把同一个类中多个同名同功能但是参数个数不同的方法，封装成一个方法

基本语法：

&gt;     //int... 表示接受的是可变参数，类型是int，即可以接收多个int
&gt;     //使用可变参数时候，可以当数组来使用，nums可以当做数组

```java
package cn.meowrain.Object_;

public class relearn_07 {
    public static void main(String[] args) {
        rel_07 rel = new rel_07();
        int m = rel.getSum(1,2,3,4);//10
        int n = rel.getSum(5,6,7);//18
        int b = rel.getSum(0,1);//1
        System.out.println(m);
        System.out.println(n);
        System.out.println(b);
    }

}
class rel_07 {
    //int... 表示接受的是可变参数，类型是int，即可以接收多个int
    //使用可变参数时候，可以当数组来使用，nums可以当做数组
    public int getSum(int... nums){
        int res = 0;
        for(int i = 0;i&lt;nums.length;i&#43;&#43;){
            res&#43;=nums[i];
        }
        return res;
    }
}
```

&gt; ![image-20221208221302540](https://static.meowrain.cn/i/2022/12/09/a4yvcs-3.png)

## 作用域

![image-20221208221637490](https://static.meowrain.cn/i/2022/12/09/a6yf87-3.png)

```java
package cn.meowrain.Object_;

public class relearn_08 {
    public static void main(String[] args) {

    }
}

class Dog {
    //全局变量：也就是属性，作用域为整个类体Cat类，cry eat等方法使用属性
    //属性在定义时，可以直接赋值
    int age = 10;
    double weight;//默认是0.0

    public void hi() {
        //局部变量必须赋值后才能使用，因为没有默认值
        //局部变量一般是指在成员方法中定义的变量
        int num = 1;
        String address = &#34;Beijing&#39;s Dog&#34;;
        System.out.println(&#34;num=&#34; &#43; num);
        System.out.println(&#34;address&#34; &#43; address);
        System.out.println(&#34;weight=&#34; &#43; weight);
    }

    public void cry() {
        int n = 10;
        String name = &#34;jack&#34;;
        System.out.println(name &#43; &#34;cry for&#34; &#43; n &#43; &#34;times&#34;);


    }

    public void eat() {
        String name = &#34;meow&#34;;
        System.out.println(name &#43; &#34;eat&#34;);
    }
}
```

### 注意事项和使用细节

![image-20221208222256061](https://static.meowrain.cn/i/2022/12/09/aan8cn-3.png)

&gt; 属性可以加修饰符，但是局部变量不能加修饰符

## 构造器

构造方法又叫构造器(constructor)，是类的一种特殊的方法，

它的主要作用是完成对新对象的初始化。它有几个特点： 

1) 方法名和类名相同 
1) 没有返回值 
1) 在创建对象时，系统会自动的调用该类的构造器完成对象的初始化。

![image-20221208223933784](https://static.meowrain.cn/i/2022/12/09/akmmfe-3.png)

基本语法：

```java
[修饰符] 方法名(形参列表) {
    方法体
}
```

&gt; ![image-20221208224012942](https://static.meowrain.cn/i/2022/12/09/al3gvn-3.png)

案例：

```java
package cn.meowrain.Object_;

public class relearn_09 {
    public static void main(String[] args) {
        rel_09 rel = new rel_09(&#34;meowrain&#34;, 18);
        rel_09 rel_1 = new rel_09(&#34;meow&#34;, 20, &#34;mouse&#34;);
        rel.getInfo();
        rel_1.getItem();
    }

}

class rel_09 {
    String name;
    int age;
    String item;

    public rel_09(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // 构造器重载
    public rel_09(String name, int age, String item) {
        this.name = name;
        this.age = age;
        this.item = item;
    }

    public void getInfo() {
        System.out.println(this.name &#43; &#34;  &#34; &#43; this.age);
    }

    public void getItem() {
        System.out.println(this.item);
    }
}
```

![image-20221208224712870](https://static.meowrain.cn/i/2022/12/09/ap9rk3-3.png)

### 练习题：

![image-20221208225109288](https://static.meowrain.cn/i/2022/12/09/armk4z-3.png)

```java
package cn.meowrain.Object_;

public class relearn_10 {
    public static void main(String[] args) {
        Person_n person01 = new Person_n(&#34;meow&#34;, 12);
        Person_n person02 = new Person_n();
        System.out.println(person01.name  &#43; &#34; is &#34; &#43; person01.age &#43; &#34;years old&#34;);
        System.out.println(person02.name &#43; &#34; is &#34; &#43; person02.age &#43; &#34;years old&#34;);
    }

}

class Person_n {
    String name;
    int age;

    public Person_n() {
        this.age = 18;
    }

    public Person_n(String name, int age) {
        this.name = name;
        this.age = age;
    }

}
```

![image-20221208230513474](https://static.meowrain.cn/i/2022/12/09/bnslbj-3.png)

## 对象创建的流程分析

![image-20221208232146688](https://static.meowrain.cn/i/2022/12/09/bxix5a-3.png)

![image-20221208232252577](https://static.meowrain.cn/i/2022/12/09/by5lwi-3.png)



## this关键字

![image-20221208232330819](https://static.meowrain.cn/i/2022/12/09/bym9gu-3.png)

&gt; 什么是this?
&gt;
&gt; ==简单说：哪个对象调用，this就代表哪个对象==
&gt;
&gt; ![image-20221208232947980](https://static.meowrain.cn/i/2022/12/09/c2ajje-3.png)
&gt;
&gt; ![image-20221208233027570](https://static.meowrain.cn/i/2022/12/09/c2rgsf-3.png)

```java
package cn.meowrain.Object_;

public class relearn12 {
    
}
class This01 {
    public static void main(String[] args) {
        Dog_new dog_new = new Dog_new(&#34;大黄&#34;, 1);
        dog_new.info();
    }
}
class Dog_new {
    String name;
    int age;
    public Dog_new(String name,int age) {
        this.name = name;
        this.age = age;
    }
    public void info(){
        System.out.println(&#34;this.hashCode=&#34; &#43; this.hashCode());
        System.out.println(name &#43; &#34;\t&#34; &#43; age &#43; &#34;\t&#34;);
    }
}
```

### 练习题：

![image-20221208233149601](https://static.meowrain.cn/i/2022/12/09/c3hjo6-3.png)

```java
package cn.meowrain.Object_;

public class relearn13 {
    public static void main(String[] args) {
        person_01 p1 = new person_01(&#34;mary&#34;, 18);
        person_01 p2 = new person_01(&#34;mary&#34;,18);
        System.out.println(p1.compareTo(p2)); //true
    }
    
}
class person_01 {
    String name;
    int age;
    public person_01(String name, int age) {
        this.name = name;
        this.age = age;
    }
    public boolean compareTo(person_01 p){
        if(this.name.equals(p.name)&amp;&amp;this.age == p.age) {
            return true;
        }
        return false;
    }
}


```

---

# 作业

## 作业1

![image-20221208233847713](https://static.meowrain.cn/i/2022/12/09/c7n9aw-3.png)

```java
package cn.meowrain.Object_.homework;

public class h1 {
    public static void main(String[] args) {
        double[] arr = { 1.0, -2.0, 4.5 };
        A01 a01 = new A01();
        double max = a01.max(arr);
        System.out.println(max);

    }
}

class A01 {
    public double max(double[] a) {
        double m = a[0];
        for (int i = 0; i &lt; a.length; i&#43;&#43;) {
            if (a[i] &gt; m)
                m = a[i];
        }
        return m;
    }
}
```



## 作业2

![image-20221208233859783](https://static.meowrain.cn/i/2022/12/09/c7py2n-3.png)

```java
package cn.meowrain.Object_.homework;

public class h2 {
    public static void main(String[] args) {
        String[] strArr = {&#34;helloworld&#34;,&#34;meowrain&#34;};
        A02 a02 = new A02();
        int a = a02.find(strArr);
        if(a == 0){
            System.out.println(true);
        }else {
            System.out.println(false);
        }
    }
    
}
class A02 {
    public int find(String []arr){
        for (int i = 0; i &lt; arr.length; i&#43;&#43;){
            if(arr[i].equals(&#34;helloworld&#34;)){
                return i;
            }
        }
        return -1;
    }
}
```



## 作业3

![image-20221208233908170](https://static.meowrain.cn/i/2022/12/09/c80ehs-3.png)

```java
package cn.meowrain.Object_.homework;

public class h3 {
    public static void main(String[] args) {
        Book book = new Book(&#34;猫的故事&#34;, 200);
        Book book2 = new Book(&#34;狗的故事&#34;, 120);
        Book book3 = new Book(&#34;驴的故事&#34;, 20);
        book.updatePrice(book.price);
        book2.updatePrice(book2.price);
        book3.updatePrice(book3.price);
        System.out.println(book.name &#43; &#34; : &#34; &#43; book.price);
        System.out.println(book2.name &#43; &#34; : &#34; &#43; book2.price);
        System.out.println(book3.name &#43; &#34; : &#34; &#43; book3.price);
        /*
         *  猫的故事 : 150.0
            狗的故事 : 100.0
            驴的故事 : 20.0
         * 
         */
    }
}
class Book {
    String name;
    double price;
    public Book(String name,double price) {
        this.name = name;
        this.price = price;
    }
    public void updatePrice(double price){
        if(price &gt; 150){
            this.price = 150;
        }else if(price &gt; 100) {
            this.price = 100;
        }
    }
}
```



## 作业4

![image-20221208233917803](https://static.meowrain.cn/i/2022/12/09/c826s9-3.png)

```java
package cn.meowrain.Object_.homework;

public class h4 {
    public static void main(String[] args) {
        A03 a03 = new A03();
        int[] arr = {1,2,3,4,5};
        int[] a1 = a03.copyArr(arr);
        for(int i=0;i&lt;a1.length; i&#43;&#43;){
            System.out.println(a1[i]);
        }
    }
}
class A03 {
    public int[] copyArr(int[] arr) {
        int[] a = new int[arr.length];
        for (int i = 0; i &lt; arr.length; i&#43;&#43;){
            a[i] = arr[i];
        }
        return a;
    }

}
```



## 作业5

![image-20221208233925348](https://static.meowrain.cn/i/2022/12/09/c840f7-3.png)

```java
package cn.meowrain.Object_.homework;

public class h5 {
public static void main(String[] args) {
    Circle circle = new Circle(2);
    double perimeter = circle.perimeter();
    double area = circle.area();
    System.out.printf(&#34;%.2f\n&#34;,perimeter);
    System.out.printf(&#34;%.2f\n&#34;,area);
    /*
     *  12.57
        12.57
     */
}
}

class Circle {
    double r;

    public Circle(double r) {
        this.r = r;
    }

    public double perimeter() {
        return Math.PI*r*2;
    }
    public double area() {
        return Math.PI * r * r;
    }
}
```



## 作业6

![image-20221208233941030](https://static.meowrain.cn/i/2022/12/09/c87b93-3.png)

```java
package cn.meowrain.Object_.homework;

public class h6 {
    public static void main(String[] args) {
        Cale cale01 = new Cale(5, 2);
        Cale cale02 = new Cale(1, 0);
        cale01.divide();
        cale02.divide();
    }
}

class Cale {
    int a, b;

    public Cale(int a, int b) {
        this.a = a;
        this.b = b;
    }

    public int sum() {
        return a &#43; b;

    }

    public int multiply() {
        return a * b;
    }

    public void divide() {
        if (b == 0) {
            System.out.println(&#34;输入的除数不能为0！&#34;);
        } else {
            System.out.println(a * 1.0 / b);
        }

    }
}
```



## 作业7

![image-20221208233951625](https://static.meowrain.cn/i/2022/12/09/c89j3i-3.png)

```java
package cn.meowrain.Object_.homework;

public class h7 {
public static void main(String[] args) {
    Dog dog = new Dog(&#34;mike&#34;,&#34;white&#34;,2);
    dog.show();
}
}
class Dog {
    String name;
    String color;
    int age;
    public Dog(String name,String color,int age){
        this.name = name;
        this.color = color;
        this.age = age;
    }
    public void show(){
        System.out.println(&#34;the dog &#34; &#43; name &#43; &#34; is &#34; &#43; age &#43; &#34; &#34; &#43; &#34;years old and its color is &#34; &#43; color);
    }
}
```



## 作业8

![image-20221208234033422](https://static.meowrain.cn/i/2022/12/09/c8r8su-3.png)



## 作业9

![image-20221208234041063](https://static.meowrain.cn/i/2022/12/09/c8svca-3.png)

```java
package cn.meowrain.Object_.homework;

public class h9 {

    public static void main(String[] args) {
        Music music01 = new Music(&#34;青花瓷&#34;, &#34;4:00&#34;);
        Music music02 = new Music(&#34;鸡你太美&#34;, &#34;3:00&#34;);
        music01.getInfo();
        music01.play();
        
    }
}
class Music
{
    String name;
    String times;
    public Music(String name,String times){
        this.name = name;
        this.times = times;
    }
    public void play(){
        System.out.println(name &#43; &#34;is palying for &#34; &#43; times);
    }
    public void getInfo(){
        System.out.println(&#34;the music name is &#34; &#43; name &#43; &#34;times is : &#34; &#43; times);
    }
}
```



## 作业10

![image-20221208234050200](https://static.meowrain.cn/i/2022/12/09/c8up21-3.png)

```java
package cn.meowrain.Object_.homework;

public class h8 {
    int i = 100;
    public void m(){
        int j = i&#43;&#43;;
        System.out.println(&#34;i=&#34; &#43; i);
        System.out.println(&#34;j=&#34; &#43; j);

    }
}
class Test {
    public static void main(String[] args) {
        h8 demo = new h8();
        h8 demo2 = new h8();
        demo.m();
        System.out.println(demo.i);
        System.out.println(demo2.i);
    }
}

```



```java
i=101
j=100
101  
100
```



## 作业11

![image-20221208234102159](https://static.meowrain.cn/i/2022/12/09/c8xbp3-3.png)

```java
不做了
```



## 作业12

![image-20221208234109474](https://static.meowrain.cn/i/2022/12/09/c97cu8-3.png)

```java
package cn.meowrain.Object_.homework;

public class h12 {
    Employee_ emp1 = new Employee_(&#34;经理&#34;, &#34;10000&#34;);
    

}
class Employee_ {
    String name;
    String sex;
    int age;
    String position;
    String salary;
    public Employee_(String name, String sex, int age, String position, String salary) {
        this.name = name;
        this.sex = sex;
        this.age = age;
        this.position = position;
        this.salary = salary;
    }
    public Employee_(String name, String sex, int age) {
        this.name = name;
        this.sex = sex;
        this.age = age;
    }
    public Employee_(String position, String salary) {
        this.position = position;
        this.salary = salary;
    }
    

    
}
```



## 作业13

![image-20221208234123863](https://static.meowrain.cn/i/2022/12/09/c9aok3-3.png)

```java
package cn.meowrain.Object_.homework;

public class h13 {
    public static void main(String[] args) {
        Circle01 circle = new Circle01();
        PassObject pass = new PassObject();
        pass.printAreas(circle, 5);
    }
}
 class Circle01 {
    public double radius;
    public double findArea(){
        return radius*radius*Math.PI;
    }

 }
 class PassObject {
    public void printAreas(Circle01 c,int times) {
        for(int i = times;i&gt;0;i--){
            c.radius = i;
            System.out.println(&#34;r:&#34; &#43; i &#43; &#34;  &#34; &#43; &#34;S=&#34; &#43; c.findArea());
        }
    }
 }
```



---

> 作者: meowrain  
> URL: https://example.org/posts/61c8cb0/  

