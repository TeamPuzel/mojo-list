
struct Optional[T: AnyType]:
    var maybe_value: T
    var wrapping: Bool
    
    fn __init__(inout self):
        self.maybe_value = rebind[T, Int](0)
        self.wrapping = False
    
    fn __init__(inout self, owned value: T):
        self.maybe_value = value
        self.wrapping = True
    
    fn unwrap(self) -> T:
        debug_assert(self.is_some(), "Unwrapped a none value")
        return self.maybe_value
    
    fn is_some(self) -> Bool: return self.wrapping
    fn is_none(self) -> Bool: return not self.wrapping
    
    fn if_some(self, then: fn(T) -> None):
        if self.is_some(): then(self.unwrap())
    
    fn if_some(self, then: fn(T) capturing -> None):
        if self.is_some(): then(self.unwrap())
    
    fn if_none(self, then: fn() -> None):
        if self.is_none(): then()
    
    fn if_none(self, then: fn() capturing -> None):
        if self.is_none(): then()