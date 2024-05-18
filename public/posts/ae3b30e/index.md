# C&#43;&#43;面向对象


# C&#43;&#43; OOP

## Class(1)

### private,protected,public

#### private(默认就是 private)

private 声明的类的私有成员只能由同一类的其他成员或者它们的朋友访问

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;
class Student {
private:
    int score;
public:
    std::string name;
    int age;
    Student(std::string _name,int _age,int _score) : name(_name),age(_age),score(_score){

    }
    void getScore(){
        std::cout &lt;&lt; score &lt;&lt; std::endl;
    }
};
int main(void) {
    Student s(&#34;meow&#34;,18,100);
    s.getScore();
}
```

![image20230705191917170](https://static.meowrain.cn/i/2023/07/05/vqmqjj-3.webp)

我们如果在 main 函数中直接用对象输出学生的分数，就不能

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;
class Student {
private:
    int score;
public:
    std::string name;
    int age;
    Student(std::string _name,int _age,int _score) : name(_name),age(_age),score(_score){

    }
    void getScore(){
        std::cout &lt;&lt; score &lt;&lt; std::endl;
    }
};
int main(void) {
    Student s(&#34;meow&#34;,18,100);
    std::cout &lt;&lt; s.score &lt;&lt; std::endl;
}
```

![image20230705192009344](https://static.meowrain.cn/i/2023/07/05/vr6m6j-3.webp)

![image20230705192032009](https://static.meowrain.cn/i/2023/07/05/vrbig8-3.webp)

#### protected

protected 受保护的成员可以从同一类的其他成员（或从他们的“朋友”）访问，也可以从其派生类的成员访问。

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;
class Human {
protected:
    std::string name;
public:
    Human(std::string _name): name(_name){}
    void getHumanInfo() {
        std::cout &lt;&lt; &#34;Human name is: &#34; &lt;&lt; name &lt;&lt; std::endl;
    } //同一类成员访问
};
class Student:Human{
public:
    int score;
    Student(std::string _name,int _score): Human(_name),score(_score) {

    }
    void getStudentInfo() {
        std::cout &lt;&lt; &#34;Student name is :&#34; &lt;&lt;  name  &lt;&lt; &#34;\tStudent score is :&#34; &lt;&lt; score &lt;&lt; std::endl;
    }
}; //派生类成员访问
int main(void) {
    Student s(&#34;meow&#34;,100);
    s.getStudentInfo();
    Human h(&#34;meow&#34;);
    h.getHumanInfo();
    return 0;
}
```

#### public

公共成员可以从对象可见的任何地方访问。

&gt; 这里不作代码解释了。😊

---

### 实现类成员函数

```cpp
#include &lt;iostream&gt;
class Square {
    int width;
    int height;
public:
    void setWidth(int _width) {
        width = _width;
    }
    void setHeight(int _height) {
        height = _height;
    }
    int getArea();
    int getPerimeter();
};

int Square::getArea() {
    return width * height;
}
int Square::getPerimeter() {
    return 2*(width &#43; height);
}
int main() {
    Square s;
    s.setHeight(10);
    s.setWidth(19);
    std::cout &lt;&lt; s.getArea() &lt;&lt; std::endl;
}
```

&gt; 当然了，构造函数也可以在外面实现!😊

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;
class Student {
public:
    std::string name;
    int age;
    Student(std::string,int);
    void getStudentInfo() {
        std::cout &lt;&lt; name &lt;&lt; &#34; &#34; &lt;&lt; age &lt;&lt; std::endl;
    }
};
//在外面实现类的构造函数
Student::Student(std::string _name, int _age) : name(_name),age(_age){}
int main() {
    Student s(&#34;meow&#34;,10);
    s.getStudentInfo();
    return 0;
}
```

### 构造器（Constructors）

#### c&#43;&#43; 构造器（最简单的实例）

```cpp
#include &lt;iostream&gt;
class Rectangle {
    int width;
    int height;
public:
    Rectangle(int,int);
    void getArea();
};
Rectangle::Rectangle(int _w, int _h) {
    width = _w;
    height = _h;
}
void Rectangle::getArea() {
    std::cout &lt;&lt; width * height &lt;&lt; std::endl;
}
int main(void) {
    Rectangle r(100,100);
    r.getArea();
}
```

&gt; 上面是 c&#43;&#43;构造器一个简单的用法

#### 重载构造器（包括成员初始化列表）

&gt; 试想一下，假如我要求用 `Rectangle r`创建对象的时候，默认 `width = 5`,`height = 5`,但是又要求能给 `Rectangle 对象的成员变量赋值，比如让width = 10,height = 20`,`Rectangle r(10,20)`. 我们就得这么写

```cpp
#include &lt;iostream&gt;
class Rectangle {
    int width;
    int height;
public:
    Rectangle();
    Rectangle(int,int);
    void getArea(){
        std::cout &lt;&lt; width*height &lt;&lt; std::endl;
    }
};
Rectangle::Rectangle() {
    width = 5;
    height = 5;
}
Rectangle::Rectangle(int w, int h) {
    width = w;
    height = h;
}
int main(void) {
    Rectangle r;
    r.getArea(); //25
    Rectangle r2(10,15);
    r2.getArea(); //150
}
```

当然了，我们可以不在外面实现构造函数，直接在类里面写也是可以的

```cpp
#include &lt;iostream&gt;
class Rectangle {
    int width;
    int height;
public:
    Rectangle() {
        width = 5;
        height = 5;
    }
    Rectangle(int _w,int _h) {
        width = _w;
        height = _h;
    }
    void getArea(){
        std::cout &lt;&lt; width*height &lt;&lt; std::endl;
    }
};
int main(void) {
    Rectangle r;
    r.getArea(); //25
    Rectangle r2(10,15);
    r2.getArea(); //150
}
```

&gt; 😊 有没有发现这样很麻烦呢？
&gt; 
&gt; 其实在 c&#43;&#43;中有一个东西，叫 `成员初始化列表`，看到上面的重载的第二个构造函数了吗？我们可以像下面这样写
&gt; 
&gt; ```cpp
&gt;      Rectangle(int _w, int _h) : width(_w), height(_h) {};
&gt; ```
&gt; 
&gt; 这样就大大简化了我们的构造函数书写啦！😊

---

### 指向类的指针（Pointers to Class)

在 c&#43;&#43;中，我们也 能用指针去指向类，然后通过指针调用类

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;
class Human {
    std::string name;
public:
    Human(std::string _name):name(_name){};
    void getHumanInfo() {
        std::cout &lt;&lt; &#34;Human name is :&#34; &lt;&lt; name &lt;&lt; std::endl;
    }
};
int main() {
    //创建Human对象
    Human h(&#34;Mike&#34;);
    Human *human = &amp;h;
    human-&gt;getHumanInfo(); //通过指针调用类的成员函数 //Human name is :Mike

    return 0;
}
```

&gt; 😊 既然这样，那我们就可以创建类数组啦
&gt; 
&gt; ```cpp
&gt; #include &lt;iostream&gt;
&gt; 
&gt; class Rectangle {
&gt;     int width,height;
&gt; public:
&gt;     Rectangle(int _w,int _h):width(_w),height(_h){};
&gt;     void getArea() {
&gt;         std::cout &lt;&lt; width*height &lt;&lt; std::endl;
&gt;     }
&gt; };
&gt; int main(void) {
&gt;     Rectangle r(10,20);
&gt;     Rectangle *ptr = new Rectangle[2]{{2,5},{3,6}};
&gt;     ptr[0].getArea(); //10
&gt;     ptr[1].getArea(); //18
&gt;     delete []ptr;
&gt;     return 0;
&gt; }
&gt; ```
&gt; 
&gt; &gt; 关于指针和 new 这个我会后面参考 `c&#43;&#43; primer plus`进行进一步说明

### 静态函数

C&#43;&#43; 中的静态函数是指在类中使用static关键字修饰的成员函数。它与类的实例无关，可以通过类名直接调用，不需要创建类的对象

静态函数的声明和定义方式与普通成员函数相同，只需要在函数前面加上static关键字就行。**静态函数可以访问类的静态成员变量和静态成员函数，但是不能访问非静态成员变量和成员函数。**
  静态函数不能使用关键字this，因为它没有隐含的指向对象 的指针

```cpp
#include &lt;iostream&gt;
class Student {
public:
    Student(char* name,int age,float score);
    void show();
public:
    static int getTotal();
    static float getPoints();
private:
    static int m_total;
    static float m_points;
private:
    char *m_name;
    int m_age;
    float m_score;
};
int Student::m_total = 0;
float Student::m_points = 0.0;
Student::Student(char *name,int age,float score): m_name(name),m_age(age),m_score(score){
    m_total&#43;&#43;;
    m_points &#43;= score;
}
void Student::show() {
    std::cout &lt;&lt; m_name &lt;&lt; &#34; &#39;s age is &#34; &lt;&lt; m_age &lt;&lt; &#34;, score is &#34; &lt;&lt; m_score &lt;&lt; std::endl;
}
//Define static member function
float Student::getPoints(){
    return m_points;
}
int Student::getTotal() {
    return m_total;
}

int main(){
    (new Student(&#34;xiaoming&#34;,15,90.7))-&gt;show();
    int total = Student::getTotal();
    float points = Student::getPoints();
    std::cout &lt;&lt; &#34;now there is &#34; &lt;&lt; total &lt;&lt; &#34; students ,their total score is &#34; &lt;&lt; points &lt;&lt; std::endl;
    return 0;
}
```

### 析构函数

C&#43;&#43;中析构函数是一种特殊的成员函数，用于在对象被销毁时执行清理工作。析构函数的名称和类名相同，但在名称前面加上一个波浪号~

```cpp
#include &lt;iostream&gt;

class MyClass {
public:
    MyClass() { std::cout &lt;&lt; &#34;Constructor&#34; &lt;&lt; std::endl; }
    ~MyClass() { std::cout &lt;&lt; &#34;Destructor&#34; &lt;&lt; std::endl; }
};

int main() {
    MyClass obj;
    return 0;
}
```


析构函数的应用

```cpp
#include &lt;iostream&gt;
class MyClass
{
public:
    MyClass()
    {
        std::cout &lt;&lt; &#34;Constructor &#34; &lt;&lt; std::endl;
        data = new int[10];
    }
    ~MyClass()
    {
        std::cout &lt;&lt; &#34;DestructorL: data内存已被释放&#34; &lt;&lt; std::endl;
        delete[] data;
    }
    void insertNum(int x)
    {
        if (top &gt; 9)
            return;
        data[top&#43;&#43;] = x;
    }
    void printData()
    {
        for (int i = 0; i &lt;= top; i&#43;&#43;)
        {
            std::cout &lt;&lt; data[i] &lt;&lt; &#34; &#34;;
        }
        std::cout &lt;&lt; std::endl;
    }

private:
    int *data;
    int top = 0;
};
int main(void)
{
    MyClass obj;
    obj.insertNum(1);
    obj.insertNum(2);
    obj.insertNum(3);
    obj.insertNum(4);
    obj.insertNum(5);
    obj.insertNum(6);
    obj.printData();
    return 0;
}
```

### C&#43;&#43;成员对象和封闭类
一个类的成员变量如果是另一个类的对象，就称之为“成员对象”。包含成员对象的类叫封闭类（enclosed class）

封闭类对象生成时，先执行所有成员对象的构造函数，然后才执行封闭类自己的构造函数。成员对象构造函数的执行次序和成员对象在类定义中的次序一致，与它们在构造函数初始化列表中出现的次序无关。

当封闭类对象消亡时，先执行封闭类的析构函数，然后再执行成员对象的析构函数，成员对象析构函数的执行次序和构造函数的执行次序相反，即先构造的后析构，这是 C&#43;&#43; 处理此类次序问题的一般规律。
                              
```cpp
#include&lt;iostream&gt;
using namespace std;
class Tyre {
public:
    Tyre() { cout &lt;&lt; &#34;Tyre constructor&#34; &lt;&lt; endl; }
    ~Tyre() { cout &lt;&lt; &#34;Tyre destructor&#34; &lt;&lt; endl; }
};
class Engine {
public:
    Engine() { cout &lt;&lt; &#34;Engine constructor&#34; &lt;&lt; endl; }
    ~Engine() { cout &lt;&lt; &#34;Engine destructor&#34; &lt;&lt; endl; }
};
class Car {
private:
    Engine engine;
    Tyre tyre;
public:
    Car() { cout &lt;&lt; &#34;Car constructor&#34; &lt;&lt; endl; }
    ~Car() { cout &lt;&lt; &#34;Car destructor&#34; &lt;&lt; endl; }
};
int main() {
    Car car;
    return 0;
}
 ```
  
  ---
  
## Class(2)

### 封装

定义了一个 `Circle` 类，包含了数据成员 `radius` 和成员函数 `getRadius()`、`setRadius()` 和 `getArea()`。其中，`getRadius()` 和 `setRadius()` 分别用于获取和设置半径的值，`getArea()` 用于计算圆的面积。可以看出，`radius` 数据成员被隐藏在类的私有部分，外部的调用者无法直接访问和修改它，只能通过公共的成员函数进行操作，从而实现了数据的封装。

在 `main()` 函数中，定义了一个 `Circle` 对象 `c`，并通过公共的成员函数获取并修改了半径的值，并计算圆的面积。可以看出，外部调用者只能通过公共的接口来访问和操作数据，无法直接访问和修改私有成员变量，从而保证了数据的安全性和可维护性。

通过封装，C&#43;&#43; 中的类可以将数据和操作数据的方法封装在一起，隐藏实现细节，提高代码的安全性和可维护性。需要注意的是，在设计类的接口时，应该尽可能地隐藏实现细节，只暴露必要的接口，避免外部调用者误操作数据，从而提高程序的健壮性和可靠性。

```cpp
#include &lt;iostream&gt;

class Circle {
public:
    Circle(double r) : radius(r) {}
    double getRadius() const { return radius; }
    void setRadius(double r) { radius = r; }
    double getArea() const { return 3.14 * radius * radius; }
private:
    double radius;
};

int main() {
    Circle c(2.0);
    std::cout &lt;&lt; &#34;Radius = &#34; &lt;&lt; c.getRadius() &lt;&lt; std::endl;
    std::cout &lt;&lt; &#34;Area = &#34; &lt;&lt; c.getArea() &lt;&lt; std::endl;
    c.setRadius(3.0);
    std::cout &lt;&lt; &#34;Radius = &#34; &lt;&lt; c.getRadius() &lt;&lt; std::endl;
    std::cout &lt;&lt; &#34;Area = &#34; &lt;&lt; c.getArea() &lt;&lt; std::endl;
    return 0;
}
```
### 常函数&amp;常对象
  ![](https://static.meowrain.cn/i/2023/12/31/idmgok-3.webp)
  #### 测试常函数
  不加mutable，编译错误
![](https://static.meowrain.cn/i/2023/12/31/ikugoq-3.webp)
  加上mutable，编译通过
  ![](https://static.meowrain.cn/i/2023/12/31/ilad0y-3.webp)
  
  #### 测试常对象
  可见常对象只能调用常函数
![](https://static.meowrain.cn/i/2023/12/31/immyc2-3.webp)
  
### 继承

C&#43;&#43; 中的继承是面向对象编程中的一个重要概念，它允许通过派生类来扩展基类的功能，从而实现代码的重用和扩展。

```cpp
#include &lt;iostream&gt;
class Animal {
public:
    Animal(const std::string&amp; _name) : name(_name){};
    virtual void speak() const {
        std::cout &lt;&lt; &#34;I am an animal.&#34; &lt;&lt; std::endl; 
    }
protected:
    std::string name;
};

class Dog : public Animal {
public:
    Dog(const std::string&amp; _name,const std::string&amp; _breed) : Animal(_name),breed(_breed){};
    virtual void speak() const { std::cout &lt;&lt; &#34;Woof! I am a dog.&#34; &lt;&lt; std::endl; }
private:
    std::string breed;
};

class Cat : public Animal {
public:
    Cat(const std::string&amp; _name,const std::string&amp; _color) : Animal(_name),color(_color) {};
    virtual void speak() const {
        std::cout &lt;&lt; &#34;Meow! I am a  Cat.&#34; &lt;&lt; std::endl;
    }
private:
    std::string color;
};
int main(void) {
    Animal* animals[3];
    animals[0] = new Animal(&#34;Generic Animal&#34;);
    animals[1] = new Dog(&#34;Rover&#34;, &#34;Golden Retriever&#34;);
    animals[2] = new Cat(&#34;Fluffy&#34;, &#34;White&#34;);

    for (int i = 0; i &lt; 3; &#43;&#43;i) {
        animals[i]-&gt;speak();
    }

    delete animals[0];
    delete animals[1];
    delete animals[2];

}
```

 #### 继承中的静态变量
  ![](https://static.meowrain.cn/i/2024/01/06/10xlkm2-3.webp)
  
  ```cpp
  #include &lt;iostream&gt;
class Parent
{
public:
    static int staticVar;
};

int Parent::staticVar = 10;

class Child : public Parent
{
};

int main()
{
    std::cout &lt;&lt; Parent::staticVar &lt;&lt; std::endl;
    std::cout &lt;&lt; Child::staticVar &lt;&lt; std::endl;
    Child::staticVar = 30;
    std::cout &lt;&lt; Parent::staticVar &lt;&lt; std::endl;
    std::cout &lt;&lt; Child::staticVar &lt;&lt; std::endl;
}

```
  
 可见静态变量是父类和子类共享的。
  
  ---
  
  #### 关于继承时候加public,private,protected的区别
  在C&#43;&#43;中，继承时使用`public`、`private`和`protected`关键字可以控制基类成员对派生类的可访问性。这三个关键字的使用对于派生类中继承的成员的可见性和访问权限有不同的影响。

1. `public`继承：
   - 公有继承时使用`public`关键字，派生类可以继承基类的公有成员和保护成员。基类的公有成员在派生类中仍然是公有的，保护成员在派生类中仍然是保护的。
   - 基类的私有成员对派生类是不可访问的。

```cpp
class Child : public Parent {
    // 可以访问 Parent 的公有成员和保护成员
};
```

2. `private`继承：
   - 私有继承时使用`private`关键字，派生类可以继承基类的公有成员和保护成员，但它们在派生类中都将变为私有成员。
   - 基类的私有成员对派生类是不可访问的。

```cpp
class Child : private Parent {
    // 可以访问 Parent 的公有成员和保护成员，但它们在 Child 中都变为私有成员
};
```

3. `protected`继承：
   - 保护继承时使用`protected`关键字，派生类可以继承基类的公有成员和保护成员，它们在派生类中都将变为保护成员。
   - 基类的私有成员对派生类是不可访问的。

```cpp
class Child : protected Parent {
    // 可以访问 Parent 的公有成员和保护成员，但它们在 Child 中都变为保护成员
};
```

需要注意的是，上述访问控制关键字只影响派生类对基类成员的访问权限，而不影响基类内部对成员的访问权限。无论使用哪种访问控制关键字，在派生类中都可以访问基类的公有和保护成员，只是它们在派生类中的可见性和外部访问权限会有所不同。

继承时选择合适的访问控制关键字取决于设计需求和继承关系的语义。根据需要，可以选择`public`、`private`或`protected`继承来满足对基类成员的访问要求。
  
  ---
  
&gt; 这里我来浅浅介绍一下virtual这个关键字

#### 虚函数 virtual function

在 C&#43;&#43; 中，virtual 是一个关键字，用于定义虚函数。虚函数是一种特殊的成员函数，它通过动态绑定（dynamic binding）机制来实现多态，允许使用基类指针或引用调用派生类对象的成员函数，从而实现同一函数名在不同对象上具有不同的行为。

在使用 virtual 关键字定义虚函数时，需要注意以下几点：

只有类的成员函数才能被定义为虚函数，而普通的全局函数和静态成员函数不能被定义为虚函数。

虚函数必须在基类中声明，可以在派生类中重新定义，但是必须保持函数名、参数类型和返回类型相同，否则无法实现动态绑定。

基类的析构函数应该声明为虚函数，以保证在使用基类指针或引用删除派生类对象时，能够正确地调用派生类的析构函数。

在上面写继承得时候，就已经体现出了虚函数得作用

### 抽象类

在 C&#43;&#43; 中，抽象类（Abstract Class）指的是包含至少一个**纯虚函数**的类，不能直接实例化对象，只能作为基类被继承。纯虚函数是在类中声明但没有定义的虚函数，其语法格式如下：

```cpp
virtual 返回类型 函数名 (参数列表) = 0;
```

需要注意的是，纯虚函数没有函数体，只是一个声明，其作用是强制派生类实现该函数，从而实现多态。

抽象类一般用于定义接口和规范派生类的行为，其派生类必须实现基类的纯虚函数，否则也会成为抽象类。抽象类不能直接创建对象，但是可以定义指向派生类对象的指针或引用，通过动态绑定实现多态。

需要注意的是，在定义抽象类时，应该将基类的析构函数声明为虚函数，以保证正确释放派生类对象的内存。同时，抽象类的派生类必须实现基类的纯虚函数，否则也会成为抽象类。

### 接口 Interface

在 C&#43;&#43; 中，接口（Interface）指的是一个抽象类，包含纯虚函数和（或）常量数据成员，没有数据成员和函数实现。接口定义了一组规范，规定了派生类需要实现的函数和数据成员，用于实现类的多态和封装。

接口在 C&#43;&#43; 中通常使用抽象类来定义，其中的纯虚函数和常量数据成员用于描述派生类需要实现的接口规范。派生类必须实现所有的纯虚函数，否则也会成为抽象类。

抽象类和接口的主要区别在于，抽象类可以包含非纯虚函数和数据成员，而接口只能包含纯虚函数和常量数据成员。

使用案例：
在下面的示例中，定义了一个接口 **Printable**，包含了纯虚函数 **print()**。然后定义了一个抽象类 **Shape**，继承了接口 **Printable**，包含了纯虚函数**getArea()**。然后定义了两个派生类 **Rectangle** 和 **Circle**，分别实现了基类的纯虚函数，并添加了自己的数据成员和成员函数。在主函数中，定义了一个 **Printable** 类型的数组，分别用基类和派生类对象初始化数组元素。然后使用一个循环来遍历数组，并通过基类指针调用虚函数 **print()** 和 **getArea()**，实现了多态的效果。

在这个示例中，Printable 接口规定了 print() 函数，Shape 抽象类继承了 Printable 接口，并规定了 getArea() 函数，Rectangle 和 Circle 派生类分别实现了 Shape 抽象类的 getArea() 和 print() 函数。在主函数中，定义了一个 Printable 类型的数组，包含了 Rectangle 和 Circle 两种类型的对象，并通过循环实现了多态的效果。

```cpp
#include &lt;iostream&gt;

class Printable {
public:
    virtual void print() const = 0;
};

class Shape : public Printable {
public:
    virtual double getArea() const = 0;
};

class Rectangle : public Shape {
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    virtual double getArea() const { return width * height; }
    virtual void print() const { std::cout &lt;&lt; &#34;Rectangle (&#34; &lt;&lt; width &lt;&lt; &#34; x &#34; &lt;&lt; height &lt;&lt; &#34;)&#34; &lt;&lt; std::endl; }
private:
    double width;
    double height;
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r) {}
    virtual double getArea() const { return 3.14 * radius * radius; }
    virtual void print() const { std::cout &lt;&lt; &#34;Circle (&#34; &lt;&lt; radius &lt;&lt; &#34;)&#34; &lt;&lt; std::endl; }
private:
    double radius;
};

int main() {
    Printable* shapes[2];
    shapes[0] = new Rectangle(2.0, 3.0);
    shapes[1] = new Circle(1.5);

    for (int i = 0; i &lt; 2; &#43;&#43;i) {
        shapes[i]-&gt;print();
        std::cout &lt;&lt; &#34;Area = &#34; &lt;&lt; dynamic_cast&lt;Shape*&gt;(shapes[i])-&gt;getArea() &lt;&lt; std::endl;
    }

    delete shapes[0];
    delete shapes[1];

    return 0;
}
```

### 多态

多态（Polymorphism）是面向对象编程中的一个重要概念，指的是同一函数名在不同对象上具有不同的行为.

```cpp
#include &lt;iostream&gt;

class Shape {
public:
    virtual double getArea() const = 0;
    virtual void print() const = 0;
    virtual ~Shape(){};
};

class Rectangle : public Shape {
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    virtual double getArea() const { return width * height; }
    virtual void print() const { std::cout &lt;&lt; &#34;Rectangle (&#34; &lt;&lt; width &lt;&lt; &#34; x &#34; &lt;&lt; height &lt;&lt; &#34;)&#34; &lt;&lt; std::endl; }
private:
    double width;
    double height;
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r) {}
    virtual double getArea() const { return 3.14 * radius * radius; }
    virtual void print() const { std::cout &lt;&lt; &#34;Circle (&#34; &lt;&lt; radius &lt;&lt; &#34;)&#34; &lt;&lt; std::endl; }
private:
    double radius;
};

int main() {
    Shape* shapes[2];
    shapes[0] = new Rectangle(2.0, 3.0);
    shapes[1] = new Circle(1.5);

    for (int i = 0; i &lt; 2; &#43;&#43;i) {
        shapes[i]-&gt;print();
        std::cout &lt;&lt; &#34;Area = &#34; &lt;&lt; shapes[i]-&gt;getArea() &lt;&lt; std::endl;
    }

    delete shapes[0];
    delete shapes[1];

    return 0;
}
```

### 重载运算符（overloading operators)

&gt; **可重载运算符**
&gt; 
&gt; ![image20230705203726423](https://static.meowrain.cn/i/2023/07/05/xoxx73-3.webp)


&gt; 为了方便说明，我这里直接拿牛客网的题来说明了，包括重载运算符有什么用


![](https://static.meowrain.cn/i/2023/12/31/kseuhk-3.webp)
重载加号
```cpp
#include &lt;iostream&gt;
class Number {
private:
	int value;
public:
	Number() :value(0) {}
	Number(int val):value(val){}
	int getValue() const {
		return value;
	}
    //成员函数重载运算符
	//重载加号运算符
	Number operator&#43;(const Number&amp; num) {
		Number result;
		result.value = this-&gt;value &#43; num.value;
		return result;
	}
	//重载前置加号运算符
	Number operator&#43;&#43;() {
		value = value &#43; 1;
		return *this;
	}
    //重载后置加号运算符
	Number operator&#43;&#43;(int) {
		Number tmp = *this;
		&#43;&#43;(*this);
		return tmp;
	}
};
//全局函数实现运算符重载
Number operator&#43;(Number &amp;num1,int num2) {
    int num = num1.getValue() &#43; num2;
    num1 = Number(num);
    return num1;
}
int main(void) {
	Number num(10);
	Number num2(20);
	Number num3 = num &#43; num2; //相当于num.operator&#43;(num2);
	num3&#43;&#43;;
    num3 = num3 &#43; 20; //相当于 operator(num3,20)
	int val = num3.getValue();
	std::cout &lt;&lt; val &lt;&lt; std::endl;
}
```

重载&gt;&gt;
```cpp
#include &lt;iostream&gt;
class Person {
public:
    std::string name;
    int age;
    Person(std::string name, int age);
};

Person::Person(std::string name, int age) {
    this-&gt;name = name;
    this-&gt;age = age;
}

std::ostream&amp; operator&lt;&lt;(std::ostream &amp;out, const Person &amp;p) {
    out &lt;&lt; &#34;name: &#34; &lt;&lt; p.name &lt;&lt; &#34;, age: &#34; &lt;&lt; p.age;
    return out;
}

int main() {
    Person pe(&#34;meowrain&#34;, 234);
    std::cout &lt;&lt; pe &lt;&lt; std::endl;
    return 0;
}

```

&gt; 我们前面说过，类的属性应该用`private`，但是这样的话，我们重载的&lt;&lt;就没办法用了，怎么办呢？用友元

```cpp
#include &lt;iostream&gt;
class Person {
private:
    std::string name;
    int age;
    friend std::ostream&amp; operator&lt;&lt;(std::ostream &amp;out,const Person &amp;p);
public:
    Person(std::string name, int age);
};

Person::Person(std::string name, int age) {
    this-&gt;name = name;
    this-&gt;age = age;
}

std::ostream&amp; operator&lt;&lt;(std::ostream &amp;out, const Person &amp;p) {
    out &lt;&lt; &#34;name: &#34; &lt;&lt; p.name &lt;&lt; &#34;, age: &#34; &lt;&lt; p.age;
    return out;
}

int main() {
    Person pe(&#34;meowrain&#34;, 234);
    std::cout &lt;&lt; pe &lt;&lt; std::endl;
    return 0;
}

```
![](https://static.meowrain.cn/i/2023/12/31/nawzfa-3.webp)

重载=
```cpp
#include &lt;iostream&gt;
class Human {
private:
    int *m_age;
public:
    Human(int age){
        m_age = new int(age);
    }
    ~Human()
    {
        if (m_age != nullptr)
        {
            delete m_age;
            m_age = nullptr;
        }
    }
    Human(const Human&amp; human) {
        m_age = new int(*human.m_age);
    }
    void getAge(){
        std::cout &lt;&lt; *m_age &lt;&lt; std::endl;
    }
    Human&amp; operator=(const Human&amp; human) {
        if(this != &amp;human) {
            delete this-&gt;m_age;
            this-&gt;m_age = new int(*human.m_age);
        }
        return *this;
    }
};

int main(void) {
    Human h1(12);
    Human h2(14);
    h2 = h1;
    h1.getAge();
    h2.getAge();
}

```
![](https://static.meowrain.cn/i/2024/01/01/w7i8iw-3.webp)

[重载小于号\_\_牛客网 (nowcoder.com)](https://www.nowcoder.com/questionTerminal/e717e94202304f34b7ed95b2d31fce6b)

```cpp
#include &lt;iostream&gt;
using namespace std;

class Time {

    public:
        int hours;      // 小时
        int minutes;    // 分钟

        Time() {
            hours = 0;
            minutes = 0;
        }

        Time(int h, int m) {
            this-&gt;hours = h;
            this-&gt;minutes = m;
        }

        void show() {
            cout &lt;&lt; hours &lt;&lt; &#34; &#34; &lt;&lt; minutes &lt;&lt; endl;
        }

        // write your code here......
        bool operator&lt;(Time b){
            if(hours &gt; b.hours &amp;&amp; minutes &gt; b.minutes){
                return false;
            }
            else if(hours == b.hours &amp;&amp; minutes == b.minutes) return false;
            else return true;
        }

};

int main() {
    int h, m;
    cin &gt;&gt; h;
    cin &gt;&gt; m;

    Time t1(h, m);
    Time t2(6, 6);

    if (t1&lt;t2) cout&lt;&lt;&#34;yes&#34;; else cout&lt;&lt;&#34;no&#34;;
    return 0;
}
```

[加号运算符重载\_\_牛客网 (nowcoder.com)](https://www.nowcoder.com/questionTerminal/b9e27fcf61fc4013875409ed78e0960b)

```cpp
#include &lt;iostream&gt;
using namespace std;

class Time {

  public:
    int hours;      // 小时
    int minutes;    // 分钟

    Time() {
        hours = 0;
        minutes = 0;
    }

    Time(int h, int m) {
        this-&gt;hours = h;
        this-&gt;minutes = m;
    }

    void show() {
        cout &lt;&lt; hours &lt;&lt; &#34; &#34; &lt;&lt; minutes &lt;&lt; endl;
    }

    // write your code here......
    Time operator&#43;(Time b) {
        int sum_hours = hours &#43; b.hours;
        int sum_minutes = minutes &#43; b.minutes;
        if (sum_minutes &gt;= 60) {
            sum_minutes -= 60;
            sum_hours &#43;= 1;
        }
        Time sum(sum_hours, sum_minutes);
        return sum;
    }

};

int main() {

    int h, m;
    cin &gt;&gt; h;
    cin &gt;&gt; m;

    Time t1(h, m);
    Time t2(2, 20);

    Time t3 = t1 &#43; t2;
    t3.show();

    return 0;
}
```

---

#### 加号运算符重载

### Copy Constructor

拷贝构造函数是一种特殊的构造函数，它在创建对象时，是使用同一类中之前创建的对象来初始化新创建的对象。拷贝构造函数通常用于：

通过使用另一个同类型的对象来初始化新创建的对象。

复制对象把它作为参数传递给函数。

复制对象，并从函数返回这个对象。

如果在类中没有定义拷贝构造函数，编译器会自行定义一个。如果类带有指针变量，并有动态内存分配，则它必须有一个拷贝构造函数。拷贝构造函数的最常见形式如下：

```cpp
classname (const classname &amp;obj) {
   // 构造函数的主体
}
```

```cpp
#include &lt;iostream&gt;
using namespace std;
class Person {
public:
    string name;
    int age;
    Person() {
        name = &#34;meow&#34;;
        age = 10;
    }
    Person(string _name,int _age) {
        name = _name;
        age = _age;
    }
    Person(const Person&amp; other) {
        name = other.name;
        age = other.age;
    }
    void getInfo() {
        cout &lt;&lt; name &lt;&lt; &#34; &#34; &lt;&lt; age &lt;&lt; &#34;  &#34; &lt;&lt; endl;
    }
};

int main() {
    Person p(&#34;mew&#34;,19);
    Person p1 = p;
    Person p2(p);
    p.getInfo();
    p1.getInfo();
    p2.getInfo();
    return 0;

}
```

&gt; p1 是通过使用赋值语句来初始化的，即 Person p1 = p;。这实际上是一种隐式的赋值操作，编译器会使用 copy constructor 来创建 p1 对象，并将 p 对象的值复制到 p1 对象中。

&gt; 而 p2 是通过直接调用 copy constructor 来初始化的，即 Person p2(p);。这是一种显式调用 copy constructor 的方法，它直接使用现有对象 p 来创建新对象 p2，不需要使用赋值语句。

### Copy assignment(复制赋值操作符)

是 C&#43;&#43;中的一个运算符，用于将一个对象的值复制到另一个对象中。它通常用于将一个已经存在的对象的值赋给另一个已经存在的对象，从而使它们具有相同的值。

语法格式：

```cpp
classname&amp; operator=(const classname&amp; other)
```

&gt; 默认情况下，C&#43;&#43;会提供一个浅复制的 copy assignment 运算符

看一个例子：

```cpp
#include &lt;iostream&gt;
#include &lt;string&gt;

class Person {
public:
    std::string name;
    int age;

    Person() {
        name = &#34;meo&#34;;
        age = 12;
    }

    Person(std::string _name, int _age) : name(_name), age(_age) {

    }

    // copy constructor
    Person(const Person &amp;other) {
        name = other.name;
        age = other.age;
    }

    // copy assignment
    Person &amp;operator=(const Person &amp;other) {
        name = other.name;
        age = other.age;
        return *this;
    }

};


int main(void) {
    Person p1(&#34;meow&#34;, 12);
    Person p2;
    p2 = p1;
    std::cout &lt;&lt; &#34;p1.name &#34; &lt;&lt; p1.name &lt;&lt; &#34; age: &#34; &lt;&lt; p1.age &lt;&lt; std::endl;
    std::cout &lt;&lt; &#34;p2.name &#34; &lt;&lt; p2.name &lt;&lt; &#34; age: &#34; &lt;&lt; p2.age &lt;&lt; std::endl;
    return 0;
}
```

浅复制是指简单地将现有对象的成员变量的值复制到新对象中。如果成员变量是基本类型，那么浅复制是没有问题的，因为它们只是简单的值。但是，如果成员变量是指针，浅复制可能会导致问题。在这种情况下，浅复制只会复制指针本身，而不会复制指针指向的数据。这意味着新对象和现有对象将共享同一块数据，这可能会导致内存泄漏或数据损坏。

深复制是指将现有对象的成员变量的值复制到新对象中，并复制指针指向的数据。这意味着新对象将有自己的数据副本，与现有对象完全独立。这通常需要手动实现，因为 C&#43;&#43;默认提供的复制构造函数和赋值运算符只会执行浅复制。

### 友元
![](https://static.meowrain.cn/i/2023/12/31/iogq3g-3.webp)
友元是一种特殊的访问权限，允许一个函数或类访问另一个类的私有或受保护成员。

友元有三种：

- 友元函数
- 友元类
- 友元成员函数

#### 友元函数

创建友元函数得第一步 hi 把原型放在类声明中，在原型声明前面加上 `friend`

&gt; 需要注意的是，友元函数并不是 MyClass 的成员函数，它是一个独立的函数，只是被声明为 MyClass 的友元函数。

```cpp
#include &lt;iostream&gt;
class Person {
private:
    std::string name;
    int age;
public:
    Person(std::string _name,int _age) : name(_name),age(_age){}
    friend void printValue(Person &amp;p) {
        std::cout &lt;&lt; &#34;Person name: &#34; &lt;&lt; p.name &lt;&lt; &#34;\t&#34; &lt;&lt;
        &#34;Person age: &#34; &lt;&lt; p.age &lt;&lt; std::endl;
    }

    /* 在友元函数中，我们能访问Person类的私有成员变量 */
};
int main(void) {
    Person p(&#34;meow&#34;,18);
    printValue(p); //友元函数不是类Person的成员函数
    return 0;
}
```
![](https://static.meowrain.cn/i/2023/12/31/ituh8x-3.webp)

#### 友元类

友元类是指一个类可以访问另一个类的私有成员，这使得它们之间的关系更加密切。

例子：

```cpp
#include &lt;iostream&gt;
class Me {
private:
    std::string name;
    int age;
protected:
    std::string hobby;
public:
    Me(){
        name = &#34;meowrain&#34;;
        age = 20;
        hobby = &#34;playing computer&#34;;
    }
    void playGames(){
        std::cout &lt;&lt; &#34;I&#39;m playing games&#34; &lt;&lt; std::endl;
    }
    friend class MyFriend;
};

class MyFriend {
private:
    std::string name;
    int age;
public:
    MyFriend(){
        name = &#34;meow&#34;;
        age = 2;
    }
    void eat(){
        std::cout &lt;&lt; name &lt;&lt; &#34; is eating !&#34; &lt;&lt; std::endl;
    }
    void play(Me&amp; me){
        std::cout &lt;&lt; name &lt;&lt; &#34; is playing with &#34; &lt;&lt; me.name &lt;&lt; std::endl;
        std::cout &lt;&lt; &#34;while &#34; &lt;&lt; me.name &lt;&lt; &#34; is &#34; &lt;&lt; me.hobby &lt;&lt; std::endl;
    }
};

int main(void) {
    Me me;
    MyFriend my_friend;
    my_friend.play(me);
    return 0;
}
```
![](https://static.meowrain.cn/i/2023/12/31/j03r1u-3.webp)
  
#### 友元成员函数
&gt; `friend void Me::getFriendGirlFriend(MyFriend&amp; my_friend);`重点在这句代码，必须在那个类里面添加友元成员函数才可以保证需要用这个类的私有属性的类的成员函数能用到这个需要用的类的私有属性

&gt; 在 Me 类中声明了一个友元成员函数 `getFriendGirlFriend`，而为了让这个成员函数能够访问 MyFriend 类的私有属性，需要在 MyFriend 类中进行友元函数的声明。
```cpp
#include &lt;iostream&gt;
class MyFriend;
class Me {
private:
	std::string girlFriend;
public:
	std::string name;
	int age;
public:
	Me();
	void play() const;
	void getFriendGirlFriend(MyFriend&amp; my_friend);
};

class MyFriend {
private:
	std::string girlFriend;
	friend void Me::getFriendGirlFriend(MyFriend&amp; my_friend);
public:
	std::string name;
	int age;
public:
	MyFriend();
};
MyFriend::MyFriend() {
	name = &#34;jack chan&#34;;
	age = 20;
	girlFriend = &#34;洛天依&#34;;
};
Me::Me() {
	name = &#34;meowrain&#34;;
	age = 20;
	girlFriend = &#34;miku&#34;;
};
void Me::play() const {
	std::cout &lt;&lt; name &lt;&lt; &#34; is playing&#34; &lt;&lt; std::endl;
}
void Me::getFriendGirlFriend(MyFriend&amp; my_friend) {
	std::cout &lt;&lt; &#34;My Friend&#39;s girl friend is &#34; &lt;&lt;  my_friend.girlFriend &lt;&lt; std::endl;
}
int main(void) {
	Me me;
	MyFriend myFriend;
	me.getFriendGirlFriend(myFriend);
}
```
 ![](https://static.meowrain.cn/i/2023/12/31/k2ev33-3.webp)
  
### 转换函数

在 C&#43;&#43; 中，转换函数（conversion function）是一种特殊的成员函数，用于将一个对象转换为另一个类型的对象。转换函数可以将一个类对象转换为基本数据类型或另一个用户自定义类型的对象，或者将一个类对象转换为指向类对象的指针或引用。转换函数允许程序员在类中定义自己的类型转换规则，从而增强类的灵活性和可扩展性。

转换函数的命名规则与构造函数和成员函数相同，使用类名作为函数名，并在函数名称前面加上要转换的类型的名称。转换函数可以具有任何返回类型，但不能具有任何参数。转换函数可以被显式调用，也可以在需要时自动调用。

```cpp
#include &lt;iostream&gt;
//转换函数
class MyInt {
private:
    int data;
public:
    explicit MyInt(int n = 0) : data(n) { 
    }
    operator int() const {
        return data;
    }
};
int main(void) {
    MyInt a(10);
    int b = a; //调用转换函数把MyInt对象转换成int类型
    using std::cout;
    using std::endl;
    cout &lt;&lt; b &lt;&lt; endl; 
    return 0;
}
```

```cpp
#include &lt;iostream&gt;
class Feet {
private:
    int feet;
public:
    Feet(int n = 0): feet(n) {};
    int getFeet() const {
        return feet;
    }
};
class Meters {
public:
    Meters(double m = 0.0) : meters(m) {}
    Meters(const Feet&amp; f) : meters(f.getFeet() * 0.3048) {}
    //转换函数，把Feet对象转换为Meters对象
    double getMeters() const {
        return meters;
    }
private:
    double meters;
};
int main(void) {
    Feet f(10);
    Meters m = f;
    using std::cout,std::endl;
    cout &lt;&lt; m.getMeters() &lt;&lt; endl;
    return 0;
}
```
 
## explicit关键字
在C&#43;&#43;中，构造函数的调用方式分为显式调用和隐式调用。

### 显式调用构造函数：

1. **直接调用：** 构造函数可以通过类名和参数列表直接调用来创建对象。
   
   ```cpp
   class MyClass {
   public:
       MyClass(int x) { /* ... */ }
   };

   int main() {
       MyClass obj1(10); // 直接调用构造函数创建对象
       MyClass obj2 = MyClass(20); // 通过构造函数显式创建对象
       return 0;
   }
   ```

2. **使用 `new` 运算符：** 在堆内存上分配对象时，可以使用 `new` 运算符显式调用构造函数。

   ```cpp
   MyClass* ptr = new MyClass(30); // 在堆上分配内存并调用构造函数创建对象
   ```

### 隐式调用构造函数：

1. **使用 `=` 进行赋值：** 当使用 `=` 进行对象初始化或赋值时，会隐式地调用构造函数。

   ```cpp
   MyClass obj = 40; // 隐式调用构造函数将整数转换为 MyClass 对象
   ```

2. **函数调用时的参数传递：** 当函数需要参数并且传递的参数类型与函数参数不匹配时，会隐式调用构造函数来执行类型转换。

   ```cpp
   void func(MyClass obj) { /* ... */ }

   int main() {
       func(50); // 隐式调用构造函数将整数转换为 MyClass 对象并传递给 func 函数
       return 0;
   }
   ```

`explicit` 关键字可以防止构造函数的隐式调用，只有在需要时才能显式地调用构造函数。这可以避免一些意外的类型转换和可能导致错误的行为。
  
  
  在 C&#43;&#43; 中，`explicit` 是一个关键字，通常用于防止编译器执行隐式类型转换。它可以应用于单参数构造函数或转换运算符。主要作用有两点：

1. **禁止隐式转换：** 当一个构造函数被声明为 `explicit` 时，它不再能够隐式地将其参数转换为所需的类类型。这样可以防止意外的类型转换，避免意想不到的行为。

```cpp
class MyClass {
public:
    explicit MyClass(int x) { /* ... */ }
};

void func(const MyClass&amp; obj) { /* ... */ }

int main() {
    // MyClass obj = 10; // 这里会导致编译错误，因为构造函数是 explicit 的
    MyClass obj(10); // 必须显式调用构造函数
    func(10); // 这里也会导致编译错误，因为构造函数是 explicit 的
    func(MyClass(10)); // 必须显式地创建 MyClass 对象
    return 0;
}
```

2. **明确表达意图：** 使用 `explicit` 关键字可以使代码更加清晰明了，明确地表达出了构造函数或转换运算符不会进行隐式转换，需要显式地进行调用或转换。

当你希望避免隐式类型转换，或者想要更明确地表达构造函数的使用方式时，可以考虑使用 `explicit` 关键字。这在设计类时特别有用，可以避免一些潜在的错误或者意外行为。
  
  

---

> 作者: meowrain  
> URL: http://localhost:1313/posts/ae3b30e/  

