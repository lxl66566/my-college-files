#import "../template.typ": *
#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

// 需要注意，这里使用了 algorithmic:0.1.0，实际上该版本存在 bug，若想要编译本文至少需要 0.1.1。（我 PR 了 0.1.1 版本）

#show: project.with(
  title: "2",
  authors: (
    "absolutex",
  )
)

= 2 树

// == 需要为数据库构建range index（区域索引）。该区域索引要求：（1）单次插入时间低于O(n)，以满足Web程序的高负载特性；（2）能够快速获得index里的最大值、最小值，即这两个操作均需小于O(n)的计算复杂度。假如采用了习题2里的数据结构，请问插入的算法复杂度是

// $O(log n)$

// == 该区域索引要求：（1）单次插入时间低于O(n)，以满足Web程序的高负载特性；（2）能够快速获得index里的最大值、最小值，即这两个操作均需小于O(n)的计算复杂度。假如采用了习题2里的数据结构，查找最小值的算法复杂度是

// $O(log n)$

// == 要求：（1）单次插入时间低于O(n)，以满足Web程序的高负载特性；（2）能够快速获得index里的最大值、最小值，即这两个操作均需小于O(n)的计算复杂度。假如采用了习题2里的数据结构，查找最大值的算法复杂度是

// $O(log n)$

// == 针对前述数据库系统和range index，构建一个操作LIST(l, h)，即给定l和h，l < h，返回range index中所有在l和h之间的key。显然这个操作无法在低于O(N)的复杂度内完成（思考这是为什么）。我们将LIST的复杂度定义为T(N) + O(L)，这里的L=l-h。我们要求给出一种算法，使得T(N)是低于线性复杂度的，伪代码如下：...请问LCA函数的算法复杂度是？

// $O(log n)$

// == 针对前述数据库系统和range index，构建一个操作LIST(l, h)，即给定l和h，l < h，返回range index中所有在l和h之间的key。显然这个操作无法在低于O(N)的复杂度内完成（思考这是为什么）。我们将LIST的复杂度定义为T(N) + O(L)，这里的L=l-h。我们要求给出一种算法，使得T(N)是低于线性复杂度的，伪代码如下：...假设Node-List中Add-Key的执行时间是O(1)，LIST返回l, h之间共计L个keys，请问Node-List函数在LIST函数被调用的次数是

// $O(log^2 N)$

// == 针对前述数据库系统和range index，构建一个操作LIST(l, h)，即给定l和h，l < h，返回range index中所有在l和h之间的key。显然这个操作无法在低于O(N)的复杂度内完成（思考这是为什么）。我们将LIST的复杂度定义为T(N) + O(L)，这里的L=l-h。我们要求给出一种算法，使得T(N)是低于线性复杂度的，伪代码如下：...假设ADD-KEY的执行时间是O(1)，LIST返回L个keys，则LIST的算法复杂度是

// $O(log^2 N) + O(L)$

// == 需要构建一个数据系统。为了让数据库系统能高效存储和获取数据，需要为数据库构建range index（区域索引）。该区域索引要求：（1）单次插入时间低于O(n)，以满足Web程序的高负载特性；（2）能够快速获得index里的最大值、最小值，即这两个操作均需小于O(n)的计算复杂度。试问下列哪一种或哪几种数据结构满足要求。

// BST, AVL Tree

== 12.1-4: 对于一棵有n个结点的树，请设计在O(n)时间内完成的先序遍历和后序遍历算法（注意：这里不一定是二叉树）

#algorithm({
  import algorithmic: *
  Function("PreorderTraversal", args: "root", {
    Cmt[Perform pre-order traversal of the tree]
    If(cond: "root is null", {
      Return[]
    })
    Fn[Visit][root]
    For(cond: "child in root.children", {
      CallI[PreorderTraversal][child]
    })
  })

  State[]

  Function("PostorderTraversal", args:"root", {
    Cmt[Perform post-order traversal of the tree]
    If(cond: "root is null", {
      Return[]
    })
    For(cond: "child in root.children", {
      CallI[PostorderTraversal][child]
    })
    Fn[Visit][root]
  })
})

== 12.2-2 写出BST树查找最小值和最大值的伪代码（或是Python/C代码），并证明给出的算法复杂度在O(n)内。

#algorithm({
  import algorithmic: *
  Function("FindMin", args: ("root"), {
    Cmt[Find the minimum value in a BST]
    If(cond: "root is null", {
      Return[*null*]
    })
    While(cond: "root.left is not null", {
      Assign([root], [root.left])
    })
    Return(["root.value"])
  })

  State[]

  Function("FindMax", args: ("root"), {
    Cmt[Find the maximum value in a BST]
    If(cond: "root is null", {
      Return[*null*]
    })
    While(cond: "root.right is not null", {
      Assign([root], [root.right])
    })
    Return([root.value])
  })
})

#linebreak()

在最坏情况下，BST可能退化成一条链，此时树的高度为 n，其中 n 是节点的数量。因此，在最坏情况下，算法的时间复杂度是 $O(n)$。

因此算法时间复杂度在 $O(n)$ 内。

== 12.2-3 写出BST里查找前驱的伪代码，并证明给出的算法复杂度在O(n)内。这里前驱是指给定一个key，BST比key小的最大值。

