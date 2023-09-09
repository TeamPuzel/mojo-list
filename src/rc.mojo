
from memory.unsafe import Pointer
from optional import Optional

# not sure why I had to use 2 pointers
# but Mojo did not let me have nested generics
# and still store into the pointer.
struct RcPointer[T: AnyType]:
    # Modifying this externally is undefined
    # which is currently not possible to enforce
    var references: Pointer[Int]
    var storage: Pointer[T]
    
    fn __init__(inout self, value: Pointer[T], count: Int):
        self.references = Pointer[Int].alloc(1)
        self.references.store(0, 1)
        self.storage = Pointer[T].alloc(count)
        for i in range(count):
            self.storage.store(i, value.load(i))
    
    fn __init__(inout self, capacity: Int):
        self.references = Pointer[Int].alloc(1)
        self.references.store(0, 1)
        self.storage = Pointer[T].alloc(capacity)
    
    fn __init__(inout self, value: T):
        self.references = Pointer[Int].alloc(1)
        self.references.store(0, 1)
        self.storage = Pointer[T].alloc(1)
        self.storage.store(0, value)
    
    fn __copyinit__(inout self, previous: Self):
        self.references = previous.references
        self.storage = previous.storage
        self.references.store(0, self.references.load(0) + 1)
    
    fn __del__(owned self):
        self.references.store(0, self.references.load(0) - 1)
        if self.references.load(0) <= 0:
            self.references.free()
            self.storage.free()
            self.storage = Pointer[T].get_null()
    
    fn weak_ref(self) -> WeakRcPointer[T]:
        return WeakRcPointer[T](self.references, self.storage)
    
    fn load(self, index: Int) -> T:
        return self.storage.load(index)
    
    fn store(self, index: Int, value: T):
        self.storage.store(index, value)

struct WeakRcPointer[T: AnyType]:
    var references: Pointer[Int]
    var storage: Pointer[T]
    
    fn __init__(inout self, references: Pointer[Int], ptr: Pointer[T]):
        self.references = references
        self.storage = ptr
    
    fn __copyinit__(inout self, previous: Self):
        self.references = previous.references
        self.storage = previous.storage
    
    fn is_valid(self) -> Bool: return self.storage == Pointer[T].get_null()
    
    fn try_load(self, index: Int) -> Optional[T]:
        if self.is_valid(): return Optional[T](self.storage.load(index))
        else: return Optional[T]()
    
    fn try_store(self, index: Int, value: T) -> Bool:
        if self.is_valid():
            self.storage.store(index, value)
            return True
        else: return False