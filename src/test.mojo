
from list import List
from maybe import Maybe
from testing import *

fn spacer(): print("")

fn main():
    print("\n - MAYBE")
    test_maybe()
    spacer()
    
    print("\n - COPY")
    test_copy()
    spacer()
    
    print("\n - APPEND:")
    test_append()
    spacer()
    
    print("\n - MAP:")
    test_map()
    spacer()
    
    print("\n - FILTER:")
    test_filter()
    spacer()
    
    print("\n - FOLD:")
    test_fold()
    spacer()
    
    print("\n - REVERSED:")
    test_reversed()
    spacer()
    
    print("\n - ZIP:")
    test_zip()
    spacer()
    
    print("\n - PREFIX")
    test_prefix()
    spacer()

fn test_append():
    let test = List[Int]([2, 2, 2])
    var list = List[Int]([1, 2, 3, 4])
    
    list.append(5)
    list.append(test)
    
    for item in list: print_no_newline(item, " ")

fn test_copy():
    let list = List[Int]([2, 2, 2])
    let a_copy = list.copy()
    
    for item in a_copy: print_no_newline(item, " ")

fn test_map():
    fn square(num: Int) -> Int: return num * num
    
    let list = List[Int]([2, 2, 2])
    let squared = list.map[Int](square)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nSquared:")
    for item in squared: print_no_newline(item, " ")

fn test_filter():
    fn greater(num: Int) -> Bool: return num > 2
    
    let list = List[Int]([1, 2, 3, 4])
    let filtered = list.filter(greater)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nFiltered:")
    for item in filtered: print_no_newline(item, " ")

fn test_fold():
    fn sum(acc: Int, val: Int) -> Int: return acc + val
    
    let list = List[Int]([1, 2, 3])
    let folded = list.fold[Int](0, sum)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nFolded:")
    print_no_newline(folded)

fn test_reversed():
    let list = List[Int]([1, 2, 3])
    let reversed = list.reversed()
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nReversed:")
    for item in reversed: print_no_newline(item, " ")

fn test_zip():
    fn multiply(left: Int, right: Int) -> Int: return left * right
    
    let list1 = List[Int]([1, 2, 3])
    let list2 = List[Int]([1, 4, 8])
    
    let list3 = list1.zip[Int, Int](list2, multiply)
    
    for item in list3: print_no_newline(item, " ")

fn test_prefix():    
    let list = List[Int]([1, 2, 3, 4, 5, 6, 7, 8])
    
    let first_three = list.prefix(3)
    
    for item in first_three: print_no_newline(item, " ")

fn test_maybe():
    fn try_print(value: Int): print(value)
    fn handle_none(): print("Oh no, no value!")
    
    let wrapped = Maybe[Int](1)
    let none = Maybe[Int]()
    
    wrapped.if_some(try_print)
    none.if_some(try_print)
    
    wrapped.if_none(handle_none)
    none.if_none(handle_none)