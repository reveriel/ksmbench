
## array

init
``` bash
a=(1 2 3)
```

set, 可以自动变长的.
``` bash
a[3]=2
```

get
``` bash
elem=${a[3]}
```

length `${#a[@]}`

``` bash
for elem in ${a[@]}; do
```



