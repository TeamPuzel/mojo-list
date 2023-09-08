
from list import List

fn main():
    print("APPEND:")
    test_append()
    print("MAP:")
    test_map()
    print("FILTER:")
    test_filter()
    print("FOLD:")
    test_fold()

fn test_append():
    let test = List[Int]([2, 2, 2])
    var list = List[Int]([1, 2, 3, 4])
    
    list.append(5)
    list.append(test)
    
    for item in list:
        print(item)
    
    list.free()
    test.free()

fn test_map():
    fn double(num: Int) -> Int: return num * num
    
    let list = List[Int]([2, 2, 2])
    let doubled = list.map[Int](double)
    
    print("List:")
    for item in list:
        print(item)
    print("Doubled:")
    for item in doubled:
        print(item)
    
    list.free()
    doubled.free()

fn test_filter():
    fn greater(num: Int) -> Bool: return num > 2
    
    let list = List[Int]([1, 2, 3, 4])
    let filtered = list.filter(greater)
    
    print("List:")
    for item in list:
        print(item)
    print("Filtered:")
    for item in filtered:
        print(item)
    
    list.free()
    filtered.free()

fn test_fold():
    fn sum(acc: Int, val: Int) -> Int: return acc + val
    
    let list = List[Int]([1, 2, 3])
    let folded = list.fold[Int](0, sum)
    
    print("List:")
    for item in list:
        print(item)
    print("Folded:")
    print(folded)
    
    list.free()
