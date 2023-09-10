
from rc import RcPointer
from maybe import Maybe

# TASKS:
# [x] - Figure out why insert and friends are getting ub
# [ ] - Write tests for all features
# [ ] - Optimize many of the methods
# [ ] - Implement a lazy list to help avoid copying
# [ ] - Implement a Slice type
# [ ] - Implement copy on write

struct List[T: AnyType]:
    var storage: RcPointer[T]
    var count: Int
    var capacity: Int
    
    fn __init__(inout self):
        self.count = 0
        self.capacity = 10
        self.storage = RcPointer[T](10)
    
    # where T: Copy
    fn __init__(inout self, repeating: T, count: Int):
        self.count = count
        self.capacity = count
        self.storage = RcPointer[T](count)
        for i in range(count): self.storage.store(i, repeating)
    
    fn __init__[*Ts: AnyType](inout self, owned literal: ListLiteral[Ts]):
        let req_len = len(literal)
        self.count = req_len
        self.capacity = req_len
        self.storage = RcPointer[T](req_len)
        let src = Pointer.address_of(literal).bitcast[T]()
        for i in range(req_len):
            self.storage.store(i, src.load(i))
              
    fn __getitem__(self, i: Int) -> T:
        return self.storage.load(i)
    
    fn __setitem__(inout self, i: Int, value: T):
        self.storage.store(i, value)
    
    fn __len__(self) -> Int:
        return self.count
    
    fn __iter__(self) -> ListIterator[T]:
        return ListIterator[T](self.storage, self.count)
    
    fn __moveinit__(inout self, owned previous: Self):
        self.count = previous.count
        self.capacity = previous.capacity
        self.storage = previous.storage
    
    fn copy(self) -> Self:
        var new = Self()
        new.reserve_capacity(self.count)
        for item in self: new.append(item)
        return new^
    
    @always_inline
    fn is_empty(self) -> Bool: return self.count == 0
    
    # Note this is not especially efficient without the lazy list
    fn enumerated(self) -> List[(Int, T)]:
        var buf = List[(Int, T)]()
        buf.reserve_capacity(self.count)
        for i in range(self.count):
            buf.append((i, self[i]))
        return buf^
    
    # REQUIRES(Traits) where T: Eq
    # fn __eq__(self, rhs: Self) -> Bool:
    #     if self.count != rhs.count: return False
    #     for i in range(self.count):
    #         if self[i] == rhs[i]: return False
    #     return True
    
    fn subrange(self, `from`: Int, count: Int) -> Self:
        var buf = Self()
        buf.reserve_capacity(self.count)
        for i in range(`from`, `from` + count):
            buf.append(self[i])
        return buf^
    
    @always_inline
    fn prefix(self, count: Int) -> Self:
        return self.subrange(0, count)
    
    @always_inline
    fn suffix(self, count: Int) -> Self:
        return self.subrange(self.last_index() - count, self.last_index())
    
    fn first(self, where: fn(T) -> Bool) -> Maybe[T]:
        for item in self:
            if where(item): return Maybe[T](item)
        return Maybe[T]()
    
    fn first(self, where: fn(T) capturing -> Bool) -> Maybe[T]:
        for item in self:
            if where(item): return Maybe[T](item)
        return Maybe[T]()
    
    fn all_satisfy(self, predicate: fn(T) -> Bool) -> Bool:
        for item in self:
            if not predicate(item): return False
        return True
    
    fn all_satisfy(self, predicate: fn(T) capturing -> Bool) -> Bool:
        for item in self:
            if not predicate(item): return False
        return True
    
    # REQUIRES(Traits) where T: Eq
    # fn first_index(self, of: T) -> Int:
    
    # REQUIRES(Traits) where T: Eq
    # fn contains(self, value: T) -> Bool:
    
    fn resize(inout self, by: Int):
        let new_capacity = self.capacity + by
        let new = RcPointer[T](new_capacity)
        for i in range(self.count):
            new.store(i, self.storage.load(i))
        self.storage = new
        self.capacity = new_capacity
    
    fn append(inout self, value: T):
        if self.count >= self.capacity:
            self.resize(self.capacity * 2)
        self[self.count] = value
        self.count += 1
    
    fn append(inout self, list: List[T]):
        for item in list: self.append(item)
    
    @always_inline
    fn drop_last(inout self): self.count -= 1
    
    fn remove_last(inout self) -> T:
        self.count -= 1
        return self[self.count]
    
    fn remove(inout self, at: Int) -> T:
        let ret = self[at]
        let last = self.last_index()
        self.count -= 1
        for i in range(at, last):
            self[i] = self[i + 1]
        return ret
    
    # A faster version of remove, does not need to shift elements.
    # It does so at the cost of changing the order of elements.
    fn swap_remove(inout self, at: Int) -> T:
        self[at] = self[self.last_index()]
        return self.remove_last()
    
    fn insert(inout self, value: T, at: Int):
        self.unsafe_shift_right(at)
        self[at] = value
    
    fn unsafe_shift_right(inout self, `from`: Int):
        let new_count = self.count + 1
        if self.capacity <= new_count: self.resize(new_count)
        self.count = new_count
        for i in range(self.last_index(), `from` - 1, -1):
            if i == self.last_index(): continue
            self[i + 1] = self[i]
    
    fn first(self) -> T: return self[0]
    fn last(self) -> T: return self[self.last_index()]
    
    @always_inline
    fn last_index(self) -> Int: return self.count - 1
    
    fn reversed(self) -> Self:
        var buf = Self()
        buf.reserve_capacity(self.count)
        buf.count = self.count
        
        var offset: Int = self.last_index()
        for item in self:
            buf[offset] = item
            offset -= 1
        return buf^
    
    fn reverse(inout self): self = self.reversed()
    
    fn reserve_capacity(inout self, capacity: Int):
        if self.capacity < capacity:
            self.resize(capacity)
    
    fn map[A: AnyType](self, body: fn(T) capturing -> A) -> List[A]:
        var buf = List[A]()
        buf.reserve_capacity(self.count)
        for item in self: buf.append(body(item))
        return buf^
    
    fn map[A: AnyType](self, body: fn(T) -> A) -> List[A]:
        var buf = List[A]()
        buf.reserve_capacity(self.count)
        for item in self: buf.append(body(item))
        return buf^
    
    fn for_each(self, body: fn(T) capturing -> None):
        for item in self: body(item)
    
    fn for_each(self, body: fn(T) -> None):
        for item in self: body(item)
    
    fn filter(self, body: fn(T) capturing -> Bool) -> List[T]:
        var buf = List[T]()
        for item in self:
            if body(item): buf.append(item)
        return buf^
    
    fn filter(self, body: fn(T) -> Bool) -> List[T]:
        var buf = List[T]()
        for item in self:
            if body(item): buf.append(item)
        return buf^
    
    fn fold[A: AnyType](self, owned into: A, body: fn(A, T) capturing -> A) -> A:
        var acc = into
        for item in self:
            acc = body(acc, item)
        return acc
    
    fn fold[A: AnyType](self, owned into: A, body: fn(A, T) -> A) -> A:
        var acc = into
        for item in self:
            acc = body(acc, item)
        return acc
    
    fn zip[A: AnyType, B: AnyType](self, `with`: List[A], body: fn(A, T) capturing -> B) -> List[B]:
        var least = 0
        if self.count < `with`.count: least = self.count else: least = `with`.count
        var buf = List[B]()
        buf.reserve_capacity(least)
        for i in range(least):
            buf.append(body(`with`[i], self[i]))
        return buf^
    
    fn zip[A: AnyType, B: AnyType](self, `with`: List[A], body: fn(A, T) -> B) -> List[B]:
        var least = 0
        if self.count < `with`.count: least = self.count else: least = `with`.count
        var buf = List[B]()
        buf.reserve_capacity(least)
        for i in range(least):
            buf.append(body(`with`[i], self[i]))
        return buf^
            
struct ListIterator[T: AnyType]:
    var offset: Int
    var max: Int
    var storage: RcPointer[T]
    
    fn __init__(inout self, storage: RcPointer[T], max: Int):
        self.offset = 0
        self.max = max
        self.storage = storage
    
    fn __len__(self) -> Int:
        return self.max - self.offset
    
    fn __next__(inout self) -> T:
        let ret = self.storage.load(self.offset)
        self.offset += 1
        return ret

# REQUIRES(Traits)
# struct LazyList[T: AnyType]:
#    var list: List[T]