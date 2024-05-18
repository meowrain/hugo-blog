# Javascript 面向对象


# Javascript 面向对象(OOP)

## 语法

```javascript
class 类名 {
    constructor(){

    }
}
```

举例:

```js
//Person类专门用来创建人的对象
class Person {
    constructor(name,age,hooby){
        this.name = name;
        this.age = age;
        this.hooby = hooby;
    }
}
//调用构造函数创建对象创建对象
const xiaoming = new Person(&#34;xiaoming&#34;,18,&#39;programming&#39;);
console.log(xiaoming)
```

![image-20230101161413077](https://static.meowrain.cn/i/2023/01/02/69cfv-3.png)

## instanceOf用法

&gt; 可以用来检查一个对象是否是由某个类创建,如果某个对象是由某个类创建,那么我们称这个对象是这个类的实例

```js
//Person类专门用来创建人的对象
class Person {
    constructor(name,age,hooby){
        this.name = name;
        this.age = age;
        this.hooby = hooby;
    }
}
class Dog {

}
//调用构造函数创建对象创建对象
const xiaoming = new Person(&#34;xiaoming&#34;,18,&#39;programming&#39;);
const dog1 = new Dog();
console.log(xiaoming instanceof Person); //true
console.log(dog1 instanceof Person); //false 

```

![image-20230101161804360](https://static.meowrain.cn/i/2023/01/02/80qe7-3.png)

## 属性

```js
//Person类专门用来创建人的对象
class Person {
    //在类中写属性,每次创建对象,它都会带有这些实例属性
    //实例属性只能通过实例访问
    name = &#34;meowrian&#34;;
    age = 17;
    hobby = &#34;game&#34;
}
const meowrain = new Person();
console.log(meowrain);
console.log(meowrain.name,meowrain.age,meowrain.hobby);
```

![image-20230101162456259](https://static.meowrain.cn/i/2023/01/02/bnn5s-3.png)

### 静态属性

```js
//Person类专门用来创建人的对象
class Person {
    //静态属性只能通过类名去访问
    static test = &#34;test静态属性&#34;;
}
const meowrain = new Person();
console.log(Person.test);

```

## 方法

```js
//Person类专门用来创建人的对象
class Person {
    name = &#34;meowrain&#34;;
    sayHello = ()=&gt;{
        console.log(&#34;Hello~&#34;);
    }
}
const p1 = new Person();
console.log(p1)
p1.sayHello();
```

![image-20230101163745233](https://static.meowrain.cn/i/2023/01/02/in06n-3.png)

---

### 两种添加方法的方式:

```js
class Person {
    name = &#34;meowrain&#34;;
    sayHello = ()=&gt;{
        console.log(&#34;Hello~&#34;);
    }
    sayGoodbye(){
        console.log(&#34;Goodbye~&#34;);
    } //这种方式直接打印实例对象看不到这个方法

}
const p1 = new Person();
console.log(p1)
p1.sayHello();
p1.sayGoodbye();
```

![image-20230101164005552](https://static.meowrain.cn/i/2023/01/02/jv383-3.png)

### 静态方法(类方法)

```js
//Person类专门用来创建人的对象
class Person {
    static sayGG = ()=&gt;{
        console.log(&#34;GG~&#34;,this);//静态方法中,this指向的是我们的当前类
    }
}
console.log(Person.sayGG()); //只能通过类名来调用

```

## 构造函数

```js
class Person {
    //在类中添加一个特殊的方法constructor
    //该方法我们称为构造函数
    //构造函数会在我们调用类创建对象时候执行
    constructor(name, age, gender) {
        this.name = name;
        this.age = age;
        this.gender = gender;
        console.log(&#34;构造函数执行了&#34;);
    }
}
const p1 = new Person(&#34;meowrian&#34;, 18, &#34;男&#34;); //调用类创建一次对象
const p2 = new Person(&#34;meow&#34;, 10, &#34;男&#34;); //调用类创建一次对象
console.log(p1.name);
```

![image-20230101171037475](https://static.meowrain.cn/i/2023/01/02/1o5x75-3.png)

## 封装

```js
//1. 封装
// - 对象就是一个用来存储不同属性的容器
//对象不仅负责属性,还要负责数据的安全
//直接添加到对象中的属性并不安全,因为它们可以被任意修改
// 如何确保数据安全
//提供setter和getter方法,来开放我们对数据的操作

/*实现封装的方式
    * 1. 属性私有化 # 
    * 通过getter和setter方法来操作属性
    * get 属性名(){
    *   return this.#属性名;
    * }
    * set 属性名(value){
    *   this._属性名 = value;
    * }
    * */
class Person {
    //用#表示是私有属性 private,只能在类的内部访问
    #name;
    #age;
    #gender;

    constructor(name, age, gender) {
        this.#name = name;
        this.#age = age;
        this.#gender = gender;
        this._name = name;
        this._age = age;
        this._gender = gender;
    }

    //getter方法,用来读取属性
    get name() {
        return this.#name;
    } //这样写getter方法,在访问的时候直接用 实例.属性名就能获得
    get age() {
        return this.#age;
    }

    get gender() {
        return this.#gender;
    }

    //setter方法,用来设置属性

    set name(value) {
        this._name = value;
    }

    set age(value) {
        this._age = value;
    }

    set gender(value) {
        this._gender = value;
    }
}

const p1 = new Person(&#34;meow&#34;, 17, &#34;男&#34;);
console.log(p1.name, p1.age, p1.gender); //这些都是调用的getter方法
p1.name = &#34;meowmeow&#34;; //这里调用的是上面的setter方法
console.log(p1.name);
```

## 多态

```js
//多态
/*
    * 在JS中不会检查参数的类型,所以这就意味着任何数据都可以作为参数传递
    * 要调用某个函数,无需指定的类型,只需要对象满足某些条件计即可
    *
    * */
class Person {
    constructor(name) {
        this.name = name;
    }
}

class Dog {
    constructor(name) {
        this.name = name;
    }
}
class  Test {

}

const dog = new Dog(&#39;旺财&#39;);
const person = new Person(&#34;喵雨&#34;);
const test = new Test();
// console.log(dog);
// console.log(person);
/*定义一个函数,这个函数将会接受一个对象作为参数,可以输出hello,并且打印name属性*/
const sayHello = (obj)=&gt; {
    if (obj.name == undefined) {
        console.log(&#34;没有name属性,hello毛呢&#34;)
    } else if(obj instanceof Person){
        console.log(&#34;Hello 人:&#34; &#43; obj.name);
    }else {
        console.log(&#34;Hello &#34;&#43; obj.name);
    }
}

sayHello(dog);
sayHello(person);
sayHello(test);
```

![image-20230101184649118](https://static.meowrain.cn/i/2023/01/02/3rdtfq-3.png)

## 继承

```js
class Animal {
    constructor(name) {
        this.name = name;
    }

    sayHello() {
        console.log(&#34;Animal&#34;)
    }
}
class Dog extends Animal{
    constructor(name) {
        super(name);
    }

    sayHello() {
        console.log(&#34;旺&#34;)
    } //重写父类方法

}

class Cat extends Animal{
    constructor(name) {
        super(name);
    }

    sayHello() {
        console.log(&#34;meow&#34;)
    }
}

const dog = new Dog(&#34;旺财&#34;);
const cat = new Cat(&#34;汤姆&#34;);
dog.sayHello();
cat.sayHello();
```

![image-20230101201706956](https://static.meowrain.cn/i/2023/01/02/5risas-3.png)

## 对象的结构

&gt; 对象中存储属性的区域实际有两个:
&gt;
&gt; 1. 对象自身
&gt;
&gt;    &gt; - 直接通过对象添加的属性,位于对象自身中
&gt;    &gt; - 在类中通过x = y的形式添加的属性,位于对象自身中
&gt;    &gt; - ```js
&gt;    &gt;   class Person {
&gt;    &gt;       name = &#34;meowrian&#34;
&gt;    &gt;       age = 18
&gt;    &gt;       fun = ()=&gt;{
&gt;    &gt;           console.log(&#39;ffff&#39;);
&gt;    &gt;       }
&gt;    &gt;       constructor(hobby) {
&gt;    &gt;           this.hobby = hobby
&gt;    &gt;       }
&gt;    &gt;   }
&gt;    &gt;   const p = new Person(&#34;打篮球&#34;);
&gt;    &gt;
&gt;    &gt;   ```
&gt;    &gt; -
&gt;    &gt;
&gt; 2. 原型对象(**prototype**)
&gt;
&gt;    - 对象中还有一些内容,会存储在其他的对象里(原型对象)
&gt;    - 在对象中会有一个属性用来存储原型对象,这个属性叫做 **`__proto__`**
&gt;    - ```js
&gt;      class Person {
&gt;          fun(){
&gt;              console.log(&#34;hello&#34;)
&gt;          } //添加到原型中
&gt;          constructor(hobby) {
&gt;              this.hobby = hobby
&gt;          }
&gt;      }
&gt;      const p = new Person(&#34;打篮球&#34;);
&gt;      console.log(p)
&gt;      ```
&gt;    - ![image-20230101204042261](https://static.meowrain.cn/i/2023/01/02/6s5u9q-3.png)
&gt;    - 会添加到原型对象中的情况:
&gt;
&gt;      1. 在类中通过`xxx(){}`方式添加的方法,位于原型中
&gt;      2. 主动向原型中添加的属性和方法
&gt;
&gt;    ![image-20230101203739390](https://static.meowrain.cn/i/2023/01/02/6qgm2z-3.png)

## 原型
相关链接:[__proto__和prototype的区别](https://geek-docs.com/javascript/javascript-ask-answer/difference-between-proto-and-prototype.html#:~:text=Proto%E5%92%8Cpr,sh%E3%80%81pop%E7%AD%89%E3%80%82)

![](https://static.meowrain.cn/i/2023/01/02/12r59ek-3.png)
### `__proto__`
```javascript
class Person {
    name = &#34;meowrain&#34;
    sayHello(){kde ubuntu
        console.log(&#34;hello,我是&#34; &#43; this.name);
    }
}
const p = new Person();
/*
* 访问一个对象的原型对象      对象.__proto__
* console.log(Object.getPrototypeOf(对象));

* */
console.log(p.__proto__);//{constructor: ƒ, sayHello: ƒ}
console.log(Object.getPrototypeOf(p));//{constructor: ƒ, sayHello: ƒ}
```

![](https://static.meowrain.cn/i/2023/01/02/8d9lzg-3.png)
![](https://static.meowrain.cn/i/2023/01/02/10g9bts-3.png)

&gt; 原型的作用； 原型就相当于是一个公共的区域，可以被所有该类实例访问
&gt; 可以将一个该类实例中所有的公共属性统一存储到原型中
&gt; 这样我们只需要创建一个属性，即可被所有实例访问

### `prototype`
```js
class Person {
    sayHello(){
        console.log(&#34;hello&#34;)
    }
}
const p1 = new Person();
console.log(Person.prototype);
console.log(Person.prototype === p1.__proto__); //true

```

![](https://static.meowrain.cn/i/2023/01/02/12rljrd-3.png)
可以通过上面两种方式完成类的修改


### Object.hasOwn用法
&gt; 用来检查一个对象的自身是否含有某个属性
&gt; [MDN文档-Object.hasOwn](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwn)

```js
class Man {
    name = &#34;liming&#34;;
}

const man1 = new Man();
console.log(Object.hasOwn(man1, &#34;name&#34;)) //true
```
![](https://static.meowrain.cn/i/2023/01/03/qh6g8-3.png)

## 旧类
&gt; 早期js中,直接通过函数来定义类
&gt; 一个函数如果直接调用xx(),那么这个函数就是一个普通函数
&gt; 一个函数如果通过调用new xxx()那么这个函数就是一个构造函数
```js
function Person (){

}
const p = new Person();
```
&gt; 上面的等价于下面的
```js
class Person {
    
}
const p = new Person();
```


---
```js
function Person(name,age){
    //构造函数里面写的内容就是class中constructor写的内容
    this.name = name;
    this.age = age;
    this.sayHello = function (){
        console.log(&#34;hello&#34;)
    }
}
//向原型中添加
Person.prototype.sayNice = function (){
    console.log(&#34;nice&#34;)
}
const p = new Person(&#34;meowrain&#34;,12);
console.log(p.name); // meowrain
console.log(p.age); // 12
p.sayHello(); //hello
p.sayNice();//nice
console.log(p);
```
![](https://static.meowrain.cn/i/2023/01/02/w500jh-3.png)
&lt;font color=red&gt;如上图,从上图我们可以看到,sayNice方法被添加到原型中了&lt;/font&gt;

### 旧类静态属性,静态方法...
```js
var Person = (
    function () {
        //构造函数
        function Person(name, age) {
            this.name = name;
            this.age = age;
        }

        //静态属性
        Person.staticProperty = &#34;hobby&#34;;
        Person.hobby = &#34;nice&#34;;
        console.log(Person.hobby);//nice

        //静态方法
        Person.staticMethod = function () {
            console.log(&#34;good&#34;);
        };
        Person.staticMethod(); // good

        //创建实例
        const p = new Person(&#34;meowrain&#34;, 12);
        console.log(p.name);
        console.log(p.age);

        //返回对象
        return Person;
    })();
```

继承:
```js
var Animal = (function () {
    function Animal(name, age) {
        this.name = name;
        this.age = age;
    }

    return Animal;
})();
var Cat = (function () {
    function Cat(name, age) {
        this.name = name;
        this.age = age;
    }

    //继承Animal
    Cat.prototype = new Animal();
    return Cat;
})();
const cat1 = new Cat(&#34;meow&#34;, 2);
console.log(cat1);
```

## new运算符
&gt; new运算符是创建对象时候使用的运算符
&gt; [new运算符-MDN docs](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/new)
![](https://static.meowrain.cn/i/2023/01/02/xljgqs-3.png)

---

> 作者: meowrain  
> URL: https://example.org/posts/178f51c/  

