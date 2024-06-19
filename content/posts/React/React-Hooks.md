---
title: React Hooks
subtitle:
date: 2024-05-18T14:20:57+08:00
slug: 33f6951
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Web前端
  - React
categories:
  - 前端
    - React
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

# React Hooks

# 手动创建react项目

> 仓库地址 https://github.com/meowrain/Manually-React-Project

> https://dev.to/ivadyhabimana/how-to-create-a-react-app-without-using-create-react-app-a-step-by-step-guide-30nl

```bash
npm init -y

npm install react react-dom
npm install --save-dev @babel/core babel-loader @babel/cli @babel/preset-env @babel/preset-react
npm install --save-dev webpack webpack-cli webpack-dev-server
npm install --save-dev html-webpack-plugin
```



![image-20240310173028800](https://static.meowrain.cn/i/2024/03/10/sm7v4z-3.webp)

![image-20240310173105406](https://static.meowrain.cn/i/2024/03/10/smmwnj-3.webp)

创建src目录，index.js，public目录和index.html,.babelrc,webpack.config.js

![image-20240310174711169](https://static.meowrain.cn/i/2024/03/10/sw74e8-3.webp)

```html
index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
```

```
webpack：使我们能够在项目中使用 webpack 的实际包
webpack-cli：允许我们在命令行中运行 webpack 命令
webpack-dev-server：Webpack 服务器将在开发环境中充当我们的服务器。如果您熟悉更高级别的开发服务器 live-server 或 nodemon，那么它的工作方式是相同的。
```

```js
// index.js
import React from 'react'
import  { createRoot }  from 'react-dom/client';
import App from './src/App.js'

const container = document.getElementById('root');
const root = createRoot(container);
root.render(<App/>);
```



```js
// App.jsx
import React from "react";
function App() {
return (
    <div>
        <h1>Hello React</h1>
    </div>
)
}
export default App
```



> 创建webpack.config.js
>
> ```js
> const HtmlWebpackPlugin = require("html-webpack-plugin");
> const path = require("path");
> 
> module.exports = {
> entry: "./index.js",
> mode: "development",
> output: {
>  path: path.resolve(__dirname, "./dist"),
>  filename: "index_bundle.js",
> },
> target: "web",
> devServer: {
>  port: "8080",
>  static: {
>    directory: path.join(__dirname, "public"),
>  },
>  open: true,
>  hot: true,
>  liveReload: true,
> },
> resolve: {
>  extensions: [".js", ".jsx", ".json"],
> },
> module: {
>  rules: [
>    {
>      test: /\.(js|jsx)$/,
>      exclude: /node_modules/,
>      use: "babel-loader",
>    },
>  ],
> },
> plugins: [
>  new HtmlWebpackPlugin({
>    template: path.join(__dirname, "public", "index.html"),
>  }),
> ],
> };
> 
> ```

```js
{
    "presets": ["@babel/preset-env","@babel/preset-react"]
}
```



修改package.json

![image-20240310174831161](https://static.meowrain.cn/i/2024/03/10/swwz8g-3.webp)

```json
  "scripts": {
    "start": "webpack-dev-server .",
    "build": "webpack ."
  },
```

![image-20240310175401158](https://static.meowrain.cn/i/2024/03/10/t0azoy-3.webp)

![image-20240310175416690](https://static.meowrain.cn/i/2024/03/10/t0e86q-3.webp)







# useState

```js
// App.js
import React, { useState } from "react";
function App() {
const [count,setCount] = useState(0);
function add(){
    setCount(count + 1)
}
function sub() {
    setCount(count - 1)
}
return (
    <div>
        <h1>Hello React</h1>
        <h3>{count}</h3>
        <button onClick={add}>Add</button>
        <button onClick={sub}>Sub</button>
    </div>
)
}
export default App
```

![image-20240310175908097](https://static.meowrain.cn/i/2024/03/10/t3bslu-3.webp)

> 那如果一次想加2呢？
>
> ```js
> import React, { useState } from "react";
> function App() {
> const [count,setCount] = useState(0);
> function add(){
>  setCount(count + 1)
>  setCount(count + 1)
> }
> function sub() {
>  setCount(count - 1)
> }
> return (
>  <div>
>      <h1>Hello React</h1>
>      <h3>{count}</h3>
>      <button onClick={add}>Add</button>
>      <button onClick={sub}>Sub</button>
>  </div>
> )
> }
> export default App
> ```
>
> 我们这样写，点击Add发现还是每次只能加1，这是为什么呢？
>
> >  这是因为React的setState是一个批量更新的过程,而不是立即更新。当您连续多次调用setState时,React会将多个setState调用合并到一次更新中。这样做是为了提高性能,避免不必要的重复渲染。
>
> 如果想在单次更新中多次增加count的值,可以使用函数形式的setState,它可以接收之前的state作为参数,并根据之前的state计算新的state。
>
> ```js
> import React, { useState } from "react";
> function App() {
> const [count,setCount] = useState(0);
> function add(){
>     setCount((prevCount)=>prevCount + 1)
>     setCount((prevCount)=>prevCount + 1)
> }
> function sub() {
>     setCount(count - 1)
> }
> return (
>     <div>
>         <h1>Hello React</h1>
>         <h3>{count}</h3>
>         <button onClick={add}>Add</button>
>         <button onClick={sub}>Sub</button>
>     </div>
> )
> }
> export default App
> ```
>
> ![image-20240310180159549](https://static.meowrain.cn/i/2024/03/10/tsve02-3.webp)
>
> > 这样就正常了
> >
> > 

## 使用useState更新数组或者对象

> 如果直接修改原有的数组或对象,由于引用没有改变,React 将无法检测到状态的变化,从而导致组件无法正确更新。

> React 倾向于函数式编程风格,这种风格强调不可变性和无副作用的纯函数。通过创建新的数组或对象,而不是直接修改它们,我们可以更好地遵循这种编程风格。

>  相反,使用不可变的方式来更新数组或对象,如使用 `concat`、`slice`、`...` 扩展运算符等,可以确保状态的不可变性,并且更易于推理和优化性能。这也是 React 官方文档中推荐的做法。

```js
import React, { useState } from 'react';

function App() {
  const [items, setItems] = useState(['apple', 'banana', 'orange']);

  const addItem = () => {
    setItems([...items, 'grape']);
  };

  const removeItem = (index) => {
    setItems(items.filter((item, i) => i !== index));
  };

  return (
    <div>
      <h1>Fruit List</h1>
      <ul>
        {items.map((item, index) => (
          <li key={index}>
            {item}
            <button onClick={() => removeItem(index)}>Remove</button>
          </li>
        ))}
      </ul>
      <button onClick={addItem}>Add Grape</button>
    </div>
  );
}

export default App;
```



![image-20240310180551182](https://static.meowrain.cn/i/2024/03/10/tuytqu-3.webp)



```js
import React, { useState } from 'react';

function App() {
  const [user, setUser] = useState({ name: 'John', age: 30 });

  const updateName = () => {
    setUser({ ...user, name: 'Jane' });
  };

  const incrementAge = () => {
    setUser({ ...user, age: user.age + 1 });
  };

  return (
    <div>
      <h1>User Details</h1>
      <p>Name: {user.name}</p>
      <p>Age: {user.age}</p>
      <button onClick={updateName}>Update Name</button>
      <button onClick={incrementAge}>Increment Age</button>
    </div>
  );
}

export default App;
```

![image-20240310180644682](https://static.meowrain.cn/i/2024/03/10/tvir7c-3.webp)

# useEffect

`useEffect` 是 React 提供的一个钩子函数,用于在函数组件中执行副作用操作,例如数据获取、订阅、手动修改 DOM 等。它类似于 `componentDidMount`、`componentDidUpdate` 和 `componentWillUnmount` 这些生命周期方法在类组件中的作用。

`useEffect` 是 React 提供的一个钩子函数,用于在函数组件中执行副作用操作,例如数据获取、订阅、手动修改 DOM 等。它类似于 `componentDidMount`、`componentDidUpdate` 和 `componentWillUnmount` 这些生命周期方法在类组件中的作用。

**useEffect 的语法**

```jsx
useEffect(effect, dependencies)
```

- `effect` 是一个函数,它描述了要执行的副作用操作。它可以返回一个清理函数,用于在组件卸载或下一次effect执行之前清理一些副作用。
- `dependencies` 是一个可选的数组,用于指定 effect 依赖的状态或属性。只有当这些依赖项发生变化时,effect 函数才会被重新执行。如果不提供这个数组,effect 将在每次组件渲染后执行。

**useEffect 的执行时机**

- 初次渲染时,effect 函数会被执行一次。
- 在每次更新后,React 会先比较 effect 的依赖项是否发生变化。如果发生变化,effect 函数就会被重新执行。
- 如果 effect 函数返回了一个清理函数,那么在下一次effect执行之前或组件卸载之前,这个清理函数会被执行。

**注意事项**

1. **不要在 effect 函数内部定义函数**。这会导致每次渲染时都创建一个新的函数实例,从而影响依赖项的比较。相反,应该在组件函数作用域内定义并传递给 effect。
2. **注意依赖项的顺序**。依赖项数组中的值顺序发生变化也会导致 effect 重新执行。
3. **避免在 effect 中执行昂贵的操作**。如果需要执行昂贵的操作,可以考虑使用 `useMemo` 或 `useCallback` 等钩子进行性能优化。

**使用示例**

1. **模拟组件生命周期**

   ```jsx
   import React, { useEffect } from 'react';
   
   function MyComponent() {
     useEffect(() => {
       // 这里是副作用代码，会在组件渲染后执行
       console.log('组件已挂载或更新');
   
       // 清理函数，用于在组件卸载或更新前执行清理工作
       return () => {
         console.log('组件即将卸载或更新，执行清理');
       };
     }, []); // 空依赖数组表示这个副作用只在组件挂载时运行一次
   
     return (
       <div>
         <p>这里是组件内容</p>
       </div>
     );
   }
   
   export default MyComponent;
   ```

例子：

```jsx
import React, { useEffect, useState } from "react";
export default function App() {
    const [count,setCount] = useState(0)
    useEffect(()=>{
        console.log('====================================');
        console.log("Component Mounted or Updated");
        console.log('====================================');
    },[count])
    function add() {
        return setCount((prevCount)=>prevCount + 1)
    }
    return (
        <div>
            <h1>HelloWorld</h1>
            <h3>{count}</h3>
            <button onClick={add}>Add</button>
        </div>
    )
}
```

![image-20240310182048591](https://static.meowrain.cn/i/2024/03/10/u3vqr7-3.webp)

> 我们在useEffect的第二个参数上写上我们要监控的值，当这个值发生变化的时候，传入useEffect的第一个回调函数就会被调用，然后再次打印



```js
import React, { useEffect, useState } from "react";
export default function App() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
  });
  const [flag, setFlag] = useState(true);
  useEffect(() => {
    //第一次加载组件的时候，这里的内容会被执行
    console.log("====================================");
    console.log("Component Mounted or Updated");
    console.log("====================================");
    return () => {
      //卸载组件的时候，这里的回调函数会被执行
      console.log("组件即将卸载或更新，执行清理");
    };
  });
  function handleSubmit(e) {
    e.preventDefault();
    console.log("====================================");
    console.log("表单数据", formData);
    console.log("====================================");
  }
  function handleChange(e) {
    const { name, value } = e.target;
    setFormData((prevFormData) => ({
      ...prevFormData,
      [name]: value,
    }));
  }
  return (
    <div>
      {flag && (
        <form onSubmit={handleSubmit}>
          <div>
            <label htmlFor="name">姓名：</label>
            <input
              type="text"
              id="name"
              value={formData.name}
              onChange={handleChange}
            ></input>
          </div>
          <div>
            <label htmlFor="email">邮箱：</label>
            <input
              type="text"
              id="email"
              value={formData.email}
              onChange={handleChange}
            ></input>
          </div>
          <div>
            <label htmlFor="password">密码：</label>
            <input
              type="password"
              id="password"
              value={formData.password}
              onChange={handleChange}
            ></input>
          </div>
          <button type="submit">提交</button>
        </form>
      )}
      <button onClick={()=>setFlag(!flag)}>{flag ? 'Hide' : 'Show'}</button>
    </div>
  );
}

```

> 点击Hide前
>
> ![image-20240310183900183](https://static.meowrain.cn/i/2024/03/10/uewlz0-3.webp)
>
> 点击后
>
> ![image-20240310183909775](https://static.meowrain.cn/i/2024/03/10/ueyn5q-3.webp)



2. **订阅和取消订阅事件**

```jsx
import React, { useState, useEffect } from 'react';

function MouseTracker() {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e) => {
      setPosition({ x: e.clientX, y: e.clientY });
    };

    window.addEventListener('mousemove', handleMouseMove);

    // 清理函数用于取消订阅
    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);

  return (
    <div>
      <p>X: {position.x}, Y: {position.y}</p>
    </div>
  );
}
```

3. **数据获取**

```jsx
import React, { useState, useEffect } from 'react';

function DataFetcher() {
  const [data, setData] = useState(null);

  useEffect(() => {
    async function fetchData() {
      const response = await fetch('/api/data');
      const data = await response.json();
      setData(data);
    }

    fetchData();
  }, []);

  return (
    <div>
      {data ? (
        <div>
          <h1>{data.title}</h1>
          <p>{data.content}</p>
        </div>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
}
```

通过这些示例,您可以了解到 `useEffect` 可以模拟类组件的生命周期、订阅和取消订阅事件、获取数据等常见操作。在使用 `useEffect` 时,请注意依赖项的设置和清理函数的使用,以确保正确的效果和避免内存泄漏。



# useRef

`useRef` 是 React 中的一个钩子（Hook），它允许你在函数组件中创建一个可变的引用对象。这个引用对象在组件的整个生命周期内保持不变，即使组件重新渲染也不会改变。`useRef` 主要用于以下场景：

1. **操作 DOM 元素**：当你需要直接访问 DOM 节点时，可以使用 `useRef` 来创建一个引用，并将其附加到 DOM 元素上。
2. **获取组件实例**：在自定义组件中，你可以使用 `useRef` 来获取组件的实例。
3. **跨渲染周期保持状态**：`useRef` 可以用来存储跨渲染周期的状态，因为 `useRef` 的 `current` 属性不会在渲染时更新。

### 基本用法

```jsx
import { useRef } from 'react';

function MyComponent() {
  const inputRef = useRef(null);

  function focusInput() {
    inputRef.current.focus();
  }

  return (
    <input ref={inputRef} type="text" />
    <button onClick={focusInput}>Focus the input</button>
  );
}
```

在这个例子中，我们创建了一个 `inputRef` 引用，并将其附加到 `input` 元素上。当用户点击按钮时，`focusInput` 函数会被调用，从而使焦点移动到输入框上。

![](https://static.meowrain.cn/i/2024/03/14/qt46sy-3.gif)

### 注意事项

- **不要在渲染期间写入或读取 `ref.current`**：在组件的渲染逻辑中（即 JSX 部分），你应该避免直接修改 `ref.current`。这可能会导致不可预测的组件行为。相反，你应该在事件处理程序或 `useEffect` 钩子中进行这些操作。
- **初始化 `useRef` 时避免重复创建**：如果你在 `useRef` 中创建一个对象，确保只在首次渲染时创建它，以避免不必要的重复创建。可以通过检查 `current` 是否为 `null` 来实现。
- **自定义组件的 ref 转发**：如果你想将 `ref` 传递给一个自定义组件的内部 DOM 节点，你需要使用 `React.forwardRef` 来转发 `ref`。

### 例子

#### 操作 DOM

```jsx
import { useRef } from 'react';

function TextInputWithFocusButton() {
  const inputRef = useRef();

  const focusTextInput = () => {
    inputRef.current.focus();
  };

  return (
    <>
      <input ref={inputRef} type="text" />
      <button onClick={focusTextInput}>Focus the input field</button>
    </>
  );
}
```

#### 跨渲染周期保持状态

```jsx
import { useRef, useEffect } from 'react';

function UseEffectExample() {
  const intervalRef = useRef();

  useEffect(() => {
    intervalRef.current = setInterval(() => {
      console.log('tick');
    }, 1000);

    return () => {
      clearInterval(intervalRef.current);
    };
  }, []);

  return <div>Example of using useRef with useEffect</div>;
}
```

在这个例子中，我们使用 `useRef` 来保存定时器的 ID，以便在组件卸载时能够清除定时器。

#### 自定义组件的 ref 转发

```jsx
import React, { forwardRef, useImperativeHandle, useRef } from 'react';

const VideoPlayer = forwardRef((props, ref) => {
  const videoRef = useRef();

  useImperativeHandle(ref, () => ({
    play() {
      videoRef.current.play();
    },
    pause() {
      videoRef.current.pause();
    },
  }));

  return <video ref={videoRef} src="video.mp4" />;
});

function App() {
  const videoRef = useRef();

  useEffect(() => {
    videoRef.current.play();
    return () => {
      videoRef.current.pause();
    };
  }, []);

  return <VideoPlayer ref={videoRef} />;
}
```

在这个例子中，我们使用 `forwardRef` 和 `useImperativeHandle` 来创建一个可引用的 `VideoPlayer` 组件，允许父组件控制视频的播放和暂停。

通过这些例子和注意事项，你应该能够更好地理解 `useRef` 的用法和在 React 函数组件中的实用场景。





# useContext

```jsx
import { useContext,createContext } from "react";
import "./App.css";
const MyContext = createContext();
function App() {

  return (
    <>
      <MyContext.Provider value={{ someData: "Hello World" }}>
        <ChildComponent />
      </MyContext.Provider>
    </>
  );
}
function ChildComponent() {
  const context = useContext(MyContext);
  return <div>{context.someData}</div>;
}
export default App;

```

![image-20240314164909164](https://static.meowrain.cn/i/2024/03/14/r9tky4-3.webp)

### 为什么使用 useContext

- **简化跨层级的数据传递**：当你需要在嵌套很深的组件树中传递数据时，使用上下文可以避免在每个层级手动传递 props。
- **与状态管理库结合**：上下文可以与状态管理库（如 Redux 或 MobX）结合使用，以便在组件之间共享全局状态。
- **自定义钩子**：你可以创建自定义钩子来使用上下文，使得在多个组件中访问上下文值更加方便。

### 注意事项

- **避免过度使用**：虽然上下文可以简化数据传递，但过度使用可能会导致难以追踪数据流和调试问题。在可能的情况下，尽量使用局部状态管理。
- **考虑性能**：上下文的值变化会触发所有依赖于该上下文的组件的重新渲染。如果你的上下文值很大或者组件树很复杂，这可能会影响性能。
- **使用 React.memo 或 useMemo**：如果你的组件依赖于上下文值，但本身不依赖于其他 props 或 state，可以使用 `React.memo` 或 `useMemo` 来避免不必要的重新渲染。



`useMemo` 是 React 中的一个钩子（Hook），它帮助你优化组件性能，通过缓存计算结果来避免不必要的重复计算。当你有一个函数组件中的值是根据其他值计算得出的，并且这个值的计算成本较高或者结果不经常变化时，使用 `useMemo` 可以提高性能。

# useMemo

### 基本用法

`useMemo` 接受两个参数：一个函数和一个依赖数组。函数返回的值会被缓存，并且只有当依赖数组中的值发生变化时，函数才会重新执行。

```jsx
import { useMemo } from 'react';

function ExpensiveComponent(props) {
  // 假设这是一个计算成本很高的函数
  const result = doSomethingExpensive(props.input);

  // 将计算结果缓存起来
  const memoizedResult = useMemo(() => result, [props.input]);

  return <div>{memoizedResult}</div>;
}
```

在这个例子中，`doSomethingExpensive` 函数的结果被 `useMemo` 缓存起来。只有当 `props.input` 发生变化时，`doSomethingExpensive` 才会重新执行。

### 注意事项

- **只有当函数的输出依赖于其参数时，才应该使用 `useMemo`**。如果你的函数不依赖于任何外部值，那么它可能不需要 `useMemo`。
- **不要将 `useMemo` 用于依赖于内部状态的值**。如果你需要缓存基于组件内部状态的值，应该使用 `useState`。
- **`useMemo` 不是一个语义化的保证**。React 可能会在内存不足等情况下丢弃缓存的值，所以 `useMemo` 并不能保证缓存的值一定会被复用。
- **`useMemo` 仅用于性能优化**。如果你的代码在没有 `useMemo` 的情况下也能正常工作，那么不应该仅仅为了使用 `useMemo` 而使用它。
- **考虑使用 `useCallback` 来缓存函数**。如果你需要缓存一个函数而不是值，那么 `useCallback` 可能是更合适的选择。

### 示例

#### 缓存复杂计算结果

```jsx
function CalculationComponent({ initialData }) {
  // 一个复杂的计算函数
  const calculateData = () => {
    // ...复杂的计算逻辑
    return complexResult;
  };

  // 使用 useMemo 缓存计算结果
  const data = useMemo(calculateData, [initialData]);

  return <div>Data: {data}</div>;
}
```

在这个例子中，`calculateData` 函数的结果被缓存，只有当 `initialData` 发生变化时，计算才会重新执行。

#### 缓存函数

如果你需要缓存一个函数，而不是值，可以使用 `useCallback`。但是，如果你的函数返回一个值，并且这个值依赖于函数的参数，你可以使用 `useMemo` 来缓存这个值。

```jsx
function Component({ dependencies }) {
  // 一个返回值的函数
  const getValue = useCallback(() => {
    let sum = 0;
    for (const dep of dependencies) {
      sum += dep;
    }
    return sum;
  }, [dependencies]);

  // 使用 useMemo 缓存函数的返回值
  const memoizedValue = useMemo(() => getValue(), [getValue]);

  return <div>Value: {memoizedValue}</div>;
}
```

在这个例子中，`getValue` 函数的返回值被 `useMemo` 缓存，以避免在每次渲染时都重新计算。

通过使用 `useMemo`，你可以有效地优化组件的性能，特别是在处理计算成本较高的值时。记住，只有在值的计算依赖于组件的 props 或 state 时，才应该使用 `useMemo`。





# useReducer

https://kothing.github.io/react-hook-useReducer/