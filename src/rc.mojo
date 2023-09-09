
from memory.unsafe import Pointer

# not sure why I had to use 2 pointers
# but Mojo did not let me have nested generics
# and still store into the pointer.
struct RcPointer[T: AnyType]:
    var references: Pointer[Int]
    var storage: Pointer[T]
    
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