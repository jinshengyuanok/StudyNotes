

```python
print('hello world')
```

    hello world
    


```python
import requests
from bs4 import BeautifulSoup
rs = requests.get('http://www.gov.cn/guowuyuan/2018-06/05/content_5296381.htm')
rs.encoding = 'utf-8'
#print(rs.text)
btext = BeautifulSoup(rs.text,'html5lib')
print(btext.text)
with open("D:\\pythonGet.txt",'w') as fn:
    fn.write(btext.txt)
    fn.close();
```
