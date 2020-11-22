# Python GDAL

## Docker image

### Instructions

Start your Dockerfile with:

`FROM rodolfocugler/python-gdal:tag`

Copy your code to this Docker image and run using the command python3

```
COPY requirements.txt ./

RUN python3 -m pip install --no-cache-dir -r requirements.txt

COPY . .

CMD python3 app.py
```

All Orfeo Toolbox scripts can be accessed by

```
sh $ORFEO_TOOLBOX_PATH/script params
```