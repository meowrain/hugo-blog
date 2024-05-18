---
title: C++ Const与function
subtitle:
date: 2024-05-18T14:27:09+08:00
slug: 2a356ef
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - C++
categories:
  - C++
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

# const与function

> 在c++中，const在function中有不一样的使用

```cpp
#include <iostream>
#include <string>

class Example {
    public:
    	Example(const std::string &name) : m_Name(name) {}
    	const std::string& GetName() const {return m_Name;};
    private:
    	std::string m_Name;
};
int main() {
    Example example("John");
    const std::string& name = example.GetName();
    std::cout << name << std::endl;//输出 “John"
    // name = "Alice"; //wrong
}
```

> 这个函数的返回值是一个指向常量字符串的引用。const修饰的是返回值的类型，表示返回的字符串是一个常量，不能被修改。
>
> 函数签名中的第二个const修饰的是成员函数本身，表示这个函数是一个const成员函数，即在该函数内部不能修改类的成员变量。
>
> 因此，这个函数返回一个指向常量字符串的引用，并且在该函数内部不修改类的成员变量。