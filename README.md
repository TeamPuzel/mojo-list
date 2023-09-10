### A basic resizable and reference counted List implementation for Mojo
Supporting `for .. in` iteration and many convenience methods such as `map`, `append`, `insert`, `remove`, `reverse`, `reversed`, `filter`, `fold`, `zip` etc.

Also includes an implementation of `Optional` and `RcPointer` which were required by the list.

You can see examples of how it can be used by looking in "test.mojo".

examples:
```nim

from list import List

fn test_append():
    var list: List[Int] = [1, 2, 3, 4]
    
    list.append(5)
    list.append([2, 2, 2])
    
    for item in list: print(item)
    # outputs 1 2 3 4 5 2 2 2

fn test_map():
    fn square(num: Int) -> Int: return num * num
    
    let list: List[Int] = [2, 2, 2]
    let squared = list.map[Int](square)
    
    for item in list: print(item)
    for item in squared: print(item)
    # outputs 2 2 2 and 4 4 4

fn test_fold():
    fn sum(acc: Int, val: Int) -> Int: return acc + val
    
    let list: List[Int] = [1, 2, 3]
    let folded = list.fold[Int](0, sum)
    
    for item in list: print(item)
    print(folded)
    # outputs 1 2 3 and 6

fn test_filter():
    fn greater(num: Int) -> Bool: return num > 2
    
    let list: List[Int] = [1, 2, 3, 4]
    let filtered = list.filter(greater)
    
    for item in list: print(item)
    for item in filtered: print(item)
    # outputs 1 2 3 4 and 3 4
```
