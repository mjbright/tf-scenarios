
# Problems with count:

Looking again at our count example note that if we change the default value for opfiles by removing an element
this will recreate any reordered resources - which is not what we would want !!

This demo is a simple/quick demo to demonstrate with local_file but what if this was your virtual machines !

## Initial config:

This value for opfiles would cause the creation of the 4 files

```
    default = [ "file1.txt", "file2.txt", "file3.txt", "file4.txt" ]
```

## New config:

This new value for opfiles is intended to just remove/delete the file3.txt resources

```
    default = [ "file1.txt", "file2.txt", "file4.txt" ]
```

However it would also cause deletion/recreation of file4.txt

Maybe not a problem for this file but if the resource was a virtual machine this is unlikely to be intended !



