#import "../template.typ": *
#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#show: project.with(
  title: "3",
  authors: (
    "absolutex",
  )
)

= 3 哈希表


== 1 哈希表的一个应用，是Python的数据结构：字典。大家可以阅读一下构建Python字典的设计需求：http://svn.python.org/projects/python/trunk/Objects/dictnotes.txt （这不是必须的）。其中，提到了字典的一个应用场景：

```
Membership Testing
    Dictionaries of any size.  Created once and then rarely changes.
    Single write to each key.
    Many calls to __contains__() or has_key().
    Similar access patterns occur with replacement dictionaries
        such as with the % formatting operator.
```

请问下述那个描述符合这个场景？

  A创建后多次插入，之后几乎是查找操作

  *B创建后多次插入，之后全是查找操作*

  C插入/删除与查找操作出现的次数几乎一样多
  
  D轮流进行插入/删除与查找操作

== 2仍然是上题题干。考虑要创建一个哈希表来实现字典。请问如何考量这个哈希表表长的设计？

  A 初始选定一个较小的哈希表长度，后续以2倍进行扩增

  B 初始选定一个较小的哈希表长度，后续以4倍进行扩增

  *C 初始选定一个较大的哈希表长度，后续以2倍进行扩增*

  D 初始选定一个较大的哈希表长度，后续以4倍进行扩增

== 课本11.1-1
