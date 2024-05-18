extends StateBase
class_name ConditionalStateBase

## Invokes every process tick before other states ticks, 
## and if it's returns `true` automatcally changes state from any to this
func condition() -> bool: 
	return false;