#algorithm({
  import algorithmic: *
  Function("FindPredecessor", args: ("root", "key"), {
    Cmt[Find the predecessor (maximum value smaller than key) in a BST]
    State[]
    Assign([predecessor], [*null*])

    While(cond: "root is not null", {
      If(cond: "root.value < key", {
        Assign([predecessor], [root])
        Assign([root], [root.right])
      })
      Else({
        Assign([root], [root.left])
      })
    })

    Return([predecessor.value])
  })
})

#linebreak()

在最坏情况下，BST可能退化成一条链，此时树的高度为 n。在每一次迭代中，算法都会沿着树的高度移动一个节点。

因此，在最坏情况下，算法的时间复杂度是 $O(n)$。

== 针对前述数据库系统和range index（指单选题和多选题中的系统），构建一个操作LIST(l, h)，即给定l和h，l < h，返回range index中所有在l和h之间的key。显然这个操作无法在低于O(N)的复杂度内完成（思考这是为什么）。我们将LIST的复杂度定义为T(N) + O(L)，这里的L=l-h。我们要求给出一种算法，使得T(N)是低于线性复杂度的，伪代码如下

...

=== 说明为何LIST无法低于O(N)的时间复杂度完成。

LIST 操作需要返回范围索引中在给定范围 [l, h] 内的所有键。由于我们无法事先知道树中哪些节点的键位于指定的范围内，因此必须检查所有节点以确定它们是否在范围内。这就意味着算法需要访问树中的每个节点，因此其复杂度将是树中节点数量的线性函数，即 O(N)。

=== 说明上述的LCA的用处，即LCA返回的是什么？

LCA（Lowest Common Ancestor）的返回值是范围 [l, h] 中的最近公共祖先节点。最近公共祖先是指在给定的范围内，键值既大于等于 l 又小于等于 h 的最深的节点。

在 LIST 操作中，LCA 的作用是找到范围内的一个起始点，以便从该点开始进行进一步的节点检查。

=== 证明LCA算法的正确性，从而进一步证明LIST算法的正确性

1. LCA 返回的节点 lca 一定满足 $l <= "lca.key" <= h$。
2. LCA 返回的节点 lca 是范围 [l, h] 中的最近公共祖先。
3. LCA 算法的终止条件是 `node == NIL` 或 (`l <= node.key and h >= node.key`)，确保 LCA 返回的节点一定在范围内

== 考虑平衡二叉树的概念。我们称高度为$O(lg(N))$的二叉树为平衡二叉树。请问，平衡二叉树每一个结点不是叶子就是拥有两个子结点的论断是否正确？若正确请证明，不正确请举反例。

不正确。

```
    A
   / \
  B   C
 / \   \
D   E   F
```

这是一颗平衡二叉树，但 C 节点不是叶子节点，也不拥有两个子结点。

== 考虑平衡二叉树的概念。我们称高度$O(lg(N))$的二叉树为平衡二叉树。请问：若一棵树中的每一棵子树都包含$2^k-1$个结点，这里k是整数且对应不同的子树是不同的，那么这是否是一棵平衡二叉树？若是请证明，若不是，请举反例。（提示：使用数学归纳法证明）

1. 对于高度为 1 的树，只有一个根节点，显然 $2^1 - 1 = 1$，基础情况成立。
2. 假设对于任意高度为 $h$ 的子树，包含的节点数为 $2^h - 1$。考虑高度为 $h+1$ 的树的根节点有两个子节点，它们都是高度为 $h$ 的子树。根据归纳假设，每个子树包含 $2^h - 1$ 个节点，因此整个高度为 $h+1$ 的子树包含的节点数为 $2 times (2^h - 1) + 1 = 2^(h+1) - 2 + 1 = 2^(h+1) - 1$。
3. 由归纳法可知，对于任意高度 $h$，包含 $2^h - 1$ 个节点的子树都符合条件。因此，如果一棵树中的每一棵子树都包含 $2^k-1$ 个结点，其中 $k$ 是整数，那么这棵树是一棵平衡二叉树。

== 考虑平衡二叉树的概念。我们称高度$O(lg(N))$的二叉树为平衡二叉树。请问：对于一棵树，若存在一个常量$c$，对于这棵树中的任一结点，其左右子树的高度差至多为$c$，那么这是否是一棵平衡二叉树？若是请证明，若不是，请举反例。（提示：使用数学归纳法证明，通过证明满足题干条件的树，有$n(h)>=(1+alpha)^h-1$，从而得到h的高度不超过$O(lg N)$。注意高度差$c$在这里的应用。）

1. 对于高度为 1 的树，最小节点数为 1，而 $(1 + alpha)^1 - 1 = alpha$显然成立。

2. 假设对于任意高度为 $h$ 的树，最小节点数为 $n(h) >= (1 + alpha)^h - 1$。

3. 考虑高度为 $h+1$ 的树。根据题意，该树的任一结点的左右子树高度差至多为 $c$，因此可以将树拆分成一个根节点和两个子树，每个子树的高度至多为 $h$ 或 $h-1$。

   最小节点数 $n(h+1)$ 为根节点的节点数加上两个子树的节点数之和。根据归纳假设，我们有：

   $n(h+1) >= n(h) + (1 + alpha)^h - 1 + (1 + alpha)^(h-1) - 1$

    ...