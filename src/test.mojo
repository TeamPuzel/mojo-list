
from list import List
from maybe import Maybe
# from testing import *

fn spacer():
    print("")
fn red():
    # ???
    print_no_newline(chr(27))
    print_no_newline("[31m")
fn blue():
    print_no_newline(chr(27))
    print_no_newline("[34m")
fn green():
    print_no_newline(chr(27))
    print_no_newline("[32m")
fn reset():
    print_no_newline(chr(27))
    print_no_newline("[0m")
fn test_name(str: String):
    blue()
    print("\n--- " + str + " ---")
    reset()

# Temporary test function until traits are added
fn int_list_eq(lhs: List[Int], rhs: List[Int]) -> Bool:
    if lhs.count != rhs.count: return False
    for i in range(lhs.count):
        if lhs[i] != rhs[i]: return False
    return True

fn assert_list_eq(lhs: List[Int], rhs: List[Int]):
    spacer()
    if int_list_eq(lhs, rhs):
        green()
        print_no_newline("TEST SUCCESFUL")
    else:
        red()
        print_no_newline("TEST FAILED")
    reset()

fn assert_true(condition: Bool):
    spacer()
    if condition:
        green()
        print_no_newline("TEST SUCCESFUL")
    else:
        red()
        print_no_newline("TEST FAILED")
    reset()

fn main():
    test_name("MAYBE")
    test_maybe()
    spacer()
    
    test_name("COPY")
    test_copy()
    spacer()
    
    test_name("APPEND")
    test_append()
    spacer()
    
    test_name("MAP")
    test_map()
    spacer()
    
    test_name("FILTER")
    test_filter()
    spacer()
    
    test_name("FOLD")
    test_fold()
    spacer()
    
    test_name("REVERSE")
    test_reversed()
    spacer()
    
    test_name("ZIP")
    test_zip()
    spacer()
    
    test_name("PREFIX")
    test_prefix()
    spacer()
    
    test_name("INSERT")
    test_insert()
    spacer()

fn test_append():
    let test = List[Int]([2, 2, 2])
    var list = List[Int]([1, 2, 3, 4])
    
    list.append(5)
    list.append(test)
    
    for item in list: print_no_newline(item, " ")
    assert_list_eq(list, List[Int]([1, 2, 3, 4, 5, 2, 2, 2]))

fn test_copy():
    let list = List[Int]([2, 2, 2])
    let a_copy = list.copy()
    
    for item in a_copy: print_no_newline(item, " ")
    assert_list_eq(list, a_copy)

fn test_map():
    fn square(num: Int) -> Int: return num * num
    
    let list = List[Int]([2, 2, 2])
    let squared = list.map[Int](square)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nSquared:")
    for item in squared: print_no_newline(item, " ")
    assert_list_eq(squared, List[Int]([4, 4, 4]))

fn test_filter():
    fn greater(num: Int) -> Bool: return num > 2
    
    let list = List[Int]([1, 2, 3, 4])
    let filtered = list.filter(greater)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nFiltered:")
    for item in filtered: print_no_newline(item, " ")
    assert_list_eq(filtered, List[Int]([3, 4]))

fn test_fold():
    fn sum(acc: Int, val: Int) -> Int: return acc + val
    
    let list = List[Int]([1, 2, 3])
    let folded = list.fold[Int](0, sum)
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nFolded:")
    print_no_newline(folded)
    assert_true(folded == 6)

fn test_reversed():
    let list = List[Int]([1, 2, 3])
    let reversed = list.reversed()
    
    print("List:")
    for item in list: print_no_newline(item, " ")
    print("\nReversed:")
    for item in reversed: print_no_newline(item, " ")
    assert_list_eq(reversed, List[Int]([3, 2, 1]))

fn test_zip():
    fn multiply(left: Int, right: Int) -> Int: return left * right
    
    let list1 = List[Int]([1, 2, 3])
    let list2 = List[Int]([1, 4, 8])
    
    let list3 = list1.zip[Int, Int](list2, multiply)
    
    for item in list3: print_no_newline(item, " ")
    assert_list_eq(list3, List[Int]([1, 8, 24]))

fn test_prefix():    
    let list = List[Int]([1, 2, 3, 4, 5, 6, 7, 8])
    
    let first_three = list.prefix(3)
    
    for item in first_three: print_no_newline(item, " ")
    assert_list_eq(first_three, List[Int]([1, 2, 3]))

fn test_insert():    
    var list = List[Int]([1, 3, 4, 5])
    list.insert(2, 1)
    
    for item in list: print_no_newline(item, " ")
    assert_list_eq(list, List[Int]([1, 2, 3, 4, 5]))

fn test_maybe():
    fn try_print(value: Int): print(value)
    fn handle_none(): print_no_newline("No value!")
    
    let wrapped = Maybe[Int](1)
    let none = Maybe[Int]()
    
    wrapped.if_some(try_print)
    none.if_some(try_print)
    
    wrapped.if_none(handle_none)
    none.if_none(handle_none)